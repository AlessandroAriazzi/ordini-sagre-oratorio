import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

part 'settings_provider.g.dart';

// ─── Modello ────────────────────────────────────────────────────────────────

class PrinterSettings {
  final String? printerUrl;
  final String? printerName;
  final bool usePdfMode;

  const PrinterSettings({
    this.printerUrl,
    this.printerName,
    this.usePdfMode = false,
  });

  bool get isPdfMode => usePdfMode;
  bool get isSystemDialog => !usePdfMode && printerUrl == null;
  bool get hasSelectedPrinter => !usePdfMode && printerUrl != null;

  Map<String, dynamic> toJson() => {
        'printerUrl': printerUrl,
        'printerName': printerName,
        'usePdfMode': usePdfMode,
      };

  factory PrinterSettings.fromJson(Map<String, dynamic> json) =>
      PrinterSettings(
        printerUrl: json['printerUrl'] as String?,
        printerName: json['printerName'] as String?,
        usePdfMode: (json['usePdfMode'] as bool?) ?? false,
      );
}

// ─── Persistenza su file ────────────────────────────────────────────────────

Future<File> _settingsFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/app_settings.json');
}

Future<PrinterSettings> _loadSettings() async {
  try {
    final file = await _settingsFile();
    if (!await file.exists()) return const PrinterSettings();
    final raw = await file.readAsString();
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return PrinterSettings.fromJson(json);
  } catch (e) {
    debugPrint('Settings load error: $e');
    return const PrinterSettings();
  }
}

Future<void> _saveSettings(PrinterSettings s) async {
  try {
    final file = await _settingsFile();
    await file.writeAsString(jsonEncode(s.toJson()));
  } catch (e) {
    debugPrint('Settings save error: $e');
  }
}

// ─── Provider ───────────────────────────────────────────────────────────────

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<PrinterSettings> build() => _loadSettings();

  Future<void> setPdfMode(bool value) async {
    final next = PrinterSettings(usePdfMode: value);
    await _saveSettings(next);
    state = AsyncData(next);
  }

  Future<void> selectPrinter(Printer printer) async {
    final next = PrinterSettings(
      printerUrl: printer.url.toString(),
      printerName: printer.name,
      usePdfMode: false,
    );
    await _saveSettings(next);
    state = AsyncData(next);
  }

  Future<void> clearPrinter() async {
    const next = PrinterSettings();
    await _saveSettings(next);
    state = const AsyncData(PrinterSettings());
  }
}