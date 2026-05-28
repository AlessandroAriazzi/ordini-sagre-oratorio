import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../models/serata.dart' as models;

part 'serate_provider.g.dart';

@riverpod
AppDatabase database(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

@riverpod
class SerateNotifier extends _$SerateNotifier {
  @override
  Future<List<models.Serata>> build() async {
    final db = ref.watch(databaseProvider);
    final serate = await db.getAllSerate();
    return serate.map((s) => models.Serata(
      id: s.id,
      titolo: s.titolo,
      data: s.data,
      menuId: s.menuId,
    )).toList();
  }

  Future<void> addSerata(String titolo, DateTime data) async {
    final db = ref.read(databaseProvider);
    await db.insertSerata(SerateCompanion(
      titolo: drift.Value(titolo),
      data: drift.Value(data),
    ));
    ref.invalidateSelf();
  }

  Future<void> updateSerata(models.Serata serata) async {
    final db = ref.read(databaseProvider);
    await db.updateSerata(SerateCompanion(
      id: drift.Value(serata.id!),
      titolo: drift.Value(serata.titolo),
      data: drift.Value(serata.data),
      menuId: drift.Value(serata.menuId),
    ));
    ref.invalidateSelf();
  }

  Future<void> deleteSerata(int id) async {
    final db = ref.read(databaseProvider);
    await db.deleteSerata(id);
    ref.invalidateSelf();
  }

  Future<void> assignMenuToSerata(int serataId, int menuId) async {
    final db = ref.read(databaseProvider);
    final serata = await db.getSerata(serataId);
    await db.updateSerata(SerateCompanion(
      id: drift.Value(serataId),
      titolo: drift.Value(serata.titolo),
      data: drift.Value(serata.data),
      menuId: drift.Value(menuId),
    ));
    ref.invalidateSelf();
  }
}