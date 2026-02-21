import 'prodotto.dart';

class Menu {
  final int? id;
  final String nome;
  final List<Prodotto> prodotti;

  Menu({
    this.id,
    required this.nome,
    this.prodotti = const [],
  });

  Menu copyWith({
    int? id,
    String? nome,
    List<Prodotto>? prodotti,
  }) {
    return Menu(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      prodotti: prodotti ?? this.prodotti,
    );
  }
}