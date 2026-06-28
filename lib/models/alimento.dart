class Alimento {
  final int? id;
  final String nome;
  final String categoria;
  final double prezzoDefault;

  Alimento({
    this.id,
    required this.nome,
    required this.categoria,
    required this.prezzoDefault,
  });

  Alimento copyWith({
    int? id,
    String? nome,
    String? categoria,
    double? prezzoDefault,
  }) {
    return Alimento(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      prezzoDefault: prezzoDefault ?? this.prezzoDefault,
    );
  }
}
