import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../providers/serate_provider.dart';
import '../providers/menu_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serateAsync = ref.watch(serateNotifierProvider);
    final menusAsync = ref.watch(menusNotifierProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.secondaryColor, AppTheme.secondaryColor.withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.secondaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Benvenuto',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Sistema di gestione ordini per feste di paese',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // Quick Stats
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.event_rounded,
                      title: 'Serate',
                      value: serateAsync.when(
                        data: (serate) => '${serate.length}',
                        loading: () => '...',
                        error: (_, __) => 'Errore',
                      ),
                      subtitle: serateAsync.when(
                        data: (serate) => serate.length == 1 ? 'serata attiva' : 'serate attive',
                        loading: () => 'Caricamento...',
                        error: (_, __) => 'Errore caricamento',
                      ),
                      color: AppTheme.secondaryColor,
                      onTap: () => context.go('/serate'),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.restaurant_menu_rounded,
                      title: 'Menù',
                      value: menusAsync.when(
                        data: (menus) => '${menus.length}',
                        loading: () => '...',
                        error: (_, __) => 'Errore',
                      ),
                      subtitle: menusAsync.when(
                        data: (menus) => menus.length == 1 ? 'menù disponibile' : 'menù disponibili',
                        loading: () => 'Caricamento...',
                        error: (_, __) => 'Errore caricamento',
                      ),
                      color: AppTheme.successColor,
                      onTap: () => context.go('/menu/new'),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.inventory_2_rounded,
                      title: 'Prodotti',
                      value: menusAsync.when(
                        data: (menus) {
                          final totalProdotti = menus.fold(
                            0,
                            (sum, menu) => sum + menu.prodotti.length,
                          );
                          return '$totalProdotti';
                        },
                        loading: () => '...',
                        error: (_, __) => 'Errore',
                      ),
                      subtitle: menusAsync.when(
                        data: (menus) {
                          final totalProdotti = menus.fold(
                            0,
                            (sum, menu) => sum + menu.prodotti.length,
                          );
                          return totalProdotti == 1 ? 'prodotto totale' : 'prodotti totali';
                        },
                        loading: () => 'Caricamento...',
                        error: (_, __) => 'Errore caricamento',
                      ),
                      color: AppTheme.warningColor,
                      onTap: () => context.go('/menu/new'),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // Quick Actions
              const Text(
                'Azioni Rapide',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.add_circle_rounded,
                      title: 'Nuova Serata',
                      description: 'Crea una nuova serata e inizia a gestire gli ordini',
                      color: AppTheme.secondaryColor,
                      onTap: () => context.go('/serate'),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.add_box_rounded,
                      title: 'Nuovo Menù',
                      description: 'Crea un nuovo menù con i prodotti della festa',
                      color: AppTheme.successColor,
                      onTap: () => context.go('/menu/new'),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              serateAsync.when(
                data: (serate) {
                  if (serate.isEmpty) return const SizedBox.shrink();
                  
                  final ultimeSerate = serate.take(3).toList();
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Serate Recenti',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...ultimeSerate.map((serata) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.event_rounded,
                              color: AppTheme.secondaryColor,
                              size: 28,
                            ),
                          ),
                          title: Text(
                            serata.titolo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _formatDate(serata.data),
                              style: const TextStyle(color: AppTheme.textSecondary),
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => context.go('/serata/${serata.id}'),
                        ),
                      )),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      return 'Oggi';
    } else if (diff.inDays == 1) {
      return 'Ieri';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} giorni fa';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _StatCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, isHovered ? -4 : 0, 0),
        child: Card(
          elevation: isHovered ? 8 : 2,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.color,
                          size: 32,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: widget.color,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.value,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, isHovered ? -4 : 0, 0),
        child: Card(
          elevation: isHovered ? 8 : 2,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.color, widget.color.withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: widget.color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}