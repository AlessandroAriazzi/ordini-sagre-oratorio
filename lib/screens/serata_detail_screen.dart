import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../providers/serate_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/ordini_provider.dart';

class SerataDetailScreen extends ConsumerWidget {
  final int serataId;

  const SerataDetailScreen({super.key, required this.serataId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serateAsync = ref.watch(serateProvider);
    final menusAsync = ref.watch(menusProvider);
    final ordiniAsync = ref.watch(ordiniProvider(serataId));

    return serateAsync.when(
      data: (serate) {
        final serata = serate.where((s) => s.id == serataId).firstOrNull;
        if (serata == null) {
          return const Scaffold(
            body: Center(child: Text('Serata non trovata')),
          );
        }

        return Scaffold(
          body: Column(
            children: [
              // Breadcrumb header
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: AppTheme.borderColor),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.go('/serate'),
                      borderRadius: BorderRadius.circular(6),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chevron_left_rounded,
                                size: 18, color: AppTheme.textSecondary),
                            Text(
                              'Serate',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text('/',
                          style: TextStyle(
                              color: AppTheme.textLight, fontSize: 14)),
                    ),
                    Text(
                      serata.titolo,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () => context.go('/resoconto/$serataId'),
                      icon: const Icon(Icons.assessment_rounded, size: 16),
                      label: const Text('Resoconto'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary,
                        side: const BorderSide(color: AppTheme.borderColor),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        textStyle: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Serata info + menu
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serata.titolo,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded,
                                    size: 13, color: AppTheme.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  DateFormat('EEEE d MMMM yyyy', 'it_IT')
                                      .format(serata.data),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Divider(color: AppTheme.borderColor, height: 1),
                            const SizedBox(height: 20),
                            // Menu row
                            Row(
                              children: [
                                const Text(
                                  'Menù',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const Spacer(),
                                menusAsync.when(
                                  data: (menus) => Row(
                                    children: [
                                      SizedBox(
                                        width: 260,
                                        child: DropdownButtonFormField<int?>(
                                          initialValue: serata.menuId,
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(
                                              Icons.restaurant_menu_rounded,
                                              size: 18,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10),
                                          ),
                                          items: [
                                            const DropdownMenuItem(
                                              value: null,
                                              child: Text('Nessun menù'),
                                            ),
                                            ...menus.map((m) =>
                                                DropdownMenuItem(
                                                  value: m.id,
                                                  child: Text(m.nome),
                                                )),
                                          ],
                                          onChanged: (menuId) {
                                            if (menuId != null) {
                                              ref
                                                  .read(serateProvider
                                                      .notifier)
                                                  .assignMenuToSerata(
                                                      serataId, menuId);
                                            }
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.add_rounded,
                                            size: 18),
                                        tooltip: 'Crea nuovo menù',
                                        style: IconButton.styleFrom(
                                          backgroundColor: AppTheme.secondaryColor
                                              .withValues(alpha: 0.08),
                                          foregroundColor:
                                              AppTheme.secondaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        onPressed: () =>
                                            context.go('/menu/new'),
                                      ),
                                      if (serata.menuId != null) ...[
                                        const SizedBox(width: 4),
                                        IconButton(
                                          icon: const Icon(Icons.edit_rounded,
                                              size: 18),
                                          tooltip: 'Modifica menù',
                                          style: IconButton.styleFrom(
                                            backgroundColor: AppTheme
                                                .successColor
                                                .withValues(alpha: 0.08),
                                            foregroundColor:
                                                AppTheme.successColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ),
                                          onPressed: () => context
                                              .go('/menu/${serata.menuId}'),
                                        ),
                                      ],
                                    ],
                                  ),
                                  loading: () => const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                  error: (_, _) => const Text('Errore',
                                      style: TextStyle(
                                          color: AppTheme.dangerColor)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Ordini
                      Row(
                        children: [
                          const Text(
                            'Ordini',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const Spacer(),
                          if (serata.menuId == null)
                            const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: Text(
                                'Assegna un menù per creare ordini',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary),
                              ),
                            ),
                          FilledButton.icon(
                            onPressed: serata.menuId == null
                                ? null
                                : () async {
                                    final ordineId = await ref
                                        .read(ordiniProvider(serataId)
                                            .notifier)
                                        .createOrdine();
                                    if (context.mounted) {
                                      context.go(
                                          '/ordine/$serataId/$ordineId');
                                    }
                                  },
                            icon: const Icon(Icons.add_rounded, size: 16),
                            label: const Text('Nuovo Ordine'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.secondaryColor,
                              disabledBackgroundColor: AppTheme.borderColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              textStyle: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      ordiniAsync.when(
                        data: (ordini) {
                          if (ordini.isEmpty) {
                            return Container(
                              padding: const EdgeInsets.all(36),
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.borderColor),
                              ),
                              child: const Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.receipt_long_rounded,
                                        size: 36, color: AppTheme.textLight),
                                    SizedBox(height: 12),
                                    Text(
                                      'Nessun ordine',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Crea il primo ordine per iniziare.',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textLight),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.borderColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Column(
                                children: [
                                  Container(
                                    color: AppTheme.backgroundColor,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: const Row(
                                      children: [
                                        SizedBox(
                                          width: 64,
                                          child:
                                              Text('Ordine', style: _hStyle),
                                        ),
                                        SizedBox(width: 16),
                                        SizedBox(
                                          width: 60,
                                          child: Text('Ora', style: _hStyle),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child:
                                              Text('Prodotti', style: _hStyle),
                                        ),
                                        SizedBox(
                                          width: 90,
                                          child:
                                              Text('Totale', style: _hStyle),
                                        ),
                                        SizedBox(width: 48),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                      height: 1, color: AppTheme.borderColor),
                                  ...ordini.asMap().entries.map((e) {
                                    final i = e.key;
                                    final ordine = e.value;
                                    return Column(
                                      children: [
                                        if (i > 0)
                                          const Divider(
                                              height: 1,
                                              color: AppTheme.borderColor),
                                        _OrdineRow(
                                          ordine: ordine,
                                          onTap: () => context.go(
                                              '/ordine/$serataId/${ordine.id}'),
                                          onDelete: () =>
                                              _showDeleteOrdineDialog(
                                                  context, ref, ordine),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        },
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (e, _) => Text('Errore: $e',
                            style:
                                const TextStyle(color: AppTheme.dangerColor)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        body: Center(
          child: Text('Errore: $e',
              style: const TextStyle(color: AppTheme.dangerColor)),
        ),
      ),
    );
  }

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
                const Text(
                  'Elimina ordine',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Le quantità dei prodotti verranno ripristinate.',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
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
                        ref
                            .read(ordiniProvider(serataId).notifier)
                            .deleteOrdine(ordine.id!);
                        Navigator.pop(ctx);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.dangerColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        textStyle: const TextStyle(
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

  static const _hStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppTheme.textSecondary,
    letterSpacing: 0.5,
  );
}

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
          color: _hover ? AppTheme.backgroundColor : Colors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  '#${widget.ordine.id}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.secondaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 60,
                child: Text(
                  DateFormat('HH:mm').format(widget.ordine.dataOra),
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.textSecondary),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '${widget.ordine.items.length} prodotti',
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.textSecondary),
                ),
              ),
              SizedBox(
                width: 90,
                child: Text(
                  '€ ${widget.ordine.totale.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.successColor,
                  ),
                ),
              ),
              SizedBox(
                width: 48,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  color: AppTheme.dangerColor,
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
