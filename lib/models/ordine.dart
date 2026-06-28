class Ordine {
  final int? id;
  final int serataId;
  final int numero;
  final DateTime dataOra;
  final List<OrdineItem> items;
  final double totale;

  Ordine({
    this.id,
    required this.serataId,
    this.numero = 0,
    required this.dataOra,
    this.items = const [],
    this.totale = 0.0,
  });

  Ordine copyWith({
    int? id,
    int? serataId,
    int? numero,
    DateTime? dataOra,
    List<OrdineItem>? items,
    double? totale,
  }) {
    return Ordine(
      id: id ?? this.id,
      serataId: serataId ?? this.serataId,
      numero: numero ?? this.numero,
      dataOra: dataOra ?? this.dataOra,
      items: items ?? this.items,
      totale: totale ?? this.totale,
    );
  }
}

class OrdineItem {
  final int? id;
  final int ordineId;
  final int prodottoId;
  final String prodottoNome;
  final double prezzoUnitario;
  final int quantita;

  OrdineItem({
    this.id,
    required this.ordineId,
    required this.prodottoId,
    required this.prodottoNome,
    required this.prezzoUnitario,
    this.quantita = 1,
  });

  double get totale => prezzoUnitario * quantita;

  OrdineItem copyWith({
    int? id,
    int? ordineId,
    int? prodottoId,
    String? prodottoNome,
    double? prezzoUnitario,
    int? quantita,
  }) {
    return OrdineItem(
      id: id ?? this.id,
      ordineId: ordineId ?? this.ordineId,
      prodottoId: prodottoId ?? this.prodottoId,
      prodottoNome: prodottoNome ?? this.prodottoNome,
      prezzoUnitario: prezzoUnitario ?? this.prezzoUnitario,
      quantita: quantita ?? this.quantita,
    );
  }
}