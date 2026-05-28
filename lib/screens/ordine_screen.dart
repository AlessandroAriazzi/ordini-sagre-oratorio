import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/network/network_print_result.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../providers/ordini_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/serate_provider.dart';
import '../providers/thermal_printer_provider.dart';
import '../theme.dart';
import '../widgets/ordine_item_widget.dart';
import '../widgets/totale_widget.dart';

class OrdineScreen extends ConsumerWidget {
  final int serataId;
  final int ordineId;

  const OrdineScreen({
    super.key,
    required this.serataId,
    required this.ordineId,
  });

  Future<List<int>> _buildTicket(
    dynamic ordine,
    dynamic serata,
    Map<int, String> categoriaMap,
  ) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];

    // Preliminary reset+cut: absorbs CUPS/printer per-job initialization.
    bytes.addAll(generator.reset());
    bytes.addAll(generator.feed(3));
    bytes.addAll(generator.cut());
    debugPrint('STAMPA: preliminary cut done, ticket 1 starts at byte ${bytes.length}');

    final foodItems = <dynamic>[];
    final drinkItems = <dynamic>[];
    final dessertItems = <dynamic>[];

    for (final item in ordine.items) {
      final cat = (categoriaMap[item.prodottoId] ?? '').toLowerCase();
      if (cat.contains('bevand')) {
        drinkItems.add(item);
      } else if (cat.contains('dolc')) {
        dessertItems.add(item);
      } else {
        foodItems.add(item);
      }
    }

    List<int> buildHeader() {
      final b = <int>[];
      b.addAll(generator.text(
        serata.titolo,
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ));
      b.addAll(generator.text(
        'Ordine #${ordine.id}',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ));
      b.addAll(generator.text(
        DateFormat('dd/MM/yyyy HH:mm').format(ordine.dataOra),
        styles: const PosStyles(align: PosAlign.center),
      ));
      b.addAll(generator.hr());
      return b;
    }

    List<int> buildSection(String label, List<dynamic> items) {
      final b = <int>[];
      b.addAll(generator.text(label, styles: const PosStyles(bold: true)));
      for (final item in items) {
        b.addAll(generator.row([
          PosColumn(text: item.prodottoNome, width: 5),
          PosColumn(
            text: item.prezzoUnitario.toStringAsFixed(2),
            width: 2,
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: 'x${item.quantita}',
            width: 2,
            styles: const PosStyles(align: PosAlign.right),
          ),
          PosColumn(
            text: item.totale.toStringAsFixed(2),
            width: 3,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]));
      }
      return b;
    }

    var hasContent = false;

    // Ticket 1: cibo (tutto tranne bevande e dolci)
    if (foodItems.isNotEmpty) {
      hasContent = true;
      bytes.addAll(buildHeader());

      final byCategory = <String, List<dynamic>>{};
      for (final item in foodItems) {
        final cat = categoriaMap[item.prodottoId] ?? '';
        byCategory.putIfAbsent(cat, () => []).add(item);
      }
      for (final entry in byCategory.entries) {
        bytes.addAll(buildSection(
          entry.key.isNotEmpty ? entry.key.toUpperCase() : 'ALTRO',
          entry.value,
        ));
        bytes.addAll(generator.hr());
      }

      final foodTotal = foodItems.fold<double>(0, (s, i) => s + i.totale);
      bytes.addAll(generator.text(
        'TOTALE CIBO: EUR ${foodTotal.toStringAsFixed(2)}',
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ));
      bytes.addAll(generator.text(
        'TOTALE ORDINE: EUR ${ordine.totale.toStringAsFixed(2)}',
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ));
      bytes.addAll(generator.feed(2));
      bytes.addAll(generator.cut());
    }

    // Ticket 2: bevande
    if (drinkItems.isNotEmpty) {
      hasContent = true;
      bytes.addAll(buildHeader());
      bytes.addAll(buildSection('BEVANDE', drinkItems));
      bytes.addAll(generator.hr());
      final drinkTotal = drinkItems.fold<double>(0, (s, i) => s + i.totale);
      bytes.addAll(generator.text(
        'TOTALE: EUR ${drinkTotal.toStringAsFixed(2)}',
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ));
      bytes.addAll(generator.feed(2));
      bytes.addAll(generator.cut());
    }

    // Ticket 3: dolci
    if (dessertItems.isNotEmpty) {
      hasContent = true;
      bytes.addAll(buildHeader());
      bytes.addAll(buildSection('DOLCI', dessertItems));
      bytes.addAll(generator.hr());
      final dessertTotal = dessertItems.fold<double>(0, (s, i) => s + i.totale);
      bytes.addAll(generator.text(
        'TOTALE: EUR ${dessertTotal.toStringAsFixed(2)}',
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ));
      bytes.addAll(generator.feed(2));
      bytes.addAll(generator.cut());
    }

    if (!hasContent) {
      bytes.addAll(buildHeader());
      bytes.addAll(generator.text('Ordine vuoto', styles: const PosStyles(align: PosAlign.center)));
      bytes.addAll(generator.feed(2));
      bytes.addAll(generator.cut());
    }

    return bytes;
  }

  Future<void> _stampaOrdine(BuildContext context, WidgetRef ref) async {
    try {
      final config = await ref.read(thermalPrinterProvider.future);
      if (!context.mounted) return;

      if (!config.isConfigured) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Configura una stampante POS nelle Impostazioni'),
          backgroundColor: AppTheme.dangerColor,
        ));
        return;
      }

      final ordini = ref.read(ordiniProvider(serataId)).asData?.value;
      if (ordini == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Dati ordini non disponibili, riprova'),
          backgroundColor: AppTheme.dangerColor,
        ));
        return;
      }
      final ordine = ordini.where((o) => o.id == ordineId).firstOrNull;
      if (ordine == null) return;

      final serata = ref.read(serateProvider).asData?.value
          .where((s) => s.id == serataId).firstOrNull;
      if (serata == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Dati serata non disponibili, riprova'),
          backgroundColor: AppTheme.dangerColor,
        ));
        return;
      }

      final categoriaMap = <int, String>{};
      final menuId = serata.menuId;
      if (menuId != null) {
        final menu = ref.read(menuByIdProvider(menuId)).asData?.value;
        if (menu != null) {
          for (final p in menu.prodotti) {
            if (p.id != null) categoriaMap[p.id!] = p.categoria;
          }
        }
      }

      final bytes = await _buildTicket(ordine, serata, categoriaMap);
      if (!context.mounted) return;

      if (config.connectionType == 'CUPS') {
        final tmpPath = '${Directory.systemTemp.path}/receipt_${ordine.id}.bin';
        final tmpFile = File(tmpPath);
        await tmpFile.writeAsBytes(bytes);
        try {
          final result = await Process.run('/usr/bin/lp', ['-d', config.name!, '-o', 'raw', tmpPath]);
          if (result.exitCode != 0) throw Exception(result.stderr.toString().trim());
        } finally {
          await tmpFile.delete();
        }
      } else if (config.connectionType == 'NETWORK') {
        final net = FlutterThermalPrinterNetwork(
          config.address!,
          port: config.port,
          timeout: const Duration(seconds: 5),
        );
        final result = await net.printTicket(bytes);
        if (!context.mounted) return;
        if (result != NetworkPrintResult.success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Stampante non raggiungibile (${config.address}:${config.port})'),
            backgroundColor: AppTheme.dangerColor,
          ));
        }
      } else {
        // USB
        final plugin = FlutterThermalPrinter.instance;
        StreamSubscription<List<Printer>>? sub;
        final completer = Completer<Printer?>();

        await plugin.getPrinters(connectionTypes: [ConnectionType.USB]);
        sub = plugin.devicesStream.listen((devices) {
          final match = devices.where(
            (p) => p.address == config.address || p.name == config.name,
          ).firstOrNull;
          if (match != null && !completer.isCompleted) completer.complete(match);
        });
        Future.delayed(const Duration(seconds: 5), () {
          if (!completer.isCompleted) completer.complete(null);
        });

        final target = await completer.future;
        await sub.cancel();
        await plugin.stopScan();

        if (!context.mounted) return;

        if (target == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Stampante USB "${config.name}" non trovata'),
            backgroundColor: AppTheme.dangerColor,
          ));
          return;
        }

        await plugin.connect(target);
        await plugin.printData(target, bytes);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Errore stampa: $e'),
          backgroundColor: AppTheme.dangerColor,
        ));
      }
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Vuoi eliminare questo ordine? Le quantità dei prodotti verranno ripristinate.',
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
                        ref.read(ordiniProvider(serataId).notifier).deleteOrdine(ordineId);
                        Navigator.pop(ctx);
                        context.go('/serata/$serataId');
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
  Widget build(BuildContext context, WidgetRef ref) {
    final ordiniAsync = ref.watch(ordiniProvider(serataId));
    final serateAsync = ref.watch(serateProvider);

    return ordiniAsync.when(
      data: (ordini) {
        final ordine = ordini.where((o) => o.id == ordineId).firstOrNull;
        if (ordine == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Ordine non trovato', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go('/serata/$serataId'),
                    child: const Text('Torna alla serata'),
                  ),
                ],
              ),
            ),
          );
        }

        return serateAsync.when(
          data: (serate) {
            final serata = serate.where((s) => s.id == serataId).firstOrNull;
            final menuId = serata?.menuId;

            return Scaffold(
              body: Column(
                children: [
                  // Breadcrumb header
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => context.go('/serata/$serataId'),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.chevron_left_rounded, size: 16, color: AppTheme.textSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  serata?.titolo ?? 'Serata',
                                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text('/', style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
                        ),
                        Text(
                          'Ordine #${ordine.id}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () => _stampaOrdine(context, ref),
                          icon: const Icon(Icons.print_rounded, size: 15),
                          label: const Text('Stampa'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.textSecondary,
                            side: const BorderSide(color: AppTheme.borderColor),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () => _showDeleteDialog(context, ref),
                          icon: const Icon(Icons.delete_outline_rounded, size: 15),
                          label: const Text('Elimina'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.dangerColor,
                            side: BorderSide(color: AppTheme.dangerColor.withValues(alpha: 0.4)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Split panel body
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left panel — order items
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              // Items list header
                              Container(
                                color: AppTheme.backgroundColor,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                child: const Row(
                                  children: [
                                    Expanded(child: Text('Prodotto', style: _headerStyle)),
                                    SizedBox(width: 120, child: Text('Quantità', style: _headerStyle, textAlign: TextAlign.center)),
                                    SizedBox(width: 100, child: Text('Prezzo', style: _headerStyle, textAlign: TextAlign.right)),
                                    SizedBox(width: 100, child: Text('Totale', style: _headerStyle, textAlign: TextAlign.right)),
                                    SizedBox(width: 44),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, color: AppTheme.borderColor),

                              // Items
                              Expanded(
                                child: ordine.items.isEmpty
                                    ? Center(
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
                                              child: const Icon(Icons.shopping_cart_outlined, size: 36, color: AppTheme.textLight),
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              'Ordine vuoto',
                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              'Aggiungi prodotti dal pannello a destra',
                                              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemCount: ordine.items.length,
                                        separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.borderColor),
                                        itemBuilder: (context, index) {
                                          final item = ordine.items[index];
                                          return OrdineItemWidget(
                                            item: item,
                                            onQuantityChanged: (newQuantity) {
                                              if (newQuantity > 0) {
                                                try {
                                                  ref.read(ordiniProvider(serataId).notifier).updateItemQuantita(
                                                    item.id!,
                                                    ordineId,
                                                    newQuantity,
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(e.toString().replaceAll('Exception: ', '')),
                                                      backgroundColor: AppTheme.dangerColor,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            onDelete: () {
                                              ref.read(ordiniProvider(serataId).notifier).removeItemFromOrdine(item.id!, ordineId);
                                            },
                                          );
                                        },
                                      ),
                              ),

                              // Total bar
                              TotaleWidget(totale: ordine.totale),
                            ],
                          ),
                        ),

                        // Vertical divider
                        const VerticalDivider(width: 1, color: AppTheme.borderColor),

                        // Right panel — product picker
                        SizedBox(
                          width: 320,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Right panel header
                              Container(
                                color: AppTheme.backgroundColor,
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                child: const Text(
                                  'Aggiungi prodotto',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary, letterSpacing: -0.1),
                                ),
                              ),
                              const Divider(height: 1, color: AppTheme.borderColor),

                              // Product list
                              Expanded(
                                child: menuId == null
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(24),
                                          child: Text(
                                            'Nessun menù associato a questa serata.',
                                            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : Consumer(
                                        builder: (context, ref, _) {
                                          final menuAsync = ref.watch(menuByIdProvider(menuId));
                                          return menuAsync.when(
                                            data: (menu) {
                                              if (menu == null || menu.prodotti.isEmpty) {
                                                return const Center(
                                                  child: Text(
                                                    'Nessun prodotto nel menù',
                                                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                                                  ),
                                                );
                                              }

                                              final prodottiPerCategoria = <String, List>{};
                                              for (final p in menu.prodotti) {
                                                prodottiPerCategoria.putIfAbsent(p.categoria, () => []).add(p);
                                              }

                                              return ListView(
                                                padding: const EdgeInsets.all(12),
                                                children: prodottiPerCategoria.entries.map((entry) {
                                                  return Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
                                                        child: Text(
                                                          entry.key.toUpperCase(),
                                                          style: const TextStyle(
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w700,
                                                            letterSpacing: 0.8,
                                                            color: AppTheme.textSecondary,
                                                          ),
                                                        ),
                                                      ),
                                                      ...entry.value.map<Widget>((prodotto) {
                                                        final isEsaurito = prodotto.isEsaurito;
                                                        return _ProductPickerRow(
                                                          prodotto: prodotto,
                                                          isEsaurito: isEsaurito,
                                                          onAdd: isEsaurito
                                                              ? null
                                                              : () {
                                                                  try {
                                                                    ref.read(ordiniProvider(serataId).notifier).addItemToOrdine(
                                                                      ordineId,
                                                                      prodotto.id!,
                                                                      prodotto.nome,
                                                                      prodotto.prezzo,
                                                                    );
                                                                  } catch (e) {
                                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                                      SnackBar(
                                                                        content: Text(e.toString().replaceAll('Exception: ', '')),
                                                                        backgroundColor: AppTheme.dangerColor,
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                        );
                                                      }),
                                                      const SizedBox(height: 4),
                                                    ],
                                                  );
                                                }).toList(),
                                              );
                                            },
                                            loading: () => const Center(child: CircularProgressIndicator()),
                                            error: (_, _) => const Center(
                                              child: Text('Errore caricamento menù', style: TextStyle(color: AppTheme.dangerColor, fontSize: 13)),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (_, _) => const Scaffold(body: Center(child: Text('Errore caricamento serata'))),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text('Errore: $error'))),
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppTheme.textSecondary,
    letterSpacing: 0.5,
  );
}

class _ProductPickerRow extends StatefulWidget {
  final dynamic prodotto;
  final bool isEsaurito;
  final VoidCallback? onAdd;

  const _ProductPickerRow({
    required this.prodotto,
    required this.isEsaurito,
    required this.onAdd,
  });

  @override
  State<_ProductPickerRow> createState() => _ProductPickerRowState();
}

class _ProductPickerRowState extends State<_ProductPickerRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.isEsaurito ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onAdd,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isEsaurito
                ? AppTheme.backgroundColor
                : _hover
                    ? AppTheme.secondaryColor.withValues(alpha: 0.06)
                    : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isEsaurito
                  ? AppTheme.borderColor
                  : _hover
                      ? AppTheme.secondaryColor.withValues(alpha: 0.3)
                      : AppTheme.borderColor,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.prodotto.nome,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: widget.isEsaurito ? AppTheme.textLight : AppTheme.textPrimary,
                        decoration: widget.isEsaurito ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '€${widget.prodotto.prezzo.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.isEsaurito ? AppTheme.textLight : AppTheme.successColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!widget.isEsaurito) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: widget.prodotto.quantita < 10
                                  ? AppTheme.warningColor.withValues(alpha: 0.12)
                                  : AppTheme.successColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${widget.prodotto.quantita} disp.',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: widget.prodotto.quantita < 10 ? AppTheme.warningColor : AppTheme.successColor,
                              ),
                            ),
                          ),
                        ],
                        if (widget.isEsaurito)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: AppTheme.dangerColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'ESAURITO',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.dangerColor),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!widget.isEsaurito)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _hover ? AppTheme.secondaryColor : AppTheme.secondaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: 16,
                    color: _hover ? Colors.white : AppTheme.secondaryColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
