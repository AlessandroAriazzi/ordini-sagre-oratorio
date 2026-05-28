import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../providers/serate_provider.dart';
import '../providers/menu_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serateAsync = ref.watch(serateProvider);
    final menusAsync = ref.watch(menusProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page header
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('EEEE d MMMM yyyy', 'it_IT').format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () => context.go('/menu/new'),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Nuovo Menù'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      side: const BorderSide(color: AppTheme.borderColor),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => context.go('/serate'),
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

              const SizedBox(height: 24),
              const Divider(color: AppTheme.borderColor),
              const SizedBox(height: 24),

              // KPI row
              Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      icon: Icons.event_rounded,
                      label: 'Serate',
                      value: serateAsync.when(
                        data: (s) => '${s.length}',
                        loading: () => '—',
                        error: (_, _) => '!',
                      ),
                      color: AppTheme.secondaryColor,
                      onTap: () => context.go('/serate'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _KpiCard(
                      icon: Icons.restaurant_menu_rounded,
                      label: 'Menù',
                      value: menusAsync.when(
                        data: (m) => '${m.length}',
                        loading: () => '—',
                        error: (_, _) => '!',
                      ),
                      color: AppTheme.successColor,
                      onTap: () => context.go('/menu/new'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _KpiCard(
                      icon: Icons.inventory_2_rounded,
                      label: 'Prodotti totali',
                      value: menusAsync.when(
                        data: (m) => '${m.fold(0, (sum, menu) => sum + menu.prodotti.length)}',
                        loading: () => '—',
                        error: (_, _) => '!',
                      ),
                      color: AppTheme.warningColor,
                      onTap: () => context.go('/menu/new'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Recent serate table
              serateAsync.when(
                data: (serate) {
                  if (serate.isEmpty) return const SizedBox.shrink();
                  final recent = serate.take(5).toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Serate recenti',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => context.go('/serate'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.secondaryColor,
                              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text('Vedi tutte →'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _SerateTable(serate: recent),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _KpiCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  State<_KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<_KpiCard> {
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
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hover
                  ? widget.color.withValues(alpha: 0.4)
                  : AppTheme.borderColor,
            ),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 18),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: widget.color.withValues(alpha: 0.5),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.value,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: widget.color,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SerateTable extends StatelessWidget {
  final List<dynamic> serate;
  const _SerateTable({required this.serate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            // Header
            Container(
              color: AppTheme.backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: const Row(
                children: [
                  SizedBox(
                    width: 28,
                    child: Text('N°', style: _headerStyle),
                  ),
                  SizedBox(width: 16),
                  Expanded(child: Text('Nome', style: _headerStyle)),
                  SizedBox(
                    width: 160,
                    child: Text('Data', style: _headerStyle),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppTheme.borderColor),
            ...serate.asMap().entries.map((e) {
              final i = e.key;
              final serata = e.value;
              return Column(
                children: [
                  if (i > 0)
                    const Divider(height: 1, color: AppTheme.borderColor),
                  _SerataTableRow(
                    serata: serata,
                    onTap: () => context.go('/serata/${serata.id}'),
                  ),
                ],
              );
            }),
          ],
        ),
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

class _SerataTableRow extends StatefulWidget {
  final dynamic serata;
  final VoidCallback onTap;
  const _SerataTableRow({required this.serata, required this.onTap});

  @override
  State<_SerataTableRow> createState() => _SerataTableRowState();
}

class _SerataTableRowState extends State<_SerataTableRow> {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '${widget.serata.id}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.serata.titolo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              SizedBox(
                width: 160,
                child: Text(
                  DateFormat('dd MMM yyyy', 'it_IT').format(widget.serata.data),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
