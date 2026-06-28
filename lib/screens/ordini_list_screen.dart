import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/serata.dart' as models;
import '../providers/serate_provider.dart';
import '../providers/ordini_provider.dart';
import '../theme.dart';
// ── Design tokens ─────────────────────────────────────────────────────────────
const _surface      = Color(0xFFF7F9FB);
const _white        = Color(0xFFFFFFFF);
const _onSurface    = Color(0xFF191C1E);
const _onSurfaceVar = Color(0xFF45464D);
const _outline      = Color(0xFF76777D);
const _outlineVar   = Color(0xFFC6C6CD);
const _secondary    = Color(0xFF006C49);
const _danger       = Color(0xFFBA1A1A);
const _success      = Color(0xFF10B981);
// ──────────────────────────────────────────────────────────────────────────────

class OrdiniListScreen extends ConsumerStatefulWidget {
  const OrdiniListScreen({super.key});

  @override
  ConsumerState<OrdiniListScreen> createState() => _OrdiniListScreenState();
}

class _OrdiniListScreenState extends ConsumerState<OrdiniListScreen> {
  int? _selectedId;
  bool _initialized = false;

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  void _autoSelect(List<models.Serata> serate) {
    if (_initialized || serate.isEmpty) return;
    _initialized = true;
    final today = _today();
    final upcoming = [...serate]..sort((a, b) => a.data.compareTo(b.data));
    final next = upcoming.firstWhere(
      (s) => !s.data.isBefore(today),
      orElse: () => upcoming.last,
    );
    _selectedId = next.id;
  }

  @override
  Widget build(BuildContext context) {
    final serateAsync = ref.watch(serateProvider);

    return Scaffold(
      backgroundColor: _surface,
      body: serateAsync.when(
        data: (serate) {
          if (serate.isNotEmpty && !_initialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _autoSelect(serate));
            });
          }

          final selected = _selectedId != null
              ? serate.where((s) => s.id == _selectedId).firstOrNull
              : null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(28, 18, 28, 14),
                decoration: const BoxDecoration(
                  color: _white,
                  border: Border(bottom: BorderSide(color: _outlineVar)),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ordini',
                            style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: _onSurface,
                                letterSpacing: -0.3)),
                        const SizedBox(height: 2),
                        Text('Gestisci gli ordini per ogni serata',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: _onSurfaceVar)),
                      ],
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sidebar serate
                    SizedBox(
                      width: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _white,
                            border: Border.all(color: _outlineVar),
                          ),
                          child: _Sidebar(
                            serate: serate,
                            selectedId: _selectedId,
                            onSelect: (id) => setState(() => _selectedId = id),
                            today: _today(),
                          ),
                        ),
                      ),
                    ),

                    // Right content
                    Expanded(
                      child: selected == null
                          ? _EmptyState(noData: serate.isEmpty)
                          : _OrdiniPanel(
                              key: ValueKey(selected.id),
                              serata: selected,
                            ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
            child: Text('Errore: $e',
                style: GoogleFonts.inter(color: _danger))),
      ),
    );
  }
}

// ─── Sidebar ──────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  final List<models.Serata> serate;
  final int? selectedId;
  final void Function(int) onSelect;
  final DateTime today;

  const _Sidebar({
    required this.serate,
    required this.selectedId,
    required this.onSelect,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...serate]..sort((a, b) => a.data.compareTo(b.data));
    final upcoming = sorted.where((s) => !s.data.isBefore(today)).toList();
    final past = sorted
        .where((s) => s.data.isBefore(today))
        .toList()
        .reversed
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: serate.isEmpty
              ? Center(
                  child: Text('Nessuna serata',
                      style: GoogleFonts.inter(
                          fontSize: 13, color: _onSurfaceVar)),
                )
              : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (upcoming.isNotEmpty) ...[
                      const _SectionLabel('SERATE IN PROGRAMMA'),
                      ...upcoming.map((s) => _SidebarRow(
                            serata: s,
                            isSelected: selectedId == s.id,
                            isToday: s.data.year == today.year &&
                                s.data.month == today.month &&
                                s.data.day == today.day,
                            onTap: () => onSelect(s.id!),
                          )),
                    ],
                    if (past.isNotEmpty) ...[
                      if (upcoming.isNotEmpty)
                        const Divider(height: 1, color: _outlineVar),
                      const _SectionLabel('CONCLUSE'),
                      ...past.map((s) => _SidebarRow(
                            serata: s,
                            isSelected: selectedId == s.id,
                            isToday: false,
                            onTap: () => onSelect(s.id!),
                          )),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(text,
          style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.9,
              color: _outline)),
    );
  }
}

// ─── Sidebar Row ──────────────────────────────────────────────────────────────

class _SidebarRow extends StatefulWidget {
  final models.Serata serata;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  const _SidebarRow({
    required this.serata,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
  });

  @override
  State<_SidebarRow> createState() => _SidebarRowState();
}

class _SidebarRowState extends State<_SidebarRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? _secondary.withValues(alpha: 0.06)
                : _hover
                    ? _surface
                    : _white,
            border: Border(
              left: BorderSide(
                color: widget.isSelected ? _secondary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(13, 10, 10, 10),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 13,
                  color: widget.isSelected ? _secondary : _outline),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.serata.titolo,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: widget.isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: widget.isSelected ? _secondary : _onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          DateFormat('d MMM yyyy', 'it_IT')
                              .format(widget.serata.data),
                          style: GoogleFonts.inter(
                              fontSize: 11, color: _onSurfaceVar),
                        ),
                        if (widget.isToday) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: _success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('oggi',
                                style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: _success)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  size: 16, color: _outline),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool noData;
  const _EmptyState({required this.noData});

  @override
  Widget build(BuildContext context) {
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
            child: Icon(
              noData ? Icons.event_busy_rounded : Icons.touch_app_rounded,
              size: 40,
              color: _outline,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            noData ? 'Nessuna serata' : 'Seleziona una serata',
            style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            noData
                ? 'Crea prima una serata nella sezione Gestione Serate.'
                : 'Seleziona una serata per vedere e gestire gli ordini.',
            style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar),
          ),
        ],
      ),
    );
  }
}

// ─── Ordini Panel ─────────────────────────────────────────────────────────────

class _OrdiniPanel extends ConsumerWidget {
  final models.Serata serata;

  const _OrdiniPanel({super.key, required this.serata});

  void _showDeleteOrdineDialog(
      BuildContext context, WidgetRef ref, dynamic ordine) {
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
                Text('Elimina ordine',
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _onSurface)),
                const SizedBox(height: 8),
                Text('Le quantità dei prodotti verranno ripristinate.',
                    style:
                        GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Annulla', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500))),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        ref
                            .read(ordiniProvider(serata.id!).notifier)
                            .deleteOrdine(ordine.id!);
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
  Widget build(BuildContext context, WidgetRef ref) {
    final ordiniAsync = ref.watch(ordiniProvider(serata.id!));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Serata info + actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _white,
              border: Border.all(color: _outlineVar),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(serata.titolo,
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _onSurface,
                              letterSpacing: -0.2)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 13, color: _onSurfaceVar),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('EEEE d MMMM yyyy', 'it_IT')
                                .format(serata.data),
                            style: GoogleFonts.inter(
                                fontSize: 13, color: _onSurfaceVar),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () async {
                    final ordineId = await ref
                        .read(ordiniProvider(serata.id!).notifier)
                        .createOrdine();
                    if (context.mounted) {
                      context.go('/ordine/${serata.id}/$ordineId');
                    }
                  },
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: Text('Nuovo Ordine',
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500)),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Ordini table
          ordiniAsync.when(
            data: (ordini) {
              if (ordini.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    color: _white,
                    border: Border.all(color: _outlineVar),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(Icons.receipt_long_rounded,
                            size: 36, color: _outline),
                        const SizedBox(height: 12),
                        Text('Nessun ordine',
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _onSurfaceVar)),
                        const SizedBox(height: 4),
                        Text('Crea il primo ordine per iniziare.',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: _outline)),
                      ],
                    ),
                  ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  color: _white,
                  border: Border.all(color: _outlineVar),
                ),
                child: Column(
                  children: [
                    // Table header
                    Container(
                      color: _surface,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          SizedBox(
                              width: 80,
                              child: Text('ORDINE', style: _thSt)),
                          SizedBox(
                              width: 70,
                              child: Text('ORA', style: _thSt)),
                          Expanded(child: Text('PRODOTTI', style: _thSt)),
                          SizedBox(
                              width: 110,
                              child: Text('TOTALE',
                                  style: _thSt,
                                  textAlign: TextAlign.right)),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: _outlineVar),
                    ...ordini.asMap().entries.map((e) {
                      final i = e.key;
                      final ordine = e.value;
                      return Column(
                        children: [
                          if (i > 0)
                            const Divider(height: 1, color: _outlineVar),
                          _OrdineRow(
                            ordine: ordine,
                            onTap: () => context
                                .go('/ordine/${serata.id}/${ordine.id}'),
                            onDelete: () => _showDeleteOrdineDialog(
                                context, ref, ordine),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              );
            },
            loading: () => const Center(
                child: Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator())),
            error: (e, _) => Text('Errore: $e',
                style: GoogleFonts.inter(color: _danger)),
          ),
        ],
      ),
    );
  }
}

// ─── Ordine Row ───────────────────────────────────────────────────────────────

class _OrdineRow extends StatefulWidget {
  final dynamic ordine;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _OrdineRow({
    required this.ordine,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_OrdineRow> createState() => _OrdineRowState();
}

class _OrdineRowState extends State<_OrdineRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          color: _hover ? _surface : _white,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text('#${widget.ordine.numero}',
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _secondary)),
              ),
              SizedBox(
                width: 70,
                child: Text(
                    DateFormat('HH:mm').format(widget.ordine.dataOra),
                    style: GoogleFonts.inter(
                        fontSize: 13, color: _onSurfaceVar)),
              ),
              Expanded(
                child: Text('${widget.ordine.items.length} prodotti',
                    style: GoogleFonts.inter(
                        fontSize: 13, color: _onSurfaceVar)),
              ),
              SizedBox(
                width: 110,
                child: Text(
                    '€ ${widget.ordine.totale.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _success),
                    textAlign: TextAlign.right),
              ),
              SizedBox(
                width: 48,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  color: _danger,
                  tooltip: 'Elimina',
                  onPressed: widget.onDelete,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Styles ───────────────────────────────────────────────────────────────────

TextStyle get _thSt => GoogleFonts.jetBrainsMono(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: _onSurfaceVar,
      letterSpacing: 0.5,
    );
