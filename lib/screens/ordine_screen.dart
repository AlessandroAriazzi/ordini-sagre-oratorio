import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/network/network_print_result.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/ordini_provider.dart';
import '../providers/alimenti_provider.dart';
import '../providers/serate_provider.dart';
import '../providers/serata_alimenti_provider.dart';
import '../providers/thermal_printer_provider.dart';
import '../models/alimento.dart';
import '../models/serata_alimento.dart';
import '../theme.dart';

void selectAllText(TextEditingController controller) {
  if (controller.text.isNotEmpty) {
    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );
  }
}

class OrdineScreen extends ConsumerStatefulWidget {
  final int serataId;
  final int ordineId;

  const OrdineScreen({
    super.key,
    required this.serataId,
    required this.ordineId,
  });

  @override
  ConsumerState<OrdineScreen> createState() => _OrdineScreenState();
}

class _OrdineScreenState extends ConsumerState<OrdineScreen> {
  String? _selectedCategory;
  final TextEditingController _pagatoController = TextEditingController(text: '0');
  double _pagato = 0.0;

  @override
  void initState() {
    super.initState();
    selectAllText(_pagatoController);
  }

  @override
  void dispose() {
    _pagatoController.dispose();
    super.dispose();
  }

  Future<List<int>> _buildTicket(
    dynamic ordine,
    dynamic serata,
    Map<int, String> categoriaMap,
  ) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final List<int> bytes = [];

    bytes.addAll(generator.reset());
    bytes.addAll(List.filled(64, 0));

    final tortaFrittaItems = <dynamic>[];
    final primoItems = <dynamic>[];
    final secondoContornoItems = <dynamic>[];
    final drinkItems = <dynamic>[];
    final dessertItems = <dynamic>[];

    for (final item in ordine.items) {
      final cat = (categoriaMap[item.prodottoId] ?? '').toLowerCase();
      if (cat.contains('torta')) {
        tortaFrittaItems.add(item);
      } else if (cat.contains('primo')) {
        primoItems.add(item);
      } else if (cat.contains('second') || cat.contains('contorn')) {
        secondoContornoItems.add(item);
      } else if (cat.contains('bevand')) {
        drinkItems.add(item);
      } else if (cat.contains('dolc')) {
        dessertItems.add(item);
      } else {
        secondoContornoItems.add(item);
      }
    }

    List<int> buildHeader(DateTime data, {bool largeId = true}) {
      final b = <int>[];
      b.addAll(generator.text(
        serata.titolo,
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ));
      b.addAll(generator.text(
        'Ordine ${ordine.numero}',
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: largeId ? PosTextSize.size2 : PosTextSize.size1,
          width: largeId ? PosTextSize.size2 : PosTextSize.size1,
        ),
      ));
      b.addAll(generator.text(
        DateFormat('dd/MM/yyyy HH:mm').format(data),
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

    List<int> buildTicketGroup(String label, List<dynamic> items, {required String retrievalText}) {
      final total = items.fold<double>(0.0, (double s, i) => s + (i.totale as double));
      final b = <int>[];
      b.addAll(buildHeader(ordine.dataOra));
      b.addAll(buildSection(label, items));
      b.addAll(generator.text(
        'TOTALE: EUR ${total.toStringAsFixed(2)}',
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ));
      b.addAll(generator.hr());
      b.addAll(generator.text(
        retrievalText,
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ));
      b.addAll(generator.feed(2));
      b.addAll(generator.cut());
      return b;
    }

    if (ordine.items.isNotEmpty) {
      bytes.addAll(buildHeader(ordine.dataOra, largeId: false));
      for (final item in ordine.items) {
        bytes.addAll(generator.row([
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
      final totale = ordine.items.fold<double>(0.0, (double s, i) => s + (i.totale as double));
      bytes.addAll(generator.text(
        'TOTALE: EUR ${totale.toStringAsFixed(2)}',
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ));
      bytes.addAll(generator.hr());
      bytes.addAll(generator.text(
        'CONSERVA QUESTO SCONTRINO',
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ));
      bytes.addAll(generator.text(
        'Gli altri tagliandi servono per ritirare',
        styles: const PosStyles(align: PosAlign.center),
      ));
      bytes.addAll(generator.feed(2));
      bytes.addAll(generator.cut());
    }

    var hasContent = false;

    if (tortaFrittaItems.isNotEmpty) {
      hasContent = true;
      bytes.addAll(buildTicketGroup('TORTA FRITTA', tortaFrittaItems, retrievalText: 'PRESENTA PER RITIRARE LA TORTA FRITTA'));
    }

    if (primoItems.isNotEmpty) {
      hasContent = true;
      bytes.addAll(buildTicketGroup('PRIMI', primoItems, retrievalText: 'PRESENTA PER RITIRARE I PRIMI'));
    }

    if (secondoContornoItems.isNotEmpty) {
      hasContent = true;
      final byCategory = <String, List<dynamic>>{};
      for (final item in secondoContornoItems) {
        final cat = categoriaMap[item.prodottoId] ?? '';
        byCategory.putIfAbsent(cat, () => []).add(item);
      }
      bytes.addAll(buildHeader(ordine.dataOra));
      for (final entry in byCategory.entries) {
        bytes.addAll(buildSection(
          entry.key.isNotEmpty ? entry.key.toUpperCase() : 'ALTRO',
          entry.value,
        ));
        bytes.addAll(generator.hr());
      }
      final total = secondoContornoItems.fold<double>(0.0, (double s, i) => s + (i.totale as double));
      bytes.addAll(generator.text(
        'TOTALE: EUR ${total.toStringAsFixed(2)}',
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ));
      bytes.addAll(generator.hr());
      bytes.addAll(generator.text(
        'PRESENTA PER RITIRARE I SECONDI E CONTORNI',
        styles: const PosStyles(bold: true, align: PosAlign.center),
      ));
      bytes.addAll(generator.feed(2));
      bytes.addAll(generator.cut());
    }

    if (drinkItems.isNotEmpty) {
      hasContent = true;
      bytes.addAll(buildTicketGroup('BEVANDE', drinkItems, retrievalText: 'PRESENTA PER RITIRARE LE BEVANDE'));
    }

    if (dessertItems.isNotEmpty) {
      hasContent = true;
      bytes.addAll(buildTicketGroup('DOLCI', dessertItems, retrievalText: 'PRESENTA PER RITIRARE I DOLCI'));
    }

    if (!hasContent) {
      bytes.addAll(buildHeader(ordine.dataOra));
      bytes.addAll(generator.text('Ordine vuoto', styles: const PosStyles(align: PosAlign.center)));
      bytes.addAll(generator.feed(2));
      bytes.addAll(generator.cut());
    }

    return bytes;
  }

  Future<void> _stampaOrdine(dynamic ordine, dynamic serata) async {
    if (serata == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Dati serata non disponibili, riprova'),
        backgroundColor: AppTheme.dangerColor,
      ));
      return;
    }
    try {
      final config = await ref.read(thermalPrinterProvider.future);
      if (!mounted) return;

      if (!config.isConfigured) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Configura una stampante POS nelle Impostazioni'),
          backgroundColor: AppTheme.dangerColor,
        ));
        return;
      }

      final categoriaMap = <int, String>{};
      final alimentiData = ref.read(alimentiProvider).asData?.value ?? [];
      for (final a in alimentiData) {
        if (a.id != null) categoriaMap[a.id!] = a.categoria;
      }

      final bytes = await _buildTicket(ordine, serata, categoriaMap);
      if (!mounted) return;

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
        if (!mounted) return;
        if (result != NetworkPrintResult.success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Stampante non raggiungibile (${config.address}:${config.port})'),
            backgroundColor: AppTheme.dangerColor,
          ));
        }
      } else {
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

        if (!mounted) return;

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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Errore stampa: $e'),
          backgroundColor: AppTheme.dangerColor,
        ));
      }
    }
  }

  void _showDeleteDialog() {
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
                      child: const Text('Annulla', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        ref.read(ordiniProvider(widget.serataId).notifier).deleteOrdine(widget.ordineId);
                        Navigator.pop(ctx);
                        context.go('/serate}');
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
    final ordiniAsync = ref.watch(ordiniProvider(widget.serataId));
    final serateAsync = ref.watch(serateProvider);

    return ordiniAsync.when(
      data: (ordini) {
        final ordine = ordini.where((o) => o.id == widget.ordineId).firstOrNull;
        if (ordine == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Ordine non trovato', style: TextStyle(fontSize: 16, color: AppTheme.textSecondary)),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.go('/serata/${widget.serataId}'),
                    child: const Text('Torna alla serata'),
                  ),
                ],
              ),
            ),
          );
        }

        return serateAsync.when(
          data: (serate) {
            final serata = serate.where((s) => s.id == widget.serataId).firstOrNull;

            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Breadcrumb header — full width
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(bottom: BorderSide(color: AppTheme.borderColor)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => context.go('/ordini'),
                          borderRadius: BorderRadius.circular(6),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.chevron_left_rounded, size: 16, color: AppTheme.textSecondary),
                                SizedBox(width: 4),
                                Text(
                                  'Ordini',
                                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
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
                          'Ordine ${ordine.numero}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                        ),
                      ],
                    ),
                  ),

                  // Main content row
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left panel — product grid
                        Expanded(
                          child: Consumer(
                            builder: (context, ref, _) {
                              final serataAlimentiAsync = ref.watch(serataAlimentiProvider(widget.serataId));
                              final alimentiAsync = ref.watch(alimentiProvider);

                              return serataAlimentiAsync.when(
                                data: (serataAlimenti) {
                                  if (serataAlimenti.isEmpty) {
                                    return const Center(
                                      child: Text(
                                        'Nessun prodotto nel menù di questa serata.',
                                        style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                      ),
                                    );
                                  }

                                  final alimentiMap = (alimentiAsync.asData?.value ?? [])
                                      .fold<Map<int, Alimento>>({}, (map, a) {
                                    if (a.id != null) map[a.id!] = a;
                                    return map;
                                  });

                                  final entries = serataAlimenti
                                      .map((sa) {
                                        final al = alimentiMap[sa.alimentoId];
                                        return al != null ? (sa: sa, al: al) : null;
                                      })
                                      .whereType<({SerataAlimentoEntry sa, Alimento al})>()
                                      .toList();

                                  final categories = entries
                                      .map((e) => e.al.categoria)
                                      .toSet()
                                      .toList()
                                    ..sort();

                                  final filtered = _selectedCategory == null
                                      ? entries
                                      : entries.where((e) => e.al.categoria == _selectedCategory).toList();

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Category tabs
                                      Container(
                                        color: Colors.transparent,
                                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              _CategoryTab(
                                                label: 'TUTTI',
                                                selected: _selectedCategory == null,
                                                onTap: () => setState(() => _selectedCategory = null),
                                              ),
                                              ...categories.map((cat) => _CategoryTab(
                                                    label: cat.toUpperCase(),
                                                    selected: _selectedCategory == cat,
                                                    onTap: () => setState(() => _selectedCategory = cat),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      

                                      // Grid
                                      Expanded(
                                        child: GridView.builder(
                                          padding: const EdgeInsets.all(20),
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            crossAxisSpacing: 12,
                                            mainAxisSpacing: 12,
                                            mainAxisExtent: 120,
                                          ),
                                          itemCount: filtered.length,
                                          itemBuilder: (context, index) {
                                            final entry = filtered[index];
                                            final isEsaurito = entry.sa.quantita <= 0;
                                            return _ProductCard(
                                              alimento: entry.al,
                                              prezzo: entry.sa.prezzo,
                                              quantitaDisponibile: entry.sa.quantita,
                                              isEsaurito: isEsaurito,
                                              onTap: isEsaurito
                                                  ? null
                                                  : () {
                                                      try {
                                                        ref
                                                            .read(ordiniProvider(widget.serataId).notifier)
                                                            .addItemToOrdine(
                                                              widget.ordineId,
                                                              entry.sa.alimentoId,
                                                              entry.al.nome,
                                                              entry.sa.prezzo,
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
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (_, _) => const Center(
                                  child: Text('Errore caricamento menù', style: TextStyle(color: AppTheme.dangerColor)),
                                ),
                              );
                            },
                          ),
                        ),

                  // Right panel — order + payment
                  Container(
                    width: 380,
                    color: AppTheme.backgroundColor,
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Order header
                        Container(
                          color: const Color(0xFFf3f4f6),
                          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                          child: Row(
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ordine Attivo',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                  ),
                                 
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: _showDeleteDialog,
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppTheme.dangerColor),
                                style: IconButton.styleFrom(
                                  padding: const EdgeInsets.all(6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: AppTheme.borderColor),

                        // Order items
                        Expanded(
                          child: ordine.items.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Seleziona un prodotto...',
                                    style: TextStyle(fontSize: 13, color: AppTheme.textLight),
                                  ),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  itemCount: ordine.items.length,
                                  separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.borderColor),
                                  itemBuilder: (context, index) {
                                    final item = ordine.items[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.prodottoNome,
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.backgroundColor,
                                              borderRadius: BorderRadius.circular(4),
                                              border: Border.all(color: AppTheme.borderColor),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (item.quantita > 1) {
                                                      try {
                                                        ref.read(ordiniProvider(widget.serataId).notifier).updateItemQuantita(
                                                          item.id!,
                                                          widget.ordineId,
                                                          item.quantita - 1,
                                                        );
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: AppTheme.dangerColor),
                                                        );
                                                      }
                                                    } else {
                                                      ref.read(ordiniProvider(widget.serataId).notifier).removeItemFromOrdine(item.id!, widget.ordineId);
                                                    }
                                                  },
                                                  child: const Icon(Icons.remove_rounded, size: 14, color: AppTheme.textSecondary),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                                  child: Text('${item.quantita}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    try {
                                                      ref.read(ordiniProvider(widget.serataId).notifier).updateItemQuantita(
                                                        item.id!,
                                                        widget.ordineId,
                                                        item.quantita + 1,
                                                      );
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: AppTheme.dangerColor),
                                                      );
                                                    }
                                                  },
                                                  child: const Icon(Icons.add_rounded, size: 14, color: AppTheme.textSecondary),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          SizedBox(
                                            width: 48,
                                            child: Text(
                                              '€${item.totale.toStringAsFixed(2)}',
                                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),

                        // Payment section
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFf3f4f6),
                            border: Border(top: BorderSide(color: AppTheme.borderColor)),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Totale row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                   Text(
                                    'TOTALE ORDINE',
                                    style: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: AppTheme.textSecondary)
                                    
                                    
                                   
                                  ),
                                  Text(
                                    '€ ${ordine.totale.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // Pagato input
                              Row(
                                children: [
                                   Text(
                                    'PAGATO (€)',
                                    style: GoogleFonts.jetBrainsMono(fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 0.6, color: AppTheme.textSecondary)
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      controller: _pagatoController,
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                      ],
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        isDense: true,
                                      ),
                                      onTap: () => selectAllText(_pagatoController),
                                      onChanged: (val) {
                                        setState(() {
                                          _pagato = double.tryParse(val) ?? 0.0;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Resto
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppTheme.successColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'RESTO:',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                                    ),
                                    Text(
                                      '€ ${(_pagato - ordine.totale).toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Stampa button
                              FilledButton.icon(
                                onPressed: () => _stampaOrdine(ordine, serata),
                                icon: const Icon(Icons.print_rounded, size: 18),
                                label: const Text('STAMPA ORDINE'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? AppTheme.textPrimary : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected ? AppTheme.textPrimary : AppTheme.borderColor,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppTheme.textSecondary,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Alimento alimento;
  final double prezzo;
  final int quantitaDisponibile;
  final bool isEsaurito;
  final VoidCallback? onTap;

  const _ProductCard({
    required this.alimento,
    required this.prezzo,
    required this.quantitaDisponibile,
    required this.isEsaurito,
    required this.onTap,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hover = false;

  

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.isEsaurito ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: widget.isEsaurito
                ? AppTheme.backgroundColor
                : _hover
                    ? const Color(0xFFEEF2FF)
                    : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.isEsaurito
                  ? AppTheme.borderColor
                  : _hover
                      ? AppTheme.secondaryColor.withValues(alpha: 0.4)
                      : AppTheme.borderColor,
              width: _hover && !widget.isEsaurito ? 1.5 : 1,
            ),
            boxShadow: _hover && !widget.isEsaurito
                ? [BoxShadow(color: AppTheme.secondaryColor.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))]
                : null,
          ),
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isEsaurito)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.dangerColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('ESAURITO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppTheme.dangerColor)),
                )
              else if (widget.quantitaDisponibile < 10)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${widget.quantitaDisponibile} disp.',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.warningColor),
                  ),
                )
              else
                const SizedBox(height: 18),
              const SizedBox(height: 20),
              Expanded(
                child: Text(
                  widget.alimento.nome,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.isEsaurito ? AppTheme.textLight : AppTheme.textPrimary,
                    decoration: widget.isEsaurito ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
             
              Text(
                '€${widget.prezzo.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: widget.isEsaurito ? AppTheme.textLight : AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
