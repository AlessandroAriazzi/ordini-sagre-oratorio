import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../providers/serate_provider.dart';
import '../providers/menu_provider.dart';

class SerateListScreen extends ConsumerStatefulWidget {
  const SerateListScreen({super.key});

  @override
  ConsumerState<SerateListScreen> createState() => _SerateListScreenState();
}

class _SerateListScreenState extends ConsumerState<SerateListScreen> {
  final _titoloController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titoloController.dispose();
    super.dispose();
  }

  Future<void> _showAddSerataDialog() async {
    _titoloController.clear();
    _selectedDate = DateTime.now();

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          child: SizedBox(
            width: 480,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nuova Serata',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Inserisci i dettagli della nuova serata.',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _titoloController,
                    decoration: const InputDecoration(
                      labelText: 'Nome serata',
                      prefixIcon: Icon(Icons.title_rounded, size: 18),
                    ),
                    autofocus: true,
                    onSubmitted: (_) => _createSerata(context),
                  ),
                  const SizedBox(height: 16),
                  // Date picker field
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        builder: (ctx, child) => Theme(
                          data: Theme.of(ctx).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppTheme.secondaryColor,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (date != null) {
                        setDialogState(() => _selectedDate = date);
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.borderColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 18, color: AppTheme.textSecondary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Data',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormat('dd MMMM yyyy', 'it_IT').format(_selectedDate),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.unfold_more_rounded,
                              size: 16, color: AppTheme.textLight),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annulla'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () => _createSerata(context),
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Crea Serata'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
  }

  void _createSerata(BuildContext dialogContext) {
    if (_titoloController.text.isNotEmpty) {
      ref.read(serateProvider.notifier).addSerata(
            _titoloController.text,
            _selectedDate,
          );
      Navigator.pop(dialogContext);
    }
  }

  void _showDeleteDialog(dynamic serata) {
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
                const Text(
                  'Elimina serata',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vuoi eliminare "${serata.titolo}"? Questa azione non può essere annullata.',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Annulla'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        ref.read(serateProvider.notifier).deleteSerata(serata.id!);
                        Navigator.pop(ctx);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.dangerColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
    final serateAsync = ref.watch(serateProvider);
    final menusAsync = ref.watch(menusProvider);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page header
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 20),
            child: Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Serate',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Gestisci le serate organizzate',
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _showAddSerataDialog,
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Nuova Serata'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderColor),

          // Content
          Expanded(
            child: serateAsync.when(
              data: (serate) {
                if (serate.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: const Icon(
                            Icons.event_busy_rounded,
                            size: 40,
                            color: AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Nessuna serata',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Crea la prima serata per iniziare.',
                          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: _showAddSerataDialog,
                          icon: const Icon(Icons.add_rounded, size: 16),
                          label: const Text('Nuova Serata'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.secondaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(32),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.borderColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        children: [
                          // Table header
                          Container(
                            color: AppTheme.backgroundColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: const Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Text('N°', style: _headerStyle),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  flex: 3,
                                  child: Text('Nome', style: _headerStyle),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Data', style: _headerStyle),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Menù', style: _headerStyle),
                                ),
                                SizedBox(width: 80),
                              ],
                            ),
                          ),
                          const Divider(height: 1, color: AppTheme.borderColor),
                          Expanded(
                            child: ListView.separated(
                              itemCount: serate.length,
                              separatorBuilder: (_, _) =>
                                  const Divider(height: 1, color: AppTheme.borderColor),
                              itemBuilder: (ctx, i) {
                                final serata = serate[i];
                                return _SerataRow(
                                  serata: serata,
                                  index: i + 1,
                                  menusAsync: menusAsync,
                                  onTap: () => context.go('/serata/${serata.id}'),
                                  onDelete: () => _showDeleteDialog(serata),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Errore: $e',
                    style: const TextStyle(color: AppTheme.dangerColor)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppTheme.textSecondary,
    letterSpacing: 0.5,
  );
}

class _SerataRow extends StatefulWidget {
  final dynamic serata;
  final int index;
  final AsyncValue menusAsync;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SerataRow({
    required this.serata,
    required this.index,
    required this.menusAsync,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_SerataRow> createState() => _SerataRowState();
}

class _SerataRowState extends State<_SerataRow> {
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
          color: _hover ? AppTheme.backgroundColor : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  '${widget.index}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Text(
                  widget.serata.titolo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  DateFormat('dd MMM yyyy', 'it_IT').format(widget.serata.data),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: widget.serata.menuId != null
                    ? widget.menusAsync.when(
                        data: (menus) {
                          final menuList = (menus as List)
                              .where((m) => m.id == widget.serata.menuId)
                              .toList();
                          final menu = menuList.isNotEmpty ? menuList.first : null;
                          return menu != null
                              ? _Badge(
                                  label: menu.nome,
                                  color: AppTheme.successColor,
                                )
                              : const _Badge(
                                  label: 'Menù non trovato',
                                  color: AppTheme.warningColor,
                                );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      )
                    : const _Badge(
                        label: 'Nessun menù',
                        color: AppTheme.textLight,
                      ),
              ),
              SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      color: AppTheme.dangerColor,
                      tooltip: 'Elimina',
                      onPressed: widget.onDelete,
                      visualDensity: VisualDensity.compact,
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: AppTheme.textLight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color == AppTheme.textLight ? AppTheme.textSecondary : color,
        ),
      ),
    );
  }
}
