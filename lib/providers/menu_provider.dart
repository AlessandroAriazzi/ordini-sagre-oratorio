import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../models/menu.dart' as models;
import '../models/prodotto.dart' as models;
import 'serate_provider.dart';

part 'menu_provider.g.dart';

@riverpod
class MenusNotifier extends _$MenusNotifier {
  @override
  Future<List<models.Menu>> build() async {
    final db = ref.watch(databaseProvider);
    final menus = await db.getAllMenus();
    
    final result = <models.Menu>[];
    for (final menu in menus) {
      final prodotti = await db.getProdottiByMenu(menu.id);
      result.add(models.Menu(
        id: menu.id,
        nome: menu.nome,
        prodotti: prodotti.map((p) => models.Prodotto(
          id: p.id,
          nome: p.nome,
          prezzo: p.prezzo,
          menuId: p.menuId,
          categoria: p.categoria,
          quantita: p.quantita,
        )).toList(),
      ));
    }
    return result;
  }

  Future<void> addMenu(String nome) async {
    final db = ref.read(databaseProvider);
    await db.insertMenu(MenusCompanion(
      nome: drift.Value(nome),
    ));
    ref.invalidateSelf();
  }

  Future<void> updateMenu(models.Menu menu) async {
    final db = ref.read(databaseProvider);
    await db.updateMenu(MenusCompanion(
      id: drift.Value(menu.id!),
      nome: drift.Value(menu.nome),
    ));
    ref.invalidateSelf();
  }

  Future<void> deleteMenu(int id) async {
    final db = ref.read(databaseProvider);
    await db.deleteMenu(id);
    ref.invalidateSelf();
  }

  Future<void> addProdotto(int menuId, String nome, double prezzo, String categoria, int quantita) async {
    final db = ref.read(databaseProvider);
    await db.insertProdotto(ProdottiCompanion(
      nome: drift.Value(nome),
      prezzo: drift.Value(prezzo),
      menuId: drift.Value(menuId),
      categoria: drift.Value(categoria),
      quantita: drift.Value(quantita),
    ));
    ref.invalidateSelf();
  }

  Future<void> updateProdotto(models.Prodotto prodotto) async {
    final db = ref.read(databaseProvider);
    await db.updateProdotto(ProdottiCompanion(
      id: drift.Value(prodotto.id!),
      nome: drift.Value(prodotto.nome),
      prezzo: drift.Value(prodotto.prezzo),
      menuId: drift.Value(prodotto.menuId),
      categoria: drift.Value(prodotto.categoria),
      quantita: drift.Value(prodotto.quantita),
    ));
    ref.invalidateSelf();
  }

  Future<void> updateProdottoQuantita(int prodottoId, int quantita) async {
    final db = ref.read(databaseProvider);
    await db.updateProdottoQuantita(prodottoId, quantita);
    ref.invalidateSelf();
  }

  Future<void> deleteProdotto(int id) async {
    final db = ref.read(databaseProvider);
    await db.deleteProdotto(id);
    ref.invalidateSelf();
  }
}

@riverpod
Future<models.Menu?> menuById(Ref ref, int menuId) async {
  final menus = await ref.watch(menusProvider.future);
  try {
    final menuList = menus.where((m) => m.id == menuId).toList();
    return menuList.isNotEmpty ? menuList.first : null;
  } catch (e) {
    return null;
  }
}