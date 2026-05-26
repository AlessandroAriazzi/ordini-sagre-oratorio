import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../providers/settings_provider.dart';

class PrintService {
  static Future<void> print({
    required BuildContext context,
    required PrinterSettings settings,
    required Future<List<int>> Function(PdfPageFormat format) buildPdf,
    String docName = 'Documento',
  }) async {
    debugPrint('>>> PrintService.print - isPdf:\${settings.isPdfMode} hasPrinter:\${settings.hasSelectedPrinter} isDialog:\${settings.isSystemDialog}');

    Future<Uint8List> layout(PdfPageFormat format) async {
      debugPrint('>>> building PDF bytes...');
      final bytes = Uint8List.fromList(await buildPdf(format));
      debugPrint('>>> PDF bytes built: \${bytes.length}');
      return bytes;
    }

    if (settings.isPdfMode) {
      debugPrint('>>> modalità PDF viewer');
      await Printing.layoutPdf(name: docName, onLayout: layout);
      return;
    }

    if (settings.hasSelectedPrinter) {
      debugPrint('>>> modalità stampante diretta: \${settings.printerUrl}');
      final printers = await Printing.listPrinters();
      debugPrint('>>> stampanti trovate: \${printers.length}');
      Printer? target;
      try {
        target = printers.firstWhere(
          (p) => p.url.toString() == settings.printerUrl,
        );
      } catch (_) {
        target = null;
      }

      if (target != null) {
        debugPrint('>>> stampa diretta su: \${target.name}');
        await Printing.directPrintPdf(
          printer: target,
          name: docName,
          onLayout: layout,
        );
        return;
      }

      debugPrint('>>> stampante non trovata, fallback dialog');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Stampante "\${settings.printerName}" non trovata. '
              'Apertura dialog di sistema.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }

    debugPrint('>>> modalità dialog di sistema');
    await Printing.layoutPdf(name: docName, onLayout: layout);
    debugPrint('>>> layoutPdf completato');
  }
}