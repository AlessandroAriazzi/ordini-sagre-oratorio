class Serata {
  final int? id;
  final String titolo;
  final DateTime data;
  final int? menuId;

  Serata({
    this.id,
    required this.titolo,
    required this.data,
    this.menuId,
  });

  Serata copyWith({
    int? id,
    String? titolo,
    DateTime? data,
    int? menuId,
  }) {
    return Serata(
      id: id ?? this.id,
      titolo: titolo ?? this.titolo,
      data: data ?? this.data,
      menuId: menuId ?? this.menuId,
    );
  }
}