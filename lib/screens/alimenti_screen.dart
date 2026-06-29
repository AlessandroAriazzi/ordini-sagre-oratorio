import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../enums/category_colors.dart';
import '../models/alimento.dart';
import '../providers/alimenti_provider.dart';
import '../theme.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────
const _surface      = Color(0xFFF7F9FB);
const _white        = Color(0xFFFFFFFF);
const _onSurface    = Color(0xFF191C1E);
const _onSurfaceVar = Color(0xFF45464D);
const _outline      = Color(0xFF76777D);
const _outlineVar   = Color(0xFFC6C6CD);
const _primary      = Color(0xFF000000);
const _danger       = Color(0xFFBA1A1A);
// ──────────────────────────────────────────────────────────────────────────────

const _categorie = ['Primo', 'Secondo', 'Contorno', 'Torta fritta', 'Bevanda', 'Dolce'];



class AlimentiScreen extends ConsumerStatefulWidget {
  const AlimentiScreen({super.key});

  @override
  ConsumerState<AlimentiScreen> createState() => _AlimentiScreenState();
}

class _AlimentiScreenState extends ConsumerState<AlimentiScreen> {
  String _filtroCategoria = 'Tutti';
  String _searchQuery = '';

  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _showAlimentoDialog({Alimento? existing}) async {
    final nomeCtrl = TextEditingController(text: existing?.nome ?? '');
    final prezzoCtrl = TextEditingController(
        text: existing != null ? existing.prezzoDefault.toStringAsFixed(2) : '');
    String categoria = existing?.categoria ?? _categorie.first;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          child: SizedBox(
            width: 480,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    existing == null ? 'Nuovo Alimento' : 'Modifica Alimento',
                    style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Inserisci i dettagli dell\'alimento.',
                    style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: nomeCtrl,
                    decoration:  InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: const Icon(Icons.fastfood_rounded, size: 18),

                       focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:  BorderSide(
                            color: Colors.black.withValues(alpha: 0.5), // Colore quando è selezionato
                            width: 2,
                          ),
                        ),
                    ),
                    
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: categoria,
                    decoration:  InputDecoration(
                      labelText: 'Categoria',
                      prefixIcon: const Icon(Icons.category_rounded, size: 18),
                      
                       focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:  BorderSide(
                            color: Colors.black.withValues(alpha: 0.5), // Colore quando è selezionato
                            width: 2,
                          ),
                        ),
                    ),
                    
                    items: _categorie
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) =>
                        setDialogState(() => categoria = v ?? _categorie.first),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: prezzoCtrl,
                    decoration:  InputDecoration(
                      labelText: 'Prezzo di default (€)',
                      prefixIcon: const Icon(Icons.euro_rounded, size: 18),
                       focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:  BorderSide(
                            color: Colors.black.withValues(alpha: 0.5), // Colore quando è selezionato
                            width: 2,
                          ),
                        ),
                    ),
                    
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Annulla', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          final nome = nomeCtrl.text.trim();
                          final prezzo =
                              double.tryParse(prezzoCtrl.text) ?? 0.0;
                          if (nome.isEmpty) return;
                          if (existing == null) {
                            ref
                                .read(alimentiProvider.notifier)
                                .addAlimento(nome, categoria, prezzo);
                          } else {
                            ref.read(alimentiProvider.notifier).updateAlimento(
                                  existing.copyWith(
                                      nome: nome,
                                      categoria: categoria,
                                      prezzoDefault: prezzo),
                                );
                          }
                          Navigator.pop(ctx);
                        },
                        icon: Icon(
                            existing == null
                                ? Icons.add_rounded
                                : Icons.check_rounded,
                            size: 16),
                        label: Text(existing == null ? 'Aggiungi' : 'Salva'),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          textStyle: GoogleFonts.inter(
                              fontSize: 13, fontWeight: FontWeight.w600),
                          shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
                          
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    nomeCtrl.dispose();
    prezzoCtrl.dispose();
  }

  void _showDeleteDialog(Alimento alimento) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Elimina alimento',
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _onSurface)),
                const SizedBox(height: 8),
                Text('Vuoi eliminare "${alimento.nome}"?',
                    style:
                        GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Annulla', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)), ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        ref
                            .read(alimentiProvider.notifier)
                            .deleteAlimento(alimento.id!);
                        Navigator.pop(ctx);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _danger,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        textStyle: GoogleFonts.inter(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Elimina'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alimentiAsync = ref.watch(alimentiProvider);

    return Scaffold(
      backgroundColor: _surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Page header ───────────────────────────────────────────────────
          Container(
            color: _surface,
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alimenti, dolci e bevande',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gestisci inventario, prezzi e categorie degli alimenti.',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: _onSurfaceVar),
                    ),
                  ],
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _showAlimentoDialog(),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text(
                    'Aggiungi Alimento',
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ),

          // ── Search + filter panel ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
            child: Container(
              decoration: BoxDecoration(
                color: _white,
                border: Border.all(color: _outlineVar),
                
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: search input + category pills
                  Row(
                    children: [
                      // Search input
                      SizedBox(
                        width: 320,
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(
                              () => _searchQuery = v.trim().toLowerCase()),
                          style: GoogleFonts.inter(
                              fontSize: 14, color: _onSurface),
                          decoration: InputDecoration(
                            hintText: 'Cerca alimento...',
                            hintStyle: GoogleFonts.inter(
                                color: _outline, fontSize: 14),
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: _outline, size: 18),
                            filled: true,
                            fillColor: _surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  const BorderSide(color: _outlineVar),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  const BorderSide(color: _outlineVar),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide:
                                  const BorderSide(color: _primary, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Category pills
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: ['Tutti', ..._categorie].map((cat) {
                              final sel = _filtroCategoria == cat;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _filtroCategoria = cat),
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 130),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: sel ? _primary : _white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: sel ? _primary : _outlineVar,
                                      ),
                                    ),
                                    child: Text(
                                      cat,
                                      style: GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: sel ? Colors.white : _onSurfaceVar,
    letterSpacing: 0.5,
  ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Row 2: sort by (right-aligned)
                  
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Table ─────────────────────────────────────────────────────────
          Expanded(
            child: alimentiAsync.when(
              data: (alimenti) {
                var filtered = _filtroCategoria == 'Tutti'
                    ? alimenti
                    : alimenti
                        .where((a) => a.categoria == _filtroCategoria)
                        .toList();

                if (_searchQuery.isNotEmpty) {
                  filtered = filtered
                      .where((a) =>
                          a.nome.toLowerCase().contains(_searchQuery))
                      .toList();
                }

                

                if (alimenti.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _surface,
                           
                            border: Border.all(color: _outlineVar),
                          ),
                          child: const Icon(Icons.restaurant_rounded,
                              size: 40, color: _outline),
                        ),
                        const SizedBox(height: 20),
                        Text('Nessun alimento',
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _onSurface)),
                        const SizedBox(height: 4),
                        Text('Aggiungi il primo alimento per iniziare.',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: _onSurfaceVar)),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: () => _showAlimentoDialog(),
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Nuovo Alimento'),
                          style: FilledButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isNotEmpty
                          ? 'Nessun risultato per "$_searchQuery".'
                          : 'Nessun alimento nella categoria "$_filtroCategoria".',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: _onSurfaceVar),
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _white,
                            border: Border.all(color: _outlineVar),
                            
                          ),
                          child: ClipRRect(
                           
                            child: Column(
                              children: [
                                // Table header
                                Container(
                                  color: _surface,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 4,
                                          child: Text('NOME',
                                              style: _headerStyle)),
                                      Expanded(
                                          flex: 2,
                                          child: Text('CATEGORIA',
                                              style: _headerStyle)),
                                      Expanded(
                                          flex: 2,
                                          child: Text('PREZZO DEFAULT',
                                              style: _headerStyle,
                                              textAlign: TextAlign.right)),
                                      SizedBox(
                                          width: 80,
                                          child: Text('AZIONI',
                                              style: _headerStyle,
                                              textAlign: TextAlign.right)),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1, color: _outlineVar),
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: filtered.length,
                                    separatorBuilder: (_, _) => const Divider(
                                        height: 1, color: _outlineVar),
                                    itemBuilder: (ctx, i) {
                                      final a = filtered[i];
                                      return _AlimentoRow(
                                        alimento: a,
                                        onEdit: () => _showAlimentoDialog(
                                            existing: a),
                                        onDelete: () =>
                                            _showDeleteDialog(a),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Footer
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 10, 28, 14),
                      child: Row(
                        children: [
                          Text(
                            'Showing ${filtered.length} of ${alimenti.length} items',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: _onSurfaceVar),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                  child: Text('Errore: $e',
                      style: const TextStyle(color: _danger))),
            ),
          ),
        ],
      ),
    );
  }

  static final _headerStyle = GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: _onSurfaceVar,
    letterSpacing: 0.5,
  );
}

class _CategoriaBadge extends StatelessWidget {
  final String categoria;
  const _CategoriaBadge(this.categoria);

  @override
  Widget build(BuildContext context) {
    final c = CategoryColors.accentFor(categoria);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: c.withValues(alpha: 0.25)),
      ),
      child: Text(categoria,
          style: GoogleFonts.jetBrainsMono(
              fontSize: 10, fontWeight: FontWeight.w600, color: c)),
    );
  }
}

class _AlimentoRow extends StatefulWidget {
  final Alimento alimento;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AlimentoRow({
    required this.alimento,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_AlimentoRow> createState() => _AlimentoRowState();
}

class _AlimentoRowState extends State<_AlimentoRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _hover ? _surface : _white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Nome
            Expanded(
              flex: 4,
              child: Text(
                widget.alimento.nome,
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Categoria badge
            Expanded(
              flex: 2,
              child: _CategoriaBadge(widget.alimento.categoria),
            ),
            // Prezzo
            Expanded(
              flex: 2,
              child: Text(
                '€ ${widget.alimento.prezzoDefault.toStringAsFixed(2)}',
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 14, color: _onSurface),
                textAlign: TextAlign.right,
              ),
            ),
            // Azioni
            SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    color: _onSurfaceVar,
                    tooltip: 'Modifica',
                    onPressed: widget.onEdit,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded,
                        size: 16),
                    color: _danger,
                    tooltip: 'Elimina',
                    onPressed: widget.onDelete,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
