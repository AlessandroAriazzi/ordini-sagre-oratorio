class Serata {
  final int? id;
  final String titolo;
  final DateTime data;

  Serata({
    this.id,
    required this.titolo,
    required this.data,
  });

  Serata copyWith({
    int? id,
    String? titolo,
    DateTime? data,
  }) {
    return Serata(
      id: id ?? this.id,
      titolo: titolo ?? this.titolo,
      data: data ?? this.data,
    );
  }
}
