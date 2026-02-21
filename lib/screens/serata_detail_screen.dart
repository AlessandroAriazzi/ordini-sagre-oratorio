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
    final serateAsync = ref.watch(serateNotifierProvider);
    final menusAsync = ref.watch(menusNotifierProvider);
    final ordiniAsync = ref.watch(ordiniNotifierProvider(serataId));

    return serateAsync.when(
      data: (serate) {
        final serataList = serate.where((s) => s.id == serataId).toList();
        final serata = serataList.isNotEmpty ? serataList.first : null;
        if (serata == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Serata non trovata')),
            body: const Center(child: Text('Serata non trovata')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(serata.titolo),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/serate'),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.assessment_rounded),
                tooltip: 'Resoconto',
                onPressed: () => context.go('/resoconto/$serataId'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppTheme.secondaryColor, AppTheme.secondaryColor.withOpacity(0.7)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.event_rounded, size: 32, color: Colors.white),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    serata.titolo,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('EEEE dd MMMM yyyy', 'it_IT').format(serata.data),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        const Text(
                          'Menù assegnato',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        menusAsync.when(
                          data: (menus) {
                            final currentMenuList = serata.menuId != null
                                ? menus.where((m) => m.id == serata.menuId).toList()
                                : <dynamic>[];
                            final currentMenu = currentMenuList.isNotEmpty ? currentMenuList.first : null;

                            return Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<int?>(
                                    value: serata.menuId,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.restaurant_menu_rounded),
                                    ),
                                    items: [
                                      const DropdownMenuItem(
                                        value: null,
                                        child: Text('Nessun menù'),
                                      ),
                                      ...menus.map((menu) => DropdownMenuItem(
                                            value: menu.id,
                                            child: Text(menu.nome),
                                          )),
                                    ],
                                    onChanged: (menuId) {
                                      if (menuId != null) {
                                        ref
                                            .read(serateNotifierProvider.notifier)
                                            .assignMenuToSerata(serataId, menuId);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: const Icon(Icons.add_rounded),
                                  tooltip: 'Crea nuovo menù',
                                  style: IconButton.styleFrom(
                                    backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                                    foregroundColor: AppTheme.secondaryColor,
                                  ),
                                  onPressed: () => context.go('/menu/new'),
                                ),
                                if (currentMenu != null)
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded),
                                    tooltip: 'Modifica menù',
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppTheme.successColor.withOpacity(0.1),
                                      foregroundColor: AppTheme.successColor,
                                    ),
                                    onPressed: () => context.go('/menu/${currentMenu.id}'),
                                  ),
                              ],
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (_, __) => const Text('Errore caricamento menù', style: TextStyle(color: AppTheme.dangerColor)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ordini',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: serata.menuId == null
                          ? null
                          : () async {
                              final ordineId = await ref
                                  .read(ordiniNotifierProvider(serataId).notifier)
                                  .createOrdine();
                              if (context.mounted) {
                                context.go('/ordine/$serataId/$ordineId');
                              }
                            },
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Nuovo Ordine'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ordiniAsync.when(
                  data: (ordini) {
                    if (ordini.isEmpty) {
                      return Card(
                        elevation: 0,
                        color: Colors.grey.shade50,
                        child: const Padding(
                          padding: EdgeInsets.all(48),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.receipt_long_rounded, size: 64, color: AppTheme.textLight),
                                SizedBox(height: 16),
                                Text(
                                  'Nessun ordine presente',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Crea il primo ordine per iniziare',
                                  style: TextStyle(color: AppTheme.textLight),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ordini.length,
                      itemBuilder: (context, index) {
                        final ordine = ordini[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppTheme.successColor, AppTheme.successColor.withOpacity(0.7)],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  '#${ordine.id}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              '${ordine.items.length} prodotti',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                DateFormat('HH:mm').format(ordine.dataOra),
                                style: const TextStyle(color: AppTheme.textSecondary),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '€ ${ordine.totale.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.successColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded),
                                  color: AppTheme.dangerColor,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        title: const Text('Conferma eliminazione'),
                                        content: const Text('Sei sicuro di voler eliminare questo ordine?\n\nLe quantità dei prodotti verranno ripristinate.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: const Text('Annulla'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              ref
                                                  .read(ordiniNotifierProvider(serataId).notifier)
                                                  .deleteOrdine(ordine.id!);
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppTheme.dangerColor,
                                            ),
                                            child: const Text('Elimina'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
                              ],
                            ),
                            onTap: () => context.go('/ordine/$serataId/${ordine.id}'),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, _) => Center(
                    child: Text(
                      'Errore: $error',
                      style: const TextStyle(color: AppTheme.dangerColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(
          child: Text('Errore: $error', style: const TextStyle(color: AppTheme.dangerColor)),
        ),
      ),
    );
  }
}