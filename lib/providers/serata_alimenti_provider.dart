import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/serata_alimento.dart';
import 'serate_provider.dart';

part 'serata_alimenti_provider.g.dart';

@riverpod
class SerataAlimentiNotifier extends _$SerataAlimentiNotifier {
  @override
  Future<List<SerataAlimentoEntry>> build(int serataId) async {
    final db = ref.watch(databaseProvider);
    final rows = await db.getAlimentiBySerata(serataId);
    return rows
        .map((r) => SerataAlimentoEntry(
              id: r.id,
              alimentoId: r.alimentoId,
              prezzo: r.prezzo,
              quantita: r.quantita,
            ))
        .toList();
  }

  Future<void> addAlimento(int alimentoId, double prezzo, [int quantita = 0]) async {
    final db = ref.read(databaseProvider);
    await db.insertSerataAlimento(serataId, alimentoId, prezzo, quantita);
    ref.invalidateSelf();
  }

  Future<void> removeAlimento(int alimentoId) async {
    final db = ref.read(databaseProvider);
    await db.deleteSerataAlimento(serataId, alimentoId);
    ref.invalidateSelf();
  }

  Future<void> updatePrezzo(int alimentoId, double prezzo) async {
    final db = ref.read(databaseProvider);
    await db.updateSerataAlimentoPrezzo(serataId, alimentoId, prezzo);
    ref.invalidateSelf();
  }

  Future<void> updateQuantita(int alimentoId, int quantita) async {
    final db = ref.read(databaseProvider);
    await db.updateSerataAlimentoQuantita(serataId, alimentoId, quantita);
    ref.invalidateSelf();
  }

  Future<void> copyFromSerata(int fromSerataId) async {
    final db = ref.read(databaseProvider);
    await db.deleteAllSerataAlimenti(serataId);
    await db.copySerataAlimenti(fromSerataId, serataId);
    ref.invalidateSelf();
  }
}
