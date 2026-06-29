import 'dart:ui';

class CategoryColors {
  static const Color primi = Color(0xFFE3F2FD);
  static const Color secondi = Color(0xFFDCECC9);
  static const Color contorni = Color(0xFFF6E6B4);
  static const Color dolci = Color(0xFFF8D7E6);
  static const Color bevande = Color(0xFFD7F3F0);
  static const Color tortaFritta = Color(0xFFF2D0A9);

  static const Map<String, Color> categoryAccents = {
    'Primo':        Color(0xFF006C49),
    'Secondo':      Color(0xFF005AA3),
    'Contorno':     Color(0xFF6D4C41),
    'Torta fritta': Color(0xFFF59E0B),
    'Bevanda':      Color(0xFF6366F1),
    'Dolce':        Color(0xFFEC4899),
  };

  static const Color _fallback = Color(0xFF45464D);

  static Color accentFor(String cat) => categoryAccents[cat] ?? _fallback;
}