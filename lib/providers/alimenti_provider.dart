import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../models/alimento.dart';
import 'serate_provider.dart';

part 'alimenti_provider.g.dart';

@riverpod
class AlimentiNotifier extends _$AlimentiNotifier {
  @override
  Future<List<Alimento>> build() async {
    final db = ref.watch(databaseProvider);
    final rows = await db.getAllAlimenti();
    return rows
        .map((a) => Alimento(
              id: a.id,
              nome: a.nome,
              categoria: a.categoria,
              prezzoDefault: a.prezzoDefault,
            ))
        .toList();
  }

  Future<void> addAlimento(String nome, String categoria, double prezzoDefault) async {
    final db = ref.read(databaseProvider);
    await db.insertAlimento(AlimentiCompanion(
      nome: drift.Value(nome),
      categoria: drift.Value(categoria),
      prezzoDefault: drift.Value(prezzoDefault),
    ));
    ref.invalidateSelf();
  }

  Future<void> updateAlimento(Alimento alimento) async {
    final db = ref.read(databaseProvider);
    await db.updateAlimento(AlimentiCompanion(
      id: drift.Value(alimento.id!),
      nome: drift.Value(alimento.nome),
      categoria: drift.Value(alimento.categoria),
      prezzoDefault: drift.Value(alimento.prezzoDefault),
    ));
    ref.invalidateSelf();
  }

  Future<void> deleteAlimento(int id) async {
    final db = ref.read(databaseProvider);
    await db.deleteAlimento(id);
    ref.invalidateSelf();
  }
}
