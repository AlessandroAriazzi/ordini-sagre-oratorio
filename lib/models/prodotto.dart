class Prodotto {
  final int? id;
  final String nome;
  final double prezzo;
  final int menuId;
  final String categoria;
  final int quantita; // NUOVO CAMPO

  Prodotto({
    this.id,
    required this.nome,
    required this.prezzo,
    required this.menuId,
    required this.categoria,
    this.quantita = 0, // Default a 0
  });

  Prodotto copyWith({
    int? id,
    String? nome,
    double? prezzo,
    int? menuId,
    String? categoria,
    int? quantita,
  }) {
    return Prodotto(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      prezzo: prezzo ?? this.prezzo,
      menuId: menuId ?? this.menuId,
      categoria: categoria ?? this.categoria,
      quantita: quantita ?? this.quantita,
    );
  }

  bool get isEsaurito => quantita <= 0;
}