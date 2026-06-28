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
}

@DataClassName('AlimentoData')
class Alimenti extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get categoria => text()();
  RealColumn get prezzoDefault => real()();
}

@DataClassName('SerataAlimentoData')
class SerataAlimenti extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serataId => integer()();
  IntColumn get alimentoId => integer()();
  RealColumn get prezzo => real()();
  IntColumn get quantita => integer().withDefault(const Constant(0))();
}

@DataClassName('OrdineData')
class Ordini extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serataId => integer()();
  IntColumn get numero => integer().withDefault(const Constant(0))();
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

@DriftDatabase(tables: [Serate, Alimenti, SerataAlimenti, Ordini, OrdiniItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await customStatement(
            'ALTER TABLE "prodotti" ADD COLUMN "quantita" INTEGER NOT NULL DEFAULT 0',
          );
        }
        if (from < 3) {
          await customStatement('''
            CREATE TABLE IF NOT EXISTS "serata_prodotti_quantita" (
              "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              "serata_id" INTEGER NOT NULL,
              "prodotto_id" INTEGER NOT NULL,
              "quantita" INTEGER NOT NULL DEFAULT 0
            )
          ''');
          await customStatement('''
            CREATE TABLE "prodotti_new" (
              "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              "nome" TEXT NOT NULL,
              "prezzo" REAL NOT NULL,
              "menu_id" INTEGER NOT NULL,
              "categoria" TEXT NOT NULL
            )
          ''');
          await customStatement(
            'INSERT INTO "prodotti_new" SELECT "id", "nome", "prezzo", "menu_id", "categoria" FROM "prodotti"',
          );
          await customStatement('DROP TABLE "prodotti"');
          await customStatement('ALTER TABLE "prodotti_new" RENAME TO "prodotti"');
        }
        if (from < 4) {
          await customStatement('''
            CREATE TABLE "alimenti" (
              "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              "nome" TEXT NOT NULL,
              "categoria" TEXT NOT NULL,
              "prezzo_default" REAL NOT NULL
            )
          ''');
          await customStatement(
            'INSERT INTO "alimenti" SELECT "id","nome","categoria","prezzo" FROM "prodotti"',
          );
          await customStatement('''
            CREATE TABLE "serata_alimenti" (
              "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              "serata_id" INTEGER NOT NULL,
              "alimento_id" INTEGER NOT NULL,
              "prezzo" REAL NOT NULL DEFAULT 0,
              "quantita" INTEGER NOT NULL DEFAULT 0
            )
          ''');
          await customStatement('''
            INSERT INTO "serata_alimenti" ("serata_id","alimento_id","prezzo","quantita")
            SELECT spq."serata_id", spq."prodotto_id", COALESCE(p."prezzo", 0), spq."quantita"
            FROM "serata_prodotti_quantita" spq
            LEFT JOIN "prodotti" p ON p."id" = spq."prodotto_id"
          ''');
          await customStatement('''
            CREATE TABLE "serate_new" (
              "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              "titolo" TEXT NOT NULL,
              "data" INTEGER NOT NULL
            )
          ''');
          await customStatement('INSERT INTO "serate_new" SELECT "id","titolo","data" FROM "serate"');
          await customStatement('DROP TABLE "serate"');
          await customStatement('ALTER TABLE "serate_new" RENAME TO "serate"');
          await customStatement('DROP TABLE IF EXISTS "menus"');
          await customStatement('DROP TABLE IF EXISTS "prodotti"');
          await customStatement('DROP TABLE IF EXISTS "serata_prodotti_quantita"');
        }
        if (from < 5) {
          await customStatement(
            'ALTER TABLE "ordini" ADD COLUMN "numero" INTEGER NOT NULL DEFAULT 0',
          );
          await customStatement('''
            UPDATE "ordini" SET "numero" = (
              SELECT COUNT(*) FROM "ordini" o2
              WHERE o2."serata_id" = "ordini"."serata_id" AND o2."id" <= "ordini"."id"
            )
          ''');
        }
        if (from < 6) {
          await customStatement('''
            UPDATE "ordini" SET "numero" = (
              SELECT COUNT(*) FROM "ordini" o2
              WHERE o2."serata_id" = "ordini"."serata_id" AND o2."id" <= "ordini"."id"
            ) WHERE "numero" = 0
          ''');
        }
      },
    );
  }

  // Serate
  Future<List<SerataData>> getAllSerate() async =>
      (select(serate)..orderBy([(s) => OrderingTerm(expression: s.data, mode: OrderingMode.desc)])).get();
  Future<SerataData> getSerata(int id) =>
      (select(serate)..where((s) => s.id.equals(id))).getSingle();
  Future<int> insertSerata(SerateCompanion s) => into(serate).insert(s);
  Future<bool> updateSerata(SerateCompanion s) => update(serate).replace(s);
  Future<int> deleteSerata(int id) =>
      (delete(serate)..where((s) => s.id.equals(id))).go();

  // Alimenti
  Future<List<AlimentoData>> getAllAlimenti() =>
      (select(alimenti)..orderBy([(a) => OrderingTerm(expression: a.nome)])).get();
  Future<AlimentoData> getAlimento(int id) =>
      (select(alimenti)..where((a) => a.id.equals(id))).getSingle();
  Future<int> insertAlimento(AlimentiCompanion a) => into(alimenti).insert(a);
  Future<bool> updateAlimento(AlimentiCompanion a) => update(alimenti).replace(a);
  Future<int> deleteAlimento(int id) =>
      (delete(alimenti)..where((a) => a.id.equals(id))).go();

  // SerataAlimenti
  Future<List<SerataAlimentoData>> getAlimentiBySerata(int serataId) =>
      (select(serataAlimenti)..where((sa) => sa.serataId.equals(serataId))).get();

  Future<SerataAlimentoData?> getSerataAlimento(int serataId, int alimentoId) =>
      (select(serataAlimenti)
            ..where((sa) => sa.serataId.equals(serataId) & sa.alimentoId.equals(alimentoId)))
          .getSingleOrNull();

  Future<void> insertSerataAlimento(int serataId, int alimentoId, double prezzo, int quantita) async {
    await into(serataAlimenti).insert(SerataAlimentiCompanion(
      serataId: Value(serataId),
      alimentoId: Value(alimentoId),
      prezzo: Value(prezzo),
      quantita: Value(quantita),
    ));
  }

  Future<void> updateSerataAlimentoQuantita(int serataId, int alimentoId, int quantita) async {
    await (update(serataAlimenti)
          ..where((sa) => sa.serataId.equals(serataId) & sa.alimentoId.equals(alimentoId)))
        .write(SerataAlimentiCompanion(quantita: Value(quantita)));
  }

  Future<void> updateSerataAlimentoPrezzo(int serataId, int alimentoId, double prezzo) async {
    await (update(serataAlimenti)
          ..where((sa) => sa.serataId.equals(serataId) & sa.alimentoId.equals(alimentoId)))
        .write(SerataAlimentiCompanion(prezzo: Value(prezzo)));
  }

  Future<void> deleteSerataAlimento(int serataId, int alimentoId) async {
    await (delete(serataAlimenti)
          ..where((sa) => sa.serataId.equals(serataId) & sa.alimentoId.equals(alimentoId)))
        .go();
  }

  Future<void> deleteAllSerataAlimenti(int serataId) async {
    await (delete(serataAlimenti)..where((sa) => sa.serataId.equals(serataId))).go();
  }

  Future<void> copySerataAlimenti(int fromSerataId, int toSerataId) async {
    final rows = await getAlimentiBySerata(fromSerataId);
    for (final row in rows) {
      await insertSerataAlimento(toSerataId, row.alimentoId, row.prezzo, row.quantita);
    }
  }

  // Ordini
  Future<List<OrdineData>> getOrdiniBySerata(int serataId) =>
      (select(ordini)..where((o) => o.serataId.equals(serataId))).get();
  Future<int> insertOrdine(OrdiniCompanion ordine) => into(ordini).insert(ordine);
  Future<int> updateOrdine(OrdiniCompanion ordine) =>
      (update(ordini)..where((o) => o.id.equals(ordine.id.value))).write(ordine);
  Future<int> deleteOrdine(int id) =>
      (delete(ordini)..where((o) => o.id.equals(id))).go();

  // Ordini Items
  Future<List<OrdiniItem>> getItemsByOrdine(int ordineId) =>
      (select(ordiniItems)..where((i) => i.ordineId.equals(ordineId))).get();
  Future<int> insertOrdineItem(OrdiniItemsCompanion item) =>
      into(ordiniItems).insert(item);
  Future<bool> updateOrdineItem(OrdiniItemsCompanion item) =>
      update(ordiniItems).replace(item);
  Future<int> deleteOrdineItem(int id) =>
      (delete(ordiniItems)..where((i) => i.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'festa_ordini.sqlite'));
    debugPrint('Database path: ${file.path}');
    return NativeDatabase(file);
  });
}
