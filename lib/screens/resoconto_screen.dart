import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../providers/ordini_provider.dart';
import '../providers/serate_provider.dart';
import '../theme.dart';

class ResocontoScreen extends ConsumerWidget {
  final int serataId;

  const ResocontoScreen({super.key, required this.serataId});

  Future<List<int>> _buildPdf(
    PdfPageFormat format,
    List<dynamic> ordini,
    dynamic serata,
  ) async {
    final totaleGenerale = ordini.fold(0.0, (sum, o) => sum + o.totale);
    final numOrdini = ordini.length;
    int numProdottiTotali = 0;
    for (final o in ordini) {
      for (final item in o.items) {
        numProdottiTotali += (item.quantita as int);
      }
    }

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
        pageFormat: format,
        build: (context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('RESOCONTO SERATA', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 10),
                  pw.Text(serata.titolo, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.Text(DateFormat('dd/MM/yyyy').format(serata.data), style: const pw.TextStyle(color: PdfColors.grey)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(color: PdfColors.grey200, borderRadius: pw.BorderRadius.circular(8)),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _pdfStatCard('Ordini totali', '$numOrdini'),
                  _pdfStatCard('Prodotti venduti', '$numProdottiTotali'),
                  _pdfStatCard('Incasso totale', 'EUR ${totaleGenerale.toStringAsFixed(2)}'),
                ],
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Text('STATISTICHE PRODOTTI', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: ['Prodotto', 'Quantità', 'Prezzo unitario', 'Totale']
                      .map((h) => pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(h, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ))
                      .toList(),
                ),
                ...prodottiStats.entries.map((entry) {
                  return pw.TableRow(
                    children: [
                      entry.key,
                      '${entry.value['quantita']}',
                      'EUR ${entry.value['prezzo'].toStringAsFixed(2)}',
                      'EUR ${entry.value['totale'].toStringAsFixed(2)}',
                    ].map((t) => pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(t))).toList(),
                  );
                }),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.Text('DETTAGLIO ORDINI', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ...ordini.map<pw.Widget>((ordine) {
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 16),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey), borderRadius: pw.BorderRadius.circular(4)),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Ordine #${ordine.id}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(DateFormat('HH:mm').format(ordine.dataOra), style: const pw.TextStyle(color: PdfColors.grey)),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    ...ordine.items.map<pw.Widget>((item) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 16, top: 4),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('${item.quantita}x ${item.prodottoNome}'),
                            pw.Text('EUR ${item.totale.toStringAsFixed(2)}'),
                          ],
                        ),
                      );
                    }),
                    pw.Divider(height: 16),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text('Totale: EUR ${ordine.totale.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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

    return pdf.save();
  }

  pw.Widget _pdfStatCard(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(value, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text(label, style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
      ],
    );
  }

  Future<void> _esportaPDF(BuildContext context, WidgetRef ref) async {
    final ordini = ref.read(ordiniProvider(serataId)).value;
    if (ordini == null) return;
    final serate = ref.read(serateProvider).value;
    if (serate == null) return;
    final serata = serate.where((s) => s.id == serataId).firstOrNull;
    if (serata == null) return;

    try {
      final bytes = await _buildPdf(PdfPageFormat.a4, ordini, serata);

      final safeTitle = serata.titolo.replaceAll(RegExp(r'[^\w\s-]'), '_');
      final dateStr = DateFormat('yyyy-MM-dd').format(serata.data);
      final defaultName = 'Resoconto_${safeTitle}_$dateStr.pdf';

      final savePath = await FilePicker.saveFile(
        dialogTitle: 'Salva resoconto PDF',
        fileName: defaultName,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        bytes: Uint8List.fromList(bytes),
      );

      if (savePath == null) return;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF salvato: $savePath'),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore esportazione: $e'),
            backgroundColor: AppTheme.dangerColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordiniAsync = ref.watch(ordiniProvider(serataId));
    final serateAsync = ref.watch(serateProvider);

    return Scaffold(
      body: ordiniAsync.when(
        data: (ordini) {
          return serateAsync.when(
            data: (serate) {
              final serata = serate.where((s) => s.id == serataId).firstOrNull;
              if (serata == null) {
                return const Center(child: Text('Serata non trovata'));
              }

              final totaleGenerale = ordini.fold(0.0, (sum, o) => sum + o.totale);
              final numOrdini = ordini.length;
              final numProdottiTotali = () {
                int total = 0;
                for (final o in ordini) {
                  for (final item in o.items) {
                    total += item.quantita;
                  }
                }
                return total;
              }();

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

              return Column(
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
                                  serata.titolo,
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
                        const Text(
                          'Resoconto',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: () => _esportaPDF(context, ref),
                          icon: const Icon(Icons.picture_as_pdf_rounded, size: 15),
                          label: const Text('Esporta PDF'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.secondaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
                          // KPI row
                          Row(
                            children: [
                              Expanded(
                                child: _KpiCard(
                                  icon: Icons.receipt_long_rounded,
                                  label: 'Ordini totali',
                                  value: '$numOrdini',
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _KpiCard(
                                  icon: Icons.inventory_2_rounded,
                                  label: 'Prodotti venduti',
                                  value: '$numProdottiTotali',
                                  color: AppTheme.warningColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _KpiCard(
                                  icon: Icons.euro_rounded,
                                  label: 'Incasso totale',
                                  value: '€${totaleGenerale.toStringAsFixed(2)}',
                                  color: AppTheme.successColor,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Product stats table
                          if (prodottiStats.isNotEmpty) ...[
                            const Text(
                              'Statistiche prodotti',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                            ),
                            const SizedBox(height: 12),
                            Container(
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
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: const Row(
                                        children: [
                                          Expanded(flex: 3, child: Text('Prodotto', style: _headerStyle)),
                                          SizedBox(width: 100, child: Text('Quantità', style: _headerStyle, textAlign: TextAlign.center)),
                                          SizedBox(width: 120, child: Text('Prezzo unit.', style: _headerStyle, textAlign: TextAlign.right)),
                                          SizedBox(width: 120, child: Text('Totale', style: _headerStyle, textAlign: TextAlign.right)),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1, color: AppTheme.borderColor),
                                    ...prodottiStats.entries.toList().asMap().entries.map((e) {
                                      final isLast = e.key == prodottiStats.length - 1;
                                      final entry = e.value;
                                      return Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    entry.key,
                                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 100,
                                                  child: Text(
                                                    '${entry.value['quantita']}',
                                                    style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    '€${entry.value['prezzo'].toStringAsFixed(2)}',
                                                    style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                    '€${entry.value['totale'].toStringAsFixed(2)}',
                                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.successColor),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (!isLast) const Divider(height: 1, color: AppTheme.borderColor),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],

                          // Orders accordion
                          if (ordini.isNotEmpty) ...[
                            const Text(
                              'Dettaglio ordini',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.borderColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Column(
                                  children: ordini.asMap().entries.map<Widget>((e) {
                                    final i = e.key;
                                    final ordine = e.value;
                                    return Column(
                                      children: [
                                        if (i > 0) const Divider(height: 1, color: AppTheme.borderColor),
                                        Theme(
                                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                          child: ExpansionTile(
                                            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                            leading: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '#${ordine.id}',
                                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.secondaryColor),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              'Ordine #${ordine.id}',
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                            ),
                                            subtitle: Text(
                                              DateFormat('HH:mm').format(ordine.dataOra),
                                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                            ),
                                            trailing: Text(
                                              '€${ordine.totale.toStringAsFixed(2)}',
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.successColor),
                                            ),
                                            children: [
                                              Container(
                                                color: AppTheme.backgroundColor,
                                                child: Column(
                                                  children: [
                                                    const Divider(height: 1, color: AppTheme.borderColor),
                                                    ...ordine.items.map<Widget>((item) {
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(item.prodottoNome, style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary)),
                                                            ),
                                                            Text(
                                                              '${item.quantita}× €${item.prezzoUnitario.toStringAsFixed(2)}',
                                                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                                            ),
                                                            const SizedBox(width: 16),
                                                            SizedBox(
                                                              width: 80,
                                                              child: Text(
                                                                '€${item.totale.toStringAsFixed(2)}',
                                                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                                                textAlign: TextAlign.right,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                    const SizedBox(height: 4),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],

                          if (ordini.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(48),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppTheme.backgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppTheme.borderColor),
                                      ),
                                      child: const Icon(Icons.receipt_long_rounded, size: 36, color: AppTheme.textLight),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Nessun ordine registrato',
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Gli ordini appariranno qui una volta creati.',
                                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(child: Text('Errore caricamento serata')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Errore: $error')),
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

class _KpiCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _KpiCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: color, letterSpacing: -0.5),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
