import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/serata.dart' as models;
import '../models/alimento.dart';
import '../models/serata_alimento.dart';
import '../providers/serate_provider.dart';
import '../providers/serata_alimenti_provider.dart';
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
const _secondary    = Color(0xFF006C49);
const _danger       = Color(0xFFBA1A1A);
const _warning      = Color(0xFFF59E0B);
const _success      = Color(0xFF10B981);
// ──────────────────────────────────────────────────────────────────────────────

const _categorie = [
  'Primo', 'Secondo', 'Contorno', 'Torta fritta', 'Bevanda', 'Dolce'
];

// ─── Main Screen ──────────────────────────────────────────────────────────────

class SerateListScreen extends ConsumerStatefulWidget {
  const SerateListScreen({super.key});

  @override
  ConsumerState<SerateListScreen> createState() => _SerateListScreenState();
}

class _SerateListScreenState extends ConsumerState<SerateListScreen> {
  int? _selectedId;
  bool _initialized = false;

  final _titoloCtrl = TextEditingController();
  DateTime _newDate = DateTime.now();
  int? _copyFromId;

  @override
  void dispose() {
    _titoloCtrl.dispose();
    super.dispose();
  }

  void _autoSelect(List<models.Serata> serate) {
    if (_initialized || serate.isEmpty) return;
    _initialized = true;
    final today = _today();
    final upcoming = [...serate]
      ..sort((a, b) => a.data.compareTo(b.data));
    final next = upcoming.firstWhere(
      (s) => !s.data.isBefore(today),
      orElse: () => upcoming.last,
    );
    _selectedId = next.id;
  }

  DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  // ── Dialogs ─────────────────────────────────────────────────

  Future<void> _showAddSerataDialog() async {
    _titoloCtrl.clear();
    _newDate = DateTime.now();
    _copyFromId = null;
    final serate = ref.read(serateProvider).asData?.value ?? [];

    return showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Dialog(
          child: SizedBox(
            width: 480,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nuova Serata', style: _titleSt),
                  const SizedBox(height: 4),
                  Text('Inserisci i dettagli della nuova serata.',
                      style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _titoloCtrl,
                    decoration:  InputDecoration(
                      labelText: 'Nome serata',
                      prefixIcon: const Icon(Icons.title_rounded, size: 18),
                       focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:  BorderSide(
                            color: Colors.black.withValues(alpha: 0.5), // Colore quando è selezionato
                            width: 2,
                          ),
                        ),
                    ),
                    
                    autofocus: true,
                    onSubmitted: (_) => _createSerata(ctx),
                  ),
                  const SizedBox(height: 16),
                  _DateField(date: _newDate, onPick: (d) => ss(() => _newDate = d)),
                  const SizedBox(height: 16),
                  if (serate.isNotEmpty)
                    DropdownButtonFormField<int?>(
                      // ignore: deprecated_member_use
                      value: _copyFromId,
                      decoration:  InputDecoration(
                        labelText: 'Copia menù da serata (opzionale)',
                        prefixIcon: const Icon(Icons.copy_rounded, size: 18),
                         focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:  BorderSide(
                            color: Colors.black.withValues(alpha: 0.5), // Colore quando è selezionato
                            width: 2,
                          ),
                        ),
                    ),
                      
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Nessuna (menù vuoto)')),
                        ...serate.map((s) => DropdownMenuItem(
                          value: s.id,
                          child: Text('${s.titolo} — ${_fmt(s.data)}'),
                        )),
                      ],
                      onChanged: (v) => ss(() => _copyFromId = v),
                    ),
                  const SizedBox(height: 28),
                  _DialogActions(
                    onCancel: () => Navigator.pop(ctx),
                    onConfirm: () => _createSerata(ctx),
                    label: 'Crea Serata',
                    icon: Icons.add_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _createSerata(BuildContext ctx) async {
    if (_titoloCtrl.text.trim().isEmpty) return;
    final newId = await ref
        .read(serateProvider.notifier)
        .addSerata(_titoloCtrl.text.trim(), _newDate);
    if (_copyFromId != null) {
      await ref.read(serataAlimentiProvider(newId).notifier).copyFromSerata(_copyFromId!);
    }
    if (ctx.mounted) {
      Navigator.pop(ctx);
      setState(() => _selectedId = newId);
    }
  }

  void _showDeleteDialog(models.Serata s) {
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
                Text('Elimina serata', style: _titleSt),
                const SizedBox(height: 8),
                Text('Vuoi eliminare "${s.titolo}"? Azione non reversibile.',
                    style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annulla', style: TextStyle(color: _onSurfaceVar, fontSize: 13, fontWeight: FontWeight.w500))),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        ref.read(serateProvider.notifier).deleteSerata(s.id!);
                        if (_selectedId == s.id) {
                          setState(() { _selectedId = null; _initialized = false; });
                        }
                        Navigator.pop(ctx);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _danger,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
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

  void _showEditDialog(models.Serata s) {
    final ctrl = TextEditingController(text: s.titolo);
    DateTime d = s.data;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Dialog(
          child: SizedBox(
            width: 480,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Modifica serata', style: _titleSt),
                  const SizedBox(height: 4),
                  Text('Aggiorna i dettagli della serata.',
                      style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(
                      labelText: 'Nome serata',
                      prefixIcon: Icon(Icons.title_rounded, size: 18),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  _DateField(date: d, onPick: (v) => ss(() => d = v)),
                  const SizedBox(height: 28),
                  _DialogActions(
                    onCancel: () => Navigator.pop(ctx),
                    onConfirm: () {
                      if (ctrl.text.trim().isEmpty) return;
                      ref.read(serateProvider.notifier).updateSerata(
                        models.Serata(id: s.id, titolo: ctrl.text.trim(), data: d),
                      );
                      Navigator.pop(ctx);
                    },
                    label: 'Salva',
                    icon: Icons.check_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).then((_) => ctrl.dispose());
  }

  // ── Build ────────────────────────────────────────────────────

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
              // ── Full-width header ──────────────────────────────
              _RightHeader(onNewSerata: _showAddSerataDialog),
              // ── Body row ──────────────────────────────────────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Left sidebar card ──────────────────────
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
                            onDelete: _showDeleteDialog,
                            today: _today(),
                          ),
                        ),
                      ),
                    ),
                    // ── Right content ──────────────────────────
                    Expanded(
                      child: selected == null
                          ? _EmptyState(
                              noData: serate.isEmpty,
                              onNewSerata: _showAddSerataDialog,
                            )
                          : _DetailPanel(
                              key: ValueKey(selected.id),
                              serata: selected,
                              onEdit: _showEditDialog,
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

class _Sidebar extends ConsumerWidget {
  final List<models.Serata> serate;
  final int? selectedId;
  final void Function(int) onSelect;
  final void Function(models.Serata) onDelete;
  final DateTime today;

  const _Sidebar({
    required this.serate,
    required this.selectedId,
    required this.onSelect,
    required this.onDelete,
    required this.today,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          

          // List
          Expanded(
            child: serate.isEmpty
                ? Center(
                    child: Text('Nessuna serata',
                        style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                  )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                     

                      // IN PROGRAMMA
                      if (upcoming.isNotEmpty) ...[
                        const _SectionLabel('SERATE IN PROGRAMMA'),
                      
                        ...upcoming.map((s) => _SidebarRow(
                              serata: s,
                              isSelected: selectedId == s.id,
                              isToday: s.data.year == today.year &&
                                  s.data.month == today.month &&
                                  s.data.day == today.day,
                              onTap: () => onSelect(s.id!),
                              onDelete: () => onDelete(s),
                            )),
                      ],

                      // CONCLUSE
                      if (past.isNotEmpty) ...[
                        if (upcoming.isNotEmpty)
                          const Divider(height: 1, color: _outlineVar),
                        const _SectionLabel('CONCLUSE'),
                        ...past.map((s) => _SidebarRow(
                              serata: s,
                              isSelected: selectedId == s.id,
                              isToday: false,
                              onTap: () => onSelect(s.id!),
                              onDelete: () => onDelete(s),
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
  final VoidCallback onDelete;

  const _SidebarRow({
    required this.serata,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
    required this.onDelete,
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
                            fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: widget.isSelected ? _secondary : _onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          DateFormat('d MMM yyyy', 'it_IT').format(widget.serata.data),
                          style: GoogleFonts.inter(
                              fontSize: 11, color: _onSurfaceVar),
                        ),
                        if (widget.isToday) ...[
                          const SizedBox(width: 6),
                          const _Badge('oggi', color: _success, small: true),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (_hover)
                GestureDetector(
                  onTap: widget.onDelete,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.delete_outline_rounded,
                        size: 14, color: _danger),
                  ),
                )
              else
                const Icon(Icons.chevron_right_rounded,
                    size: 16, color: _outline),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Right Header ─────────────────────────────────────────────────────────────

class _RightHeader extends StatelessWidget {
  final VoidCallback onNewSerata;
  const _RightHeader({required this.onNewSerata});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text('Gestione Serate e Menu',
                  style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _onSurface,
                      letterSpacing: -0.3)),
              const SizedBox(height: 2),
              Text('Configura gli eventi e personalizza i dati',
                  style: GoogleFonts.inter(fontSize: 12, color: _onSurfaceVar)),
            ],
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: onNewSerata,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: Text('Nuova Serata',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
            style: _primaryBtn,
          ),
        ],
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final bool noData;
  final VoidCallback onNewSerata;
  const _EmptyState({required this.noData, required this.onNewSerata});

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
              size: 40, color: _outline,
            ),
          ),
          const SizedBox(height: 20),
          Text(noData ? 'Nessuna serata' : 'Seleziona una serata',
              style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w600, color: _onSurface)),
          const SizedBox(height: 4),
          Text(
            noData
                ? 'Crea la prima serata per iniziare.'
                : 'Seleziona una serata dalla lista per gestire il menù.',
            style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar),
          ),
          if (noData) ...[
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onNewSerata,
              icon: const Icon(Icons.add_rounded, size: 16),
              label: Text('Nuova Serata',
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
              style: _primaryBtn,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Detail Panel ─────────────────────────────────────────────────────────────

class _DetailPanel extends ConsumerStatefulWidget {
  final models.Serata serata;
  final void Function(models.Serata) onEdit;

  const _DetailPanel({super.key, required this.serata, required this.onEdit});

  @override
  ConsumerState<_DetailPanel> createState() => _DetailPanelState();
}

class _DetailPanelState extends ConsumerState<_DetailPanel> {
  String _tab = 'Tutti';

  int get _sid => widget.serata.id!;

  // ── Menu dialogs ──────────────────────────────────────────────

  void _showAggiungi(List<SerataAlimentoEntry> existing, List<Alimento> alimenti) {
    final existingIds = existing.map((e) => e.alimentoId).toSet();
    final avail = alimenti.where((a) => a.id != null && !existingIds.contains(a.id)).toList();

    if (avail.isEmpty) {
      _snack('Tutti gli alimenti sono già nel menù di questa serata.', _warning);
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => _AddAlimentiDialog(
        disponibili: avail,
        onConfirm: (sel) async {
          final n = ref.read(serataAlimentiProvider(_sid).notifier);
          for (final s in sel) { await n.addAlimento(s.alimentoId, s.prezzo, s.quantita); }
        },
      ),
    );
  }

  void _showCopia(List<dynamic> serate, List<SerataAlimentoEntry> current) {
    final altre = serate.where((s) => s.id != _sid).toList();
    if (altre.isEmpty) {
      _snack('Nessun\'altra serata disponibile da cui copiare.', _warning);
      return;
    }
    dynamic sel = altre.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Dialog(
          child: SizedBox(
            width: 480,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Copia menù da serata', style: _titleSt),
                  const SizedBox(height: 4),
                  Text(
                      'Copia alimenti, prezzi e quantità da un\'altra serata. Il menù attuale verrà sostituito.',
                      style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<dynamic>(
                    // ignore: deprecated_member_use
                    value: sel,
                    decoration: const InputDecoration(
                      labelText: 'Serata sorgente',
                      prefixIcon: Icon(Icons.event_rounded, size: 18),
                    ),
                    items: altre
                        .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text('${s.titolo} — ${_fmt(s.data)}')))
                        .toList(),
                    onChanged: (v) => ss(() => sel = v),
                  ),
                  if (current.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const _WarningBox('Il menù attuale verrà sostituito con quello della serata selezionata.'),
                  ],
                  const SizedBox(height: 28),
                  _DialogActions(
                    onCancel: () => Navigator.pop(ctx),
                    onConfirm: () {
                      if (sel == null) return;
                      ref.read(serataAlimentiProvider(_sid).notifier).copyFromSerata(sel!.id!);
                      Navigator.pop(ctx);
                    },
                    label: 'Copia',
                    icon: Icons.copy_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditPrezzo(int alimentoId, String nome, double attuale) {
    final ctrl = TextEditingController(text: attuale.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Modifica prezzo per questa serata', style: _titleSt),
                const SizedBox(height: 4),
                Text(nome, style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                const SizedBox(height: 24),
                TextField(
                  controller: ctrl,
                  decoration: const InputDecoration(
                    labelText: 'Prezzo (€)',
                    prefixIcon: Icon(Icons.euro_rounded, size: 18),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  autofocus: true,
                ),
                const SizedBox(height: 28),
                _DialogActions(
                  onCancel: () => Navigator.pop(ctx),
                  onConfirm: () {
                    ref.read(serataAlimentiProvider(_sid).notifier)
                        .updatePrezzo(alimentoId, double.tryParse(ctrl.text) ?? attuale);
                    Navigator.pop(ctx);
                  },
                  label: 'Salva',
                  icon: Icons.check_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) => ctrl.dispose());
  }

  void _showEditQuantita(int alimentoId, String nome, int attuale) {
    final ctrl = TextEditingController(text: attuale.toString());
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Imposta quantità disponibile', style: _titleSt),
                const SizedBox(height: 4),
                Text(nome, style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                const SizedBox(height: 24),
                TextField(
                  controller: ctrl,
                  decoration: const InputDecoration(
                    labelText: 'Quantità disponibile per questa serata',
                    prefixIcon: Icon(Icons.format_list_numbered_rounded, size: 18),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autofocus: true,
                ),
                const SizedBox(height: 28),
                _DialogActions(
                  onCancel: () => Navigator.pop(ctx),
                  onConfirm: () {
                    ref.read(serataAlimentiProvider(_sid).notifier)
                        .updateQuantita(alimentoId, int.tryParse(ctrl.text) ?? 0);
                    Navigator.pop(ctx);
                  },
                  label: 'Salva',
                  icon: Icons.check_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) => ctrl.dispose());
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color));
  }

  // ── Build ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final serataAlimentiAsync = ref.watch(serataAlimentiProvider(_sid));
    final alimentiAsync = ref.watch(alimentiProvider);
    final serateAsync = ref.watch(serateProvider);

    final serataAlimenti = serataAlimentiAsync.asData?.value ?? [];
    final alimenti = alimentiAsync.asData?.value ?? [];
    final serate = serateAsync.asData?.value ?? [];

    final aMap = alimenti.fold<Map<int, Alimento>>({}, (m, a) {
      if (a.id != null) m[a.id!] = a;
      return m;
    });

    final catPresenti = <String>{};
    for (final sa in serataAlimenti) {
      final a = aMap[sa.alimentoId];
      if (a != null) catPresenti.add(a.categoria);
    }
    final tabs = ['Tutti', ..._categorie.where(catPresenti.contains)];
    if (!tabs.contains(_tab)) _tab = 'Tutti';

    final filtered = _tab == 'Tutti'
        ? serataAlimenti
        : serataAlimenti.where((sa) => aMap[sa.alimentoId]?.categoria == _tab).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Impostazioni Serata ────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _white,
              border: Border.all(color: _outlineVar),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Impostazioni Serata', style: _cardLabelSt),
                      const SizedBox(height: 16),
                      _InfoRow(label: 'NOME SERATA', value: widget.serata.titolo),
                      const SizedBox(height: 10),
                      _InfoRow(
                        label: 'DATA EVENTO',
                        value: DateFormat('d MMMM yyyy', 'it_IT').format(widget.serata.data),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => widget.onEdit(widget.serata),
                      icon: const Icon(Icons.edit_rounded, size: 14),
                      label: Text('Modifica',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
                      style: _outlineBtn,
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => context.go('/resoconto/$_sid'),
                      icon: const Icon(Icons.assessment_rounded, size: 14),
                      label: Text('Resoconto',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _secondary,
                        side: BorderSide(color: _secondary.withValues(alpha: 0.4)),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Configurazione Menu ────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: _white,
              border: Border.all(color: _outlineVar),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menu header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Row(
                    children: [
                      Text('Configurazione Menu', style: _cardLabelSt),
                      const Spacer(),
                       OutlinedButton.icon(
                onPressed: () => _showCopia(serate, serataAlimenti),
                icon: const Icon(Icons.copy_rounded, size: 15),
                label: Text('Copia da serata precedente',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
                style: _outlineBtn,
              ),
              const SizedBox(width: 10),
                      FilledButton.icon(
                        onPressed: () => _showAggiungi(serataAlimenti, alimenti),
                        icon: const Icon(Icons.add_rounded, size: 15),
                        label: Text('Aggiungi Prodotto',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
                        style: FilledButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                      ),
                    ],
                  ),
                ),

                // Category tabs
                if (tabs.length > 1)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: tabs.map((tab) {
                          final sel = _tab == tab;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: GestureDetector(
                              onTap: () => setState(() => _tab = tab),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 120),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: sel ? _primary : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: sel ? _primary : _outlineVar,
                                  ),
                                ),
                                child: Text(tab,
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: sel ? Colors.white : _onSurfaceVar)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                const Divider(height: 1, color: _outlineVar),

                // Table header
                Container(
                  color: _surface,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(child: Text('PRODOTTO', style: _thSt)),
                      SizedBox(width: 110, child: Text('CATEGORIA', style: _thSt)),
                      SizedBox(
                          width: 90,
                          child: Text('PREZZO', style: _thSt, textAlign: TextAlign.right)),
                      const SizedBox(width: 72),
                    ],
                  ),
                ),

                const Divider(height: 1, color: _outlineVar),

                // Table body
                if (serataAlimenti.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text('Menù vuoto. Aggiungi prodotti.',
                          style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                    ),
                  )
                else if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(
                      child: Text('Nessun prodotto in questa categoria.',
                          style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                    ),
                  )
                else if (_tab == 'Tutti')
                  ..._buildGroupedRows(serataAlimenti, aMap)
                else
                  ..._buildFlatRows(filtered, aMap),
              ],
            ),
          ),

          const SizedBox(height: 16),

          
        ],
      ),
    );
  }

  List<Widget> _buildGroupedRows(
      List<SerataAlimentoEntry> all, Map<int, Alimento> aMap) {
    final groups = <String, List<SerataAlimentoEntry>>{};
    for (final sa in all) {
      final cat = aMap[sa.alimentoId]?.categoria ?? '';
      groups.putIfAbsent(cat, () => []).add(sa);
    }

    final result = <Widget>[];
    final orderedCats = _categorie.where(groups.containsKey).toList();

    for (int gi = 0; gi < orderedCats.length; gi++) {
      final cat = orderedCats[gi];
      final rows = groups[cat]!;
      if (gi > 0) result.add(const Divider(height: 1, color: _outlineVar));
      result.add(_CategoryGroupHeader(cat, rows.length));
      for (int ri = 0; ri < rows.length; ri++) {
        result.add(const Divider(height: 1, color: _outlineVar));
        result.add(_productRow(rows[ri], aMap));
      }
    }
    return result;
  }

  List<Widget> _buildFlatRows(
      List<SerataAlimentoEntry> items, Map<int, Alimento> aMap) {
    final result = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      if (i > 0) result.add(const Divider(height: 1, color: _outlineVar));
      result.add(_productRow(items[i], aMap));
    }
    return result;
  }

  Widget _productRow(SerataAlimentoEntry sa, Map<int, Alimento> aMap) {
    final alimento = aMap[sa.alimentoId];
    final nome = alimento?.nome ?? '?';
    final cat = alimento?.categoria ?? '';
    final esaurito = sa.quantita <= 0;
    final low = !esaurito && sa.quantita < 10;

    return Container(
      color: _white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        children: [
          // Icon + name
          Expanded(
            child: Row(
              children: [
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nome,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _onSurface)),
                      if (esaurito)
                        Text('esaurito',
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                color: _danger,
                                fontWeight: FontWeight.w600))
                      else if (low)
                        Text('${sa.quantita} rimanenti',
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                color: _warning,
                                fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Categoria badge
          SizedBox(width: 110, child: _CategoriaBadge(cat)),
          // Prezzo (editable)
          SizedBox(
            width: 90,
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => _showEditPrezzo(sa.alimentoId, nome, sa.prezzo),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('€ ${sa.prezzo.toStringAsFixed(2)}',
                          style: GoogleFonts.jetBrainsMono(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _onSurface)),
                      const SizedBox(width: 3),
                      const Icon(Icons.edit_outlined, size: 11, color: _outline),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Actions
          SizedBox(
            width: 72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.format_list_numbered_rounded, size: 15),
                  color: _onSurfaceVar,
                  tooltip: esaurito ? 'Imposta quantità' : 'Quantità: ${sa.quantita}',
                  onPressed: () => _showEditQuantita(sa.alimentoId, nome, sa.quantita),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 15),
                  color: _danger,
                  tooltip: 'Rimuovi dal menù',
                  onPressed: () => ref
                      .read(serataAlimentiProvider(_sid).notifier)
                      .removeAlimento(sa.alimentoId),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Category Group Header ────────────────────────────────────────────────────

class _CategoryGroupHeader extends StatelessWidget {
  final String categoria;
  final int count;
  const _CategoryGroupHeader(this.categoria, this.count);

  @override
  Widget build(BuildContext context) {
    final color = _catBadgeColors[categoria] ?? _onSurfaceVar;
    return Container(
      color: _surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          
          Text(
            categoria.toUpperCase(),
            style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.7,
                color: color),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('$count',
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 10, fontWeight: FontWeight.w700, color: color)),
          ),
        ],
      ),
    );
  }
}

// ─── Add Alimenti Dialog ──────────────────────────────────────────────────────

typedef _AlimentoSel = ({int alimentoId, double prezzo, int quantita});

class _AddAlimentiDialog extends StatefulWidget {
  final List<Alimento> disponibili;
  final Future<void> Function(List<_AlimentoSel>) onConfirm;

  const _AddAlimentiDialog({required this.disponibili, required this.onConfirm});

  @override
  State<_AddAlimentiDialog> createState() => _AddAlimentiDialogState();
}

class _AddAlimentiDialogState extends State<_AddAlimentiDialog> {
  String _filtro = 'Tutti';
  final Set<int> _sel = {};
  final Map<int, TextEditingController> _pCtrl = {};
  final Map<int, TextEditingController> _qCtrl = {};
  bool _loading = false;

  @override
  void dispose() {
    for (final c in _pCtrl.values) { c.dispose(); }
    for (final c in _qCtrl.values) { c.dispose(); }
    super.dispose();
  }

  List<Alimento> get _filtrati => _filtro == 'Tutti'
      ? widget.disponibili
      : widget.disponibili.where((a) => a.categoria == _filtro).toList();

  void _toggle(Alimento a) {
    setState(() {
      if (_sel.contains(a.id!)) {
        _sel.remove(a.id!);
        _pCtrl.remove(a.id!)?.dispose();
        _qCtrl.remove(a.id!)?.dispose();
      } else {
        _sel.add(a.id!);
        _pCtrl[a.id!] = TextEditingController(text: a.prezzoDefault.toStringAsFixed(2));
        _qCtrl[a.id!] = TextEditingController(text: '0');
      }
    });
  }

  Future<void> _confirm() async {
    if (_sel.isEmpty) return;
    setState(() => _loading = true);
    final selections = _sel
        .map((id) => (
              alimentoId: id,
              prezzo: double.tryParse(_pCtrl[id]!.text) ?? 0.0,
              quantita: int.tryParse(_qCtrl[id]!.text) ?? 0,
            ))
        .toList();
    await widget.onConfirm(selections);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final filtrati = _filtrati;
    final selectedAlimenti = widget.disponibili.where((a) => _sel.contains(a.id!)).toList();

    return Dialog(
      child: SizedBox(
        width: 900,
        height: 580,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  color: _white,
                  border: Border(bottom: BorderSide(color: _outlineVar)),
                ),
                child: Row(
                  children: [
                    Text('Aggiungi alimenti al menù',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _onSurface,
                            letterSpacing: -0.2)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: _onSurfaceVar,
                      onPressed: () => Navigator.pop(context),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              // Body
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildLeft(filtrati)),
                    Container(width: 1, color: _outlineVar),
                    SizedBox(width: 340, child: _buildRight(selectedAlimenti)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeft(List<Alimento> filtrati) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: const BoxDecoration(
            color: _white,
            border: Border(bottom: BorderSide(color: _outlineVar)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Tutti', ..._categorie].map((c) {
                final isSel = _filtro == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => setState(() => _filtro = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isSel ? _primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSel ? _primary : _outlineVar,
                        ),
                      ),
                      child: Text(c,
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSel ? Colors.white : _onSurfaceVar)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: filtrati.isEmpty
              ? Center(
                  child: Text('Nessun alimento disponibile in questa categoria.',
                      style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)))
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: filtrati.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, color: _outlineVar),
                  itemBuilder: (_, i) {
                    final a = filtrati[i];
                    final isSel = _sel.contains(a.id!);
                    return InkWell(
                      onTap: () => _toggle(a),
                      child: Container(
                        color: isSel
                            ? _secondary.withValues(alpha: 0.04)
                            : _white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSel,
                              onChanged: (_) => _toggle(a),
                              activeColor: _primary,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(a.nome,
                                  style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
                                      color: _onSurface)),
                            ),
                            _CategoriaBadge(a.categoria),
                            const SizedBox(width: 10),
                            Text('€${a.prezzoDefault.toStringAsFixed(2)}',
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 12, color: _onSurfaceVar)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRight(List<Alimento> selectedAlimenti) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: const BoxDecoration(
            color: _white,
            border: Border(bottom: BorderSide(color: _outlineVar)),
          ),
          child: Row(
            children: [
              Text('Selezionati',
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w700, color: _onSurface)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: _sel.isEmpty
                      ? _outlineVar.withValues(alpha: 0.5)
                      : _secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('${_sel.length}',
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _sel.isEmpty ? _onSurfaceVar : _secondary)),
              ),
            ],
          ),
        ),
        Expanded(
          child: selectedAlimenti.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.checklist_rounded, size: 32, color: _outline),
                      const SizedBox(height: 8),
                      Text('Seleziona alimenti\ndalla lista',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontSize: 12, color: _onSurfaceVar)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: selectedAlimenti.length,
                  itemBuilder: (_, i) {
                    final a = selectedAlimenti[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _surface,
                          border: Border.all(color: _outlineVar),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(a.nome,
                                      style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: _onSurface)),
                                ),
                                InkWell(
                                  onTap: () => _toggle(a),
                                  borderRadius: BorderRadius.circular(4),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(Icons.close_rounded,
                                        size: 14, color: _outline),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _pCtrl[a.id!],
                                    decoration: const InputDecoration(
                                      labelText: 'Prezzo €',
                                      prefixIcon: Icon(Icons.euro_rounded, size: 14),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      isDense: true,
                                    ),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}'))
                                    ],
                                    style: GoogleFonts.inter(fontSize: 13),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _qCtrl[a.id!],
                                    decoration: const InputDecoration(
                                      labelText: 'Quantità',
                                      prefixIcon: Icon(
                                          Icons.format_list_numbered_rounded, size: 14),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                      isDense: true,
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    style: GoogleFonts.inter(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: _white,
            border: Border(top: BorderSide(color: _outlineVar)),
          ),
          child: Row(
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: const Text('Annulla', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500))),
              const Spacer(),
              FilledButton.icon(
                onPressed: _sel.isEmpty || _loading ? null : _confirm,
                icon: _loading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.add_rounded, size: 16),
                label: Text(_sel.isEmpty ? 'Aggiungi' : 'Aggiungi ${_sel.length}',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                style: FilledButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _outlineVar,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Small Reusable Widgets ───────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(label,
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: _outline)),
        ),
        Expanded(
          child: Text(value,
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: _onSurface)),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final bool small;
  const _Badge(this.text, {required this.color, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 5 : 7, vertical: small ? 1 : 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: GoogleFonts.inter(
              fontSize: small ? 9 : 10,
              fontWeight: FontWeight.w700,
              color: color)),
    );
  }
}

class _WarningBox extends StatelessWidget {
  final String text;
  const _WarningBox(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _warning.withValues(alpha: 0.08),
        border: Border.all(color: _warning.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 16, color: _warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: GoogleFonts.inter(fontSize: 12, color: _onSurfaceVar)),
          ),
        ],
      ),
    );
  }
}

class _DialogActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final String label;
  final IconData icon;

  const _DialogActions({
    required this.onCancel,
    required this.onConfirm,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: onCancel, child: const Text('Annulla', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500))),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: onConfirm,
          icon: Icon(icon, size: 16),
          label: Text(label,
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
          style: _primaryBtn,
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime) onPick;
  const _DateField({required this.date, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(primary: _secondary),
              textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
        ),
      ),
            ),
            child: child!,
          ),
        );
        if (picked != null) onPick(picked);
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _white,
          border: Border.all(color: _outlineVar),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, size: 18, color: _onSurfaceVar),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: _onSurfaceVar,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(DateFormat('dd MMMM yyyy', 'it_IT').format(date),
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _onSurface)),
                ],
              ),
            ),
            const Icon(Icons.unfold_more_rounded, size: 16, color: _outline),
          ],
        ),
      ),
    );
  }
}

// ─── Categoria Badge ──────────────────────────────────────────────────────────

const _catBadgeColors = {
  'Primo':        Color(0xFF006C49),
  'Secondo':      Color(0xFF005AA3),
  'Contorno':     Color(0xFF6D4C41),
  'Torta fritta': Color(0xFFF59E0B),
  'Bevanda':      Color(0xFF6366F1),
  'Dolce':        Color(0xFFEC4899),
};

class _CategoriaBadge extends StatelessWidget {
  final String categoria;
  const _CategoriaBadge(this.categoria);

  @override
  Widget build(BuildContext context) {
    final c = _catBadgeColors[categoria] ?? _onSurfaceVar;
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



String _fmt(DateTime d) => DateFormat('dd/MM/yyyy', 'it_IT').format(d);

// ─── Shared Styles ────────────────────────────────────────────────────────────

TextStyle get _titleSt => GoogleFonts.inter(
  fontSize: 18, fontWeight: FontWeight.w700, color: _onSurface, letterSpacing: -0.2,
);

TextStyle get _cardLabelSt => GoogleFonts.jetBrainsMono(
  fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.4, color: _onSurfaceVar,
);

TextStyle get _thSt => GoogleFonts.jetBrainsMono(
  fontSize: 11, fontWeight: FontWeight.w500, color: _onSurfaceVar, letterSpacing: 0.5,
);

final _primaryBtn = FilledButton.styleFrom(
  backgroundColor: _primary,
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 20),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
);

final _outlineBtn = OutlinedButton.styleFrom(
  foregroundColor: _onSurfaceVar,
  side: const BorderSide(color: _outlineVar),
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
);
