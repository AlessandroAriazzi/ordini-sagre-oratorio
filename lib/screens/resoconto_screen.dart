import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../providers/ordini_provider.dart';
import '../providers/serate_provider.dart';

class ResocontoScreen extends ConsumerWidget {
  final int serataId;

  const ResocontoScreen({super.key, required this.serataId});

  Future<void> _esportaPDF(BuildContext context, WidgetRef ref) async {
    final ordiniAsync = ref.read(ordiniNotifierProvider(serataId));
    final serateAsync = ref.read(serateNotifierProvider);

    await ordiniAsync.when(
      data: (ordini) async {
        await serateAsync.when(
          data: (serate) async {
            final serata = serate.where((s) => s.id == serataId).firstOrNull;
            if (serata == null) return;

            final totaleGenerale = ordini.fold(0.0, (sum, ordine) => sum + ordine.totale);
            final numOrdini = ordini.length;
            final numProdottiTotali = ordini.fold(
              0,
              (sum, ordine) => sum + ordine.items.fold(0, (s, item) => s + item.quantita),
            );

            // Calcola statistiche prodotti
            final Map<String, Map<String, dynamic>> prodottiStats = {};
            for (final ordine in ordini) {
              for (final item in ordine.items) {
                if (!prodottiStats.containsKey(item.prodottoNome)) {
                  prodottiStats[item.prodottoNome] = {
                    'quantita': 0,
                    'totale': 0.0,
                    'prezzo': item.prezzoUnitario,
                  };
                }
                prodottiStats[item.prodottoNome]!['quantita'] += item.quantita;
                prodottiStats[item.prodottoNome]!['totale'] += item.totale;
              }
            }

            final pdf = pw.Document();

            pdf.addPage(
              pw.MultiPage(
                pageFormat: PdfPageFormat.a4,
                build: (context) {
                  return [
                    pw.Header(
                      level: 0,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'RESOCONTO SERATA',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Text(
                            serata.titolo,
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            DateFormat('dd/MM/yyyy').format(serata.data),
                            style: const pw.TextStyle(color: PdfColors.grey),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey200,
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard('Ordini totali', '$numOrdini'),
                          _buildStatCard('Prodotti venduti', '$numProdottiTotali'),
                          _buildStatCard(
                            'Incasso totale',
                            '€${totaleGenerale.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 30),
                    pw.Text(
                      'STATISTICHE PRODOTTI',
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
                                'Quantità',
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                'Prezzo unitario',
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
                        ...prodottiStats.entries.map((entry) {
                          return pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(entry.key),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text('${entry.value['quantita']}'),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  '€${entry.value['prezzo'].toStringAsFixed(2)}',
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(8),
                                child: pw.Text(
                                  '€${entry.value['totale'].toStringAsFixed(2)}',
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                    pw.SizedBox(height: 30),
                    pw.Text(
                      'DETTAGLIO ORDINI',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    ...ordini.map((ordine) {
                      return pw.Container(
                        margin: const pw.EdgeInsets.only(bottom: 16),
                        padding: const pw.EdgeInsets.all(12),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey),
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  'Ordine #${ordine.id}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Text(
                                  DateFormat('HH:mm').format(ordine.dataOra),
                                  style: const pw.TextStyle(color: PdfColors.grey),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 8),
                            ...ordine.items.map((item) {
                              return pw.Padding(
                                padding: const pw.EdgeInsets.only(left: 16, top: 4),
                                child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text('${item.quantita}x ${item.prodottoNome}'),
                                    pw.Text('€${item.totale.toStringAsFixed(2)}'),
                                  ],
                                ),
                              );
                            }),
                            pw.Divider(height: 16),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  'Totale: €${ordine.totale.toStringAsFixed(2)}',
                                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ];
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

  pw.Widget _buildStatCard(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordiniAsync = ref.watch(ordiniNotifierProvider(serataId));
    final serateAsync = ref.watch(serateNotifierProvider);

    debugPrint('ResocontoScreen initialized with serataId: $serataId');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resoconto Serata'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
          onPressed: () => context.go('/serata/$serataId'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
            tooltip: 'Esporta PDF',
            onPressed: () => _esportaPDF(context, ref),
          ),
        ],
      ),
      body: ordiniAsync.when(
        data: (ordini) {
          return serateAsync.when(
            data: (serate) {
              final serata = serate.where((s) => s.id == serataId).firstOrNull;
              if (serata == null) {
                return const Center(child: Text('Serata non trovata'));
              }

              final totaleGenerale = ordini.fold(0.0, (sum, ordine) => sum + ordine.totale);
              final numOrdini = ordini.length;
              final numProdottiTotali = ordini.fold(
                0,
                (sum, ordine) => sum + ordine.items.fold(0, (s, item) => s + item.quantita),
              );

              // Calcola statistiche prodotti
              final Map<String, Map<String, dynamic>> prodottiStats = {};
              for (final ordine in ordini) {
                for (final item in ordine.items) {
                  if (!prodottiStats.containsKey(item.prodottoNome)) {
                    prodottiStats[item.prodottoNome] = {
                      'quantita': 0,
                      'totale': 0.0,
                      'prezzo': item.prezzoUnitario,
                    };
                  }
                  prodottiStats[item.prodottoNome]!['quantita'] += item.quantita;
                  prodottiStats[item.prodottoNome]!['totale'] += item.totale;
                }
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              serata.titolo,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              DateFormat('EEEE dd MMMM yyyy', 'it_IT').format(serata.data),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.receipt_long,
                            label: 'Ordini totali',
                            value: '$numOrdini',
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.inventory_2,
                            label: 'Prodotti venduti',
                            value: '$numProdottiTotali',
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.euro,
                            label: 'Incasso totale',
                            value: '€${totaleGenerale.toStringAsFixed(2)}',
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Statistiche Prodotti',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: prodottiStats.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Qtà: ${entry.value['quantita']}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '€${entry.value['prezzo'].toStringAsFixed(2)}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '€${entry.value['totale'].toStringAsFixed(2)}',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Dettaglio Ordini',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ordini.length,
                      itemBuilder: (context, index) {
                        final ordine = ordini[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ExpansionTile(
                            leading: CircleAvatar(
                              child: Text('#${ordine.id}'),
                            ),
                            title: Text(
                              'Ordine #${ordine.id}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              DateFormat('HH:mm').format(ordine.dataOra),
                            ),
                            trailing: Text(
                              '€${ordine.totale.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            children: ordine.items.map((item) {
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 72,
                                  vertical: 4,
                                ),
                                title: Text(item.prodottoNome),
                                trailing: Text(
                                  '${item.quantita}x €${item.prezzoUnitario.toStringAsFixed(2)} = €${item.totale.toStringAsFixed(2)}',
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Errore caricamento serata')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Errore: $error')),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}