import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../providers/ordini_provider.dart';
import '../providers/serate_provider.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────
const _surface      = Color(0xFFF7F9FB);
const _white        = Color(0xFFFFFFFF);
const _onSurface    = Color(0xFF191C1E);
const _onSurfaceVar = Color(0xFF45464D);
const _outline      = Color(0xFF76777D);
const _outlineVar   = Color(0xFFC6C6CD);
const _secondary    = Color(0xFF006C49);
const _danger       = Color(0xFFBA1A1A);
const _warning      = Color(0xFFF59E0B);
const _success      = Color(0xFF10B981);
// ──────────────────────────────────────────────────────────────────────────────

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
            backgroundColor: _success,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore esportazione: $e'),
            backgroundColor: _danger,
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
      backgroundColor: _surface,
      body: ordiniAsync.when(
        data: (ordini) {
          return serateAsync.when(
            data: (serate) {
              final serata = serate.where((s) => s.id == serataId).firstOrNull;
              if (serata == null) {
                return Center(
                  child: Text('Serata non trovata',
                      style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
                );
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
                  // ── Header ────────────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.fromLTRB(28, 18, 28, 14),
                    decoration: const BoxDecoration(
                      color: _white,
                      border: Border(bottom: BorderSide(color: _outlineVar)),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => context.go('/serate'),
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.chevron_left_rounded, size: 16, color: _onSurfaceVar),
                                const SizedBox(width: 4),
                                Text(
                                  serata.titolo,
                                  style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text('/', style: GoogleFonts.inter(color: _outline, fontSize: 13)),
                        ),
                        Text(
                          'Resoconto',
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: _onSurface),
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: () => _esportaPDF(context, ref),
                          icon: const Icon(Icons.picture_as_pdf_rounded, size: 15),
                          label: Text('Esporta PDF',
                              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500)),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: _white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Content ───────────────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(28),
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
                                  color: _secondary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _KpiCard(
                                  icon: Icons.inventory_2_rounded,
                                  label: 'Prodotti venduti',
                                  value: '$numProdottiTotali',
                                  color: _warning,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _KpiCard(
                                  icon: Icons.euro_rounded,
                                  label: 'Incasso totale',
                                  value: '€${totaleGenerale.toStringAsFixed(2)}',
                                  color: _success,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // Product stats table
                          if (prodottiStats.isNotEmpty) ...[
                            Text(
                              'Statistiche prodotti',
                              style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                  color: _onSurfaceVar),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: _white,
                                border: Border.all(color: _outlineVar),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    color: _surface,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(flex: 3, child: Text('PRODOTTO', style: _thSt)),
                                        SizedBox(width: 100, child: Text('QUANTITÀ', style: _thSt, textAlign: TextAlign.center)),
                                        SizedBox(width: 130, child: Text('PREZZO UNIT.', style: _thSt, textAlign: TextAlign.right)),
                                        SizedBox(width: 130, child: Text('TOTALE', style: _thSt, textAlign: TextAlign.right)),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1, color: _outlineVar),
                                  ...prodottiStats.entries.toList().asMap().entries.map((e) {
                                    final isLast = e.key == prodottiStats.length - 1;
                                    final entry = e.value;
                                    return Column(
                                      children: [
                                        _ProdottoStatRow(
                                          nome: entry.key,
                                          quantita: entry.value['quantita'] as int,
                                          prezzo: entry.value['prezzo'] as double,
                                          totale: entry.value['totale'] as double,
                                        ),
                                        if (!isLast) const Divider(height: 1, color: _outlineVar),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                          ],

                          // Orders list
                          if (ordini.isNotEmpty) ...[
                            Text(
                              'Dettaglio ordini',
                              style: GoogleFonts.jetBrainsMono(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                  color: _onSurfaceVar),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: _white,
                                border: Border.all(color: _outlineVar),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    color: _surface,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 80, child: Text('ORDINE', style: _thSt)),
                                        SizedBox(width: 70, child: Text('ORA', style: _thSt)),
                                        Expanded(child: Text('PRODOTTI', style: _thSt)),
                                        SizedBox(width: 120, child: Text('TOTALE', style: _thSt, textAlign: TextAlign.right)),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1, color: _outlineVar),
                                  ...ordini.asMap().entries.map<Widget>((e) {
                                    final i = e.key;
                                    final ordine = e.value;
                                    return Column(
                                      children: [
                                        if (i > 0) const Divider(height: 1, color: _outlineVar),
                                        Theme(
                                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                          child: ExpansionTile(
                                            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                            leading: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: _secondary.withValues(alpha: 0.08),
                                                border: Border.all(color: _secondary.withValues(alpha: 0.2)),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '#${ordine.numero}',
                                                  style: GoogleFonts.jetBrainsMono(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w700,
                                                      color: _secondary),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              'Ordine #${ordine.numero}',
                                              style: GoogleFonts.inter(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: _onSurface),
                                            ),
                                            subtitle: Text(
                                              DateFormat('HH:mm').format(ordine.dataOra),
                                              style: GoogleFonts.inter(fontSize: 12, color: _onSurfaceVar),
                                            ),
                                            trailing: Text(
                                              '€${ordine.totale.toStringAsFixed(2)}',
                                              style: GoogleFonts.jetBrainsMono(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: _success),
                                            ),
                                            children: [
                                              Container(
                                                color: _surface,
                                                child: Column(
                                                  children: [
                                                    const Divider(height: 1, color: _outlineVar),
                                                    ...ordine.items.map<Widget>((item) {
                                                      return Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(item.prodottoNome,
                                                                  style: GoogleFonts.inter(
                                                                      fontSize: 13, color: _onSurface)),
                                                            ),
                                                            Text(
                                                              '${item.quantita}× €${item.prezzoUnitario.toStringAsFixed(2)}',
                                                              style: GoogleFonts.inter(
                                                                  fontSize: 12, color: _onSurfaceVar),
                                                            ),
                                                            const SizedBox(width: 16),
                                                            SizedBox(
                                                              width: 80,
                                                              child: Text(
                                                                '€${item.totale.toStringAsFixed(2)}',
                                                                style: GoogleFonts.jetBrainsMono(
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: _onSurface),
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
                                  }),
                                ],
                              ),
                            ),
                          ],

                          if (ordini.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(48),
                              decoration: BoxDecoration(
                                color: _white,
                                border: Border.all(color: _outlineVar),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: _surface,
                                        border: Border.all(color: _outlineVar),
                                      ),
                                      child: const Icon(Icons.receipt_long_rounded, size: 36, color: _outline),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Nessun ordine registrato',
                                      style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: _onSurface),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Gli ordini appariranno qui una volta creati.',
                                      style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar),
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
            error: (_, _) => Center(
                child: Text('Errore caricamento serata',
                    style: GoogleFonts.inter(color: _danger))),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
            child: Text('Errore: $error',
                style: GoogleFonts.inter(color: _danger))),
      ),
    );
  }
}

// ─── KPI Card ─────────────────────────────────────────────────────────────────

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
        color: _white,
        border: Border.all(color: _outlineVar),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              border: Border.all(color: color.withValues(alpha: 0.15)),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: -0.5),
          ),
          const SizedBox(height: 2),
          Text(label,
              style: GoogleFonts.inter(fontSize: 13, color: _onSurfaceVar)),
        ],
      ),
    );
  }
}

// ─── Prodotto Stat Row ────────────────────────────────────────────────────────

class _ProdottoStatRow extends StatefulWidget {
  final String nome;
  final int quantita;
  final double prezzo;
  final double totale;

  const _ProdottoStatRow({
    required this.nome,
    required this.quantita,
    required this.prezzo,
    required this.totale,
  });

  @override
  State<_ProdottoStatRow> createState() => _ProdottoStatRowState();
}

class _ProdottoStatRowState extends State<_ProdottoStatRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _hover ? _surface : _white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(widget.nome,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _onSurface)),
            ),
            SizedBox(
              width: 100,
              child: Text('${widget.quantita}',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 13, color: _onSurfaceVar),
                  textAlign: TextAlign.center),
            ),
            SizedBox(
              width: 130,
              child: Text('€${widget.prezzo.toStringAsFixed(2)}',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 13, color: _onSurfaceVar),
                  textAlign: TextAlign.right),
            ),
            SizedBox(
              width: 130,
              child: Text('€${widget.totale.toStringAsFixed(2)}',
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _success),
                  textAlign: TextAlign.right),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Styles ───────────────────────────────────────────────────────────────────

TextStyle get _thSt => GoogleFonts.jetBrainsMono(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: _onSurfaceVar,
      letterSpacing: 0.5,
    );
