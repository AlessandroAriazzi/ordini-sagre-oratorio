import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../models/ordine.dart' as models;
import 'serate_provider.dart';
import 'serata_alimenti_provider.dart';

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
        numero: ordine.numero,
        dataOra: ordine.dataOra,
        totale: ordine.totale,
        items: items
            .map((i) => models.OrdineItem(
                  id: i.id,
                  ordineId: i.ordineId,
                  prodottoId: i.prodottoId,
                  prodottoNome: i.prodottoNome,
                  prezzoUnitario: i.prezzoUnitario,
                  quantita: i.quantita,
                ))
            .toList(),
      ));
    }
    return result;
  }

  Future<int> createOrdine() async {
    final db = ref.read(databaseProvider);
    final existing = await db.getOrdiniBySerata(serataId);
    final nextNumero = existing.isEmpty
        ? 1
        : existing.map((o) => o.numero).reduce((a, b) => a > b ? a : b) + 1;
    final ordineId = await db.insertOrdine(OrdiniCompanion(
      serataId: drift.Value(serataId),
      numero: drift.Value(nextNumero),
      dataOra: drift.Value(DateTime.now()),
      totale: const drift.Value(0.0),
    ));
    ref.invalidateSelf();
    return ordineId;
  }

  Future<void> addItemToOrdine(
      int ordineId, int prodottoId, String prodottoNome, double prezzo) async {
    final db = ref.read(databaseProvider);

    final sqRow = await db.getSerataAlimento(serataId, prodottoId);
    if (sqRow != null && sqRow.quantita <= 0) {
      throw Exception('Prodotto esaurito');
    }

    final items = await db.getItemsByOrdine(ordineId);
    final existingItemList = items.where((i) => i.prodottoId == prodottoId).toList();
    final existingItem = existingItemList.isNotEmpty ? existingItemList.first : null;

    if (existingItem != null) {
      await db.updateOrdineItem(OrdiniItemsCompanion(
        id: drift.Value(existingItem.id),
        ordineId: drift.Value(ordineId),
        prodottoId: drift.Value(prodottoId),
        prodottoNome: drift.Value(prodottoNome),
        prezzoUnitario: drift.Value(prezzo),
        quantita: drift.Value(existingItem.quantita + 1),
      ));
    } else {
      await db.insertOrdineItem(OrdiniItemsCompanion(
        ordineId: drift.Value(ordineId),
        prodottoId: drift.Value(prodottoId),
        prodottoNome: drift.Value(prodottoNome),
        prezzoUnitario: drift.Value(prezzo),
        quantita: const drift.Value(1),
      ));
    }

    if (sqRow != null) {
      await db.updateSerataAlimentoQuantita(serataId, prodottoId, sqRow.quantita - 1);
      ref.invalidate(serataAlimentiProvider(serataId));
    }

    await _updateOrdineTotale(ordineId);
    ref.invalidateSelf();
  }

  Future<void> removeItemFromOrdine(int itemId, int ordineId) async {
    final db = ref.read(databaseProvider);
    final items = await db.getItemsByOrdine(ordineId);
    final item = items.firstWhere((i) => i.id == itemId);

    final sqRow = await db.getSerataAlimento(serataId, item.prodottoId);
    if (sqRow != null) {
      await db.updateSerataAlimentoQuantita(
          serataId, item.prodottoId, sqRow.quantita + item.quantita);
      ref.invalidate(serataAlimentiProvider(serataId));
    }

    await db.deleteOrdineItem(itemId);
    await _updateOrdineTotale(ordineId);
    ref.invalidateSelf();
  }

  Future<void> updateItemQuantita(int itemId, int ordineId, int nuovaQuantita) async {
    final db = ref.read(databaseProvider);
    final items = await db.getItemsByOrdine(ordineId);
    final item = items.firstWhere((i) => i.id == itemId);

    final sqRow = await db.getSerataAlimento(serataId, item.prodottoId);
    if (sqRow != null) {
      final differenza = item.quantita - nuovaQuantita;
      final nuovaSerataQuantita = sqRow.quantita + differenza;
      if (nuovaSerataQuantita < 0) {
        throw Exception('Quantità insufficiente');
      }
      await db.updateSerataAlimentoQuantita(serataId, item.prodottoId, nuovaSerataQuantita);
      ref.invalidate(serataAlimentiProvider(serataId));
    }

    await db.updateOrdineItem(OrdiniItemsCompanion(
      id: drift.Value(itemId),
      ordineId: drift.Value(ordineId),
      prodottoId: drift.Value(item.prodottoId),
      prodottoNome: drift.Value(item.prodottoNome),
      prezzoUnitario: drift.Value(item.prezzoUnitario),
      quantita: drift.Value(nuovaQuantita),
    ));

    await _updateOrdineTotale(ordineId);
    ref.invalidateSelf();
  }

  Future<void> _updateOrdineTotale(int ordineId) async {
    final db = ref.read(databaseProvider);
    final items = await db.getItemsByOrdine(ordineId);
    final totale =
        items.fold(0.0, (sum, item) => sum + (item.prezzoUnitario * item.quantita));

    final ordine =
        (await db.getOrdiniBySerata(serataId)).firstWhere((o) => o.id == ordineId);
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

    for (final item in items) {
      final sqRow = await db.getSerataAlimento(serataId, item.prodottoId);
      if (sqRow != null) {
        await db.updateSerataAlimentoQuantita(
            serataId, item.prodottoId, sqRow.quantita + item.quantita);
      }
      await db.deleteOrdineItem(item.id);
    }
    ref.invalidate(serataAlimentiProvider(serataId));

    await db.deleteOrdine(ordineId);
    ref.invalidateSelf();
  }
}
