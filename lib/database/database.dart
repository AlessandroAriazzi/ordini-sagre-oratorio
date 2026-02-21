import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('SerataData')
class Serate extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get titolo => text()();
  DateTimeColumn get data => dateTime()();
  IntColumn get menuId => integer().nullable()();
}

@DataClassName('MenuData')
class Menus extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
}

@DataClassName('ProdottoData')
class Prodotti extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  RealColumn get prezzo => real()();
  IntColumn get menuId => integer()();
  TextColumn get categoria => text()();
  IntColumn get quantita => integer().withDefault(const Constant(0))(); // NUOVO CAMPO
}

@DataClassName('OrdineData')
class Ordini extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serataId => integer()();
  DateTimeColumn get dataOra => dateTime()();
  RealColumn get totale => real()();
}

@DataClassName('OrdiniItem')
class OrdiniItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordineId => integer()();
  IntColumn get prodottoId => integer()();
  TextColumn get prodottoNome => text()();
  RealColumn get prezzoUnitario => real()();
  IntColumn get quantita => integer()();
}

@DriftDatabase(tables: [Serate, Menus, Prodotti, Ordini, OrdiniItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2; // Incrementato per la migrazione

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Aggiungi la colonna quantita alla tabella prodotti
          await m.addColumn(prodotti, prodotti.quantita);
        }
      },
    );
  }

  // Serate
  Future<List<SerataData>> getAllSerate() async => select(serate).get();
  Future<SerataData> getSerata(int id) => (select(serate)..where((s) => s.id.equals(id))).getSingle();
  Future<int> insertSerata(SerateCompanion serata) => into(serate).insert(serata);
  Future<bool> updateSerata(SerateCompanion serata) => update(serate).replace(serata);
  Future<int> deleteSerata(int id) => (delete(serate)..where((s) => s.id.equals(id))).go();

  // Menus
  Future<List<MenuData>> getAllMenus() => select(menus).get();
  Future<MenuData> getMenu(int id) => (select(menus)..where((m) => m.id.equals(id))).getSingle();
  Future<int> insertMenu(MenusCompanion menu) => into(menus).insert(menu);
  Future<bool> updateMenu(MenusCompanion menu) => update(menus).replace(menu);
  Future<int> deleteMenu(int id) => (delete(menus)..where((m) => m.id.equals(id))).go();

  // Prodotti
  Future<List<ProdottoData>> getProdottiByMenu(int menuId) => 
    (select(prodotti)..where((p) => p.menuId.equals(menuId))).get();
  Future<ProdottoData> getProdotto(int id) => 
    (select(prodotti)..where((p) => p.id.equals(id))).getSingle();
  Future<int> insertProdotto(ProdottiCompanion prodotto) => into(prodotti).insert(prodotto);
  Future<bool> updateProdotto(ProdottiCompanion prodotto) => update(prodotti).replace(prodotto);
  Future<int> deleteProdotto(int id) => (delete(prodotti)..where((p) => p.id.equals(id))).go();

  // Aggiorna quantità prodotto
  Future<void> updateProdottoQuantita(int id, int quantita) async {
    final prodotto = await getProdotto(id);
    await updateProdotto(ProdottiCompanion(
      id: Value(id),
      nome: Value(prodotto.nome),
      prezzo: Value(prodotto.prezzo),
      menuId: Value(prodotto.menuId),
      categoria: Value(prodotto.categoria),
      quantita: Value(quantita),
    ));
  }

  // Ordini
  Future<List<OrdineData>> getOrdiniBySerata(int serataId) => 
    (select(ordini)..where((o) => o.serataId.equals(serataId))).get();
  Future<int> insertOrdine(OrdiniCompanion ordine) => into(ordini).insert(ordine);
  Future<bool> updateOrdine(OrdiniCompanion ordine) => update(ordini).replace(ordine);
  Future<int> deleteOrdine(int id) => (delete(ordini)..where((o) => o.id.equals(id))).go();

  // Ordini Items
  Future<List<OrdiniItem>> getItemsByOrdine(int ordineId) => 
    (select(ordiniItems)..where((i) => i.ordineId.equals(ordineId))).get();
  Future<int> insertOrdineItem(OrdiniItemsCompanion item) => into(ordiniItems).insert(item);
  Future<bool> updateOrdineItem(OrdiniItemsCompanion item) => update(ordiniItems).replace(item);
  Future<int> deleteOrdineItem(int id) => (delete(ordiniItems)..where((i) => i.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'festa_ordini.sqlite'));
    debugPrint('Database path: ${file.path}');
    return NativeDatabase(file);
  });
}