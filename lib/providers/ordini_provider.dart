import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../models/ordine.dart' as models;
import 'serate_provider.dart';
import 'menu_provider.dart';

part 'ordini_provider.g.dart';

@riverpod
class OrdiniNotifier extends _$OrdiniNotifier {
  @override
  Future<List<models.Ordine>> build(int serataId) async {
    final db = ref.watch(databaseProvider);
    final ordini = await db.getOrdiniBySerata(serataId);
    
    final result = <models.Ordine>[];
    for (final ordine in ordini) {
      final items = await db.getItemsByOrdine(ordine.id);
      result.add(models.Ordine(
        id: ordine.id,
        serataId: ordine.serataId,
        dataOra: ordine.dataOra,
        totale: ordine.totale,
        items: items.map((i) => models.OrdineItem(
          id: i.id,
          ordineId: i.ordineId,
          prodottoId: i.prodottoId,
          prodottoNome: i.prodottoNome,
          prezzoUnitario: i.prezzoUnitario,
          quantita: i.quantita,
        )).toList(),
      ));
    }
    return result;
  }

  Future<int> createOrdine() async {
    final db = ref.read(databaseProvider);
    final ordineId = await db.insertOrdine(OrdiniCompanion(
      serataId: drift.Value(serataId),
      dataOra: drift.Value(DateTime.now()),
      totale: const drift.Value(0.0),
    ));
    ref.invalidateSelf();
    return ordineId;
  }

  Future<void> addItemToOrdine(int ordineId, int prodottoId, String prodottoNome, double prezzo) async {
    final db = ref.read(databaseProvider);
    
    // Verifica quantità disponibile
    final prodotto = await db.getProdotto(prodottoId);
    if (prodotto.quantita <= 0) {
      throw Exception('Prodotto esaurito');
    }
    
    // Check if item already exists
    final items = await db.getItemsByOrdine(ordineId);
    final existingItemList = items.where((i) => i.prodottoId == prodottoId).toList();
    final existingItem = existingItemList.isNotEmpty ? existingItemList.first : null;
    
    if (existingItem != null) {
      // Update quantity
      await db.updateOrdineItem(OrdiniItemsCompanion(
        id: drift.Value(existingItem.id),
        ordineId: drift.Value(ordineId),
        prodottoId: drift.Value(prodottoId),
        prodottoNome: drift.Value(prodottoNome),
        prezzoUnitario: drift.Value(prezzo),
        quantita: drift.Value(existingItem.quantita + 1),
      ));
    } else {
      // Add new item
      await db.insertOrdineItem(OrdiniItemsCompanion(
        ordineId: drift.Value(ordineId),
        prodottoId: drift.Value(prodottoId),
        prodottoNome: drift.Value(prodottoNome),
        prezzoUnitario: drift.Value(prezzo),
        quantita: const drift.Value(1),
      ));
    }
    
    // Aggiorna la quantità del prodotto nel menu
    await ref.read(menusProvider.notifier).updateProdottoQuantita(
      prodottoId, 
      prodotto.quantita - 1
    );
    
    await _updateOrdineTotale(ordineId);
    ref.invalidateSelf();
  }

  Future<void> removeItemFromOrdine(int itemId, int ordineId) async {
    final db = ref.read(databaseProvider);
    final items = await db.getItemsByOrdine(ordineId);
    final item = items.firstWhere((i) => i.id == itemId);
    
    // Ripristina la quantità nel prodotto
    final prodotto = await db.getProdotto(item.prodottoId);
    await ref.read(menusProvider.notifier).updateProdottoQuantita(
      item.prodottoId, 
      prodotto.quantita + item.quantita
    );
    
    await db.deleteOrdineItem(itemId);
    await _updateOrdineTotale(ordineId);
    ref.invalidateSelf();
  }

  Future<void> updateItemQuantita(int itemId, int ordineId, int nuovaQuantita) async {
    final db = ref.read(databaseProvider);
    final items = await db.getItemsByOrdine(ordineId);
    final item = items.firstWhere((i) => i.id == itemId);
    final prodotto = await db.getProdotto(item.prodottoId);
    
    final differenza = item.quantita - nuovaQuantita;
    final nuovaQuantitaProdotto = prodotto.quantita + differenza;
    
    if (nuovaQuantitaProdotto < 0) {
      throw Exception('Quantità insufficiente');
    }
    
    await db.updateOrdineItem(OrdiniItemsCompanion(
      id: drift.Value(itemId),
      ordineId: drift.Value(ordineId),
      prodottoId: drift.Value(item.prodottoId),
      prodottoNome: drift.Value(item.prodottoNome),
      prezzoUnitario: drift.Value(item.prezzoUnitario),
      quantita: drift.Value(nuovaQuantita),
    ));
    
    // Aggiorna la quantità del prodotto
    await ref.read(menusProvider.notifier).updateProdottoQuantita(
      item.prodottoId, 
      nuovaQuantitaProdotto
    );
    
    await _updateOrdineTotale(ordineId);
    ref.invalidateSelf();
  }

  Future<void> _updateOrdineTotale(int ordineId) async {
    final db = ref.read(databaseProvider);
    final items = await db.getItemsByOrdine(ordineId);
    final totale = items.fold(0.0, (sum, item) => sum + (item.prezzoUnitario * item.quantita));
    
    final ordine = (await db.getOrdiniBySerata(serataId)).firstWhere((o) => o.id == ordineId);
    await db.updateOrdine(OrdiniCompanion(
      id: drift.Value(ordineId),
      serataId: drift.Value(ordine.serataId),
      dataOra: drift.Value(ordine.dataOra),
      totale: drift.Value(totale),
    ));
  }

  Future<void> deleteOrdine(int ordineId) async {
    final db = ref.read(databaseProvider);
    final items = await db.getItemsByOrdine(ordineId);
    
    // Ripristina le quantità di tutti i prodotti dell'ordine
    for (final item in items) {
      final prodotto = await db.getProdotto(item.prodottoId);
      await ref.read(menusProvider.notifier).updateProdottoQuantita(
        item.prodottoId, 
        prodotto.quantita + item.quantita
      );
      await db.deleteOrdineItem(item.id);
    }
    
    await db.deleteOrdine(ordineId);
    ref.invalidateSelf();
  }
}