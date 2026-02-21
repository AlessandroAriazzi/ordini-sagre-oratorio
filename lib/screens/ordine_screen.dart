import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../providers/ordini_provider.dart';
import '../providers/menu_provider.dart';
import '../providers/serate_provider.dart';
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

  Future<void> _stampaOrdine(BuildContext context, WidgetRef ref) async {
    final ordiniAsync = ref.read(ordiniNotifierProvider(serataId));
    final serateAsync = ref.read(serateNotifierProvider);
    
    await ordiniAsync.when(
      data: (ordini) async {
        final ordineList = ordini.where((o) => o.id == ordineId).toList();
        final ordine = ordineList.isNotEmpty ? ordineList.first : null;
        if (ordine == null) return;

        await serateAsync.when(
          data: (serate) async {
            final serataList = serate.where((s) => s.id == serataId).toList();
            final serata = serataList.isNotEmpty ? serataList.first : null;
            if (serata == null) return;

            final pdf = pw.Document();

            pdf.addPage(
              pw.Page(
                pageFormat: PdfPageFormat.a4,
                build: (context) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Header(
                        level: 0,
                        child: pw.Text(
                          'ORDINE #${ordine.id}',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 20),
                      pw.Text('Serata: ${serata.titolo}'),
                      pw.Text('Data: ${DateFormat('dd/MM/yyyy HH:mm').format(ordine.dataOra)}'),
                      pw.Divider(height: 30),
                      pw.Text(
                        'DETTAGLIO ORDINE',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Table(
                        border: pw.TableBorder.all(),
                        children: [
                          pw.TableRow(
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.grey300,
                            ),
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  'Prodotto',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  'Qtà',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  'Prezzo',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  'Totale',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          ...ordine.items.map((item) {
                            return pw.TableRow(
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text(item.prodottoNome),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text('${item.quantita}'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text('€ ${item.prezzoUnitario.toStringAsFixed(2)}'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(8),
                                  child: pw.Text('€ ${item.totale.toStringAsFixed(2)}'),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      pw.SizedBox(height: 20),
                      pw.Divider(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            'TOTALE: €${ordine.totale.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );

            await Printing.layoutPdf(
              onLayout: (format) async => pdf.save(),
            );
          },
          loading: () {},
          error: (_, __) {},
        );
      },
      loading: () {},
      error: (_, __) {},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordiniAsync = ref.watch(ordiniNotifierProvider(serataId));
    final serateAsync = ref.watch(serateNotifierProvider);

    return ordiniAsync.when(
      data: (ordini) {
        final ordineList = ordini.where((o) => o.id == ordineId).toList();
        final ordine = ordineList.isNotEmpty ? ordineList.first : null;
        if (ordine == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Ordine non trovato')),
            body: const Center(child: Text('Ordine non trovato')),
          );
        }

        return serateAsync.when(
          data: (serate) {
            final serataList = serate.where((s) => s.id == serataId).toList();
            final serata = serataList.isNotEmpty ? serataList.first : null;
            final menuId = serata?.menuId;

            return Scaffold(
              appBar: AppBar(
                title: Text('Ordine #${ordine.id}'),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
                  onPressed: () => context.go('/serata/$serataId'),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.print, color: Colors.green),
                    tooltip: 'Stampa ordine',
                    onPressed: () => _stampaOrdine(context, ref),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Elimina ordine',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          title: const Text('Conferma eliminazione'),
                          content: const Text('Vuoi davvero eliminare questo ordine?\n\nLe quantità dei prodotti verranno ripristinate.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Annulla'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                ref
                                    .read(ordiniNotifierProvider(serataId).notifier)
                                    .deleteOrdine(ordineId);
                                Navigator.pop(context);
                                context.go('/serata/$serataId');
                              },
                              child: const Text('Elimina'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ordine.items.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart, size: 80, color: Colors.grey.shade400),
                                const SizedBox(height: 24),
                                const Text(
                                  'Ordine vuoto',
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Aggiungi prodotti dal menù sottostante',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: ordine.items.length,
                            itemBuilder: (context, index) {
                              final item = ordine.items[index];
                              return OrdineItemWidget(
                                item: item,
                                onQuantityChanged: (newQuantity) {
                                  if (newQuantity > 0) {
                                    try {
                                      ref
                                          .read(ordiniNotifierProvider(serataId).notifier)
                                          .updateItemQuantita(
                                            item.id!,
                                            ordineId,
                                            newQuantity,
                                          );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString().replaceAll('Exception: ', '')),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                onDelete: () {
                                  ref
                                      .read(ordiniNotifierProvider(serataId).notifier)
                                      .removeItemFromOrdine(item.id!, ordineId);
                                },
                              );
                            },
                          ),
                  ),
                  TotaleWidget(totale: ordine.totale),
                  if (menuId != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300, width: 2),
                        ),
                      ),
                      child: Consumer(
                        builder: (context, ref, _) {
                          final menuAsync = ref.watch(menuByIdProvider(menuId));
                          return menuAsync.when(
                            data: (menu) {
                              if (menu == null || menu.prodotti.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'Nessun prodotto disponibile nel menù',
                                    style: TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                );
                              }

                              // Raggruppa per categoria
                              final prodottiPerCategoria = <String, List>{};
                              for (final prodotto in menu.prodotti) {
                                prodottiPerCategoria.putIfAbsent(prodotto.categoria, () => []).add(prodotto);
                              }

                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.add_shopping_cart, size: 24),
                                        SizedBox(width: 12),
                                        Text(
                                          'Aggiungi prodotto:',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    ...prodottiPerCategoria.entries.map((entry) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Text(
                                              entry.key,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                          ),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: entry.value.map<Widget>((prodotto) {
                                              final isEsaurito = prodotto.isEsaurito;
                                              return ActionChip(
                                                avatar: Icon(
                                                  isEsaurito ? Icons.block : Icons.add,
                                                  size: 18,
                                                  color: isEsaurito ? Colors.red : Colors.green,
                                                ),
                                                label: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      prodotto.nome,
                                                      style: TextStyle(
                                                        color: isEsaurito ? Colors.grey : Colors.black,
                                                        decoration: isEsaurito ? TextDecoration.lineThrough : null,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      '(€${prodotto.prezzo.toStringAsFixed(2)})',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: isEsaurito ? Colors.grey : Colors.green.shade700,
                                                      ),
                                                    ),
                                                    if (!isEsaurito) ...[
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: prodotto.quantita < 10 
                                                            ? Colors.orange.shade100 
                                                            : Colors.green.shade100,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          '${prodotto.quantita}',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.bold,
                                                            color: prodotto.quantita < 10 
                                                              ? Colors.orange.shade700 
                                                              : Colors.green.shade700,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    if (isEsaurito)
                                                      Container(
                                                        margin: const EdgeInsets.only(left: 8),
                                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                        decoration: BoxDecoration(
                                                          color: Colors.red.shade100,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          'ESAURITO',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.red.shade700,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                backgroundColor: isEsaurito ? Colors.grey.shade200 : null,
                                                onPressed: isEsaurito ? null : () {
                                                  try {
                                                    ref
                                                        .read(ordiniNotifierProvider(serataId).notifier)
                                                        .addItemToOrdine(
                                                          ordineId,
                                                          prodotto.id!,
                                                          prodotto.nome,
                                                          prodotto.prezzo,
                                                        );
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(e.toString().replaceAll('Exception: ', '')),
                                                        backgroundColor: Colors.red,
                                                      ),
                                                    );
                                                  }
                                                },
                                              );
                                            }).toList(),
                                          ),
                                          const SizedBox(height: 12),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              );
                            },
                            loading: () => const Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            error: (_, __) => const Center(
                              child: Text(
                                'Errore caricamento menù',
                                style: TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const Scaffold(
            body: Center(child: Text('Errore caricamento serata')),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Errore: $error')),
      ),
    );
  }
}