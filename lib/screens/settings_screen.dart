import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart' as ftp;
import 'package:printing/printing.dart';

import '../providers/settings_provider.dart';
import '../providers/thermal_printer_provider.dart';
import '../theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  List<Printer> _printers = [];
  bool _loadingPrinters = false;
  String? _printerError;

  @override
  void initState() {
    super.initState();
    _loadPrinters();
  }

  Future<void> _loadPrinters() async {
    setState(() {
      _loadingPrinters = true;
      _printerError = null;
    });
    try {
      final printers = await Printing.listPrinters();
      if (mounted) {
        setState(() {
          _printers = printers;
          _loadingPrinters = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _printerError = 'Impossibile caricare le stampanti: $e';
          _loadingPrinters = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withValues(alpha:0.7),
                      ]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha:0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.settings_rounded,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(width: 24),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Impostazioni',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Configura le preferenze di stampa',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 48),

              settingsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Text('Errore: $e',
                      style: const TextStyle(color: AppTheme.dangerColor)),
                ),
                data: (settings) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Modalità di stampa ──────────────────────────────
                    const _SectionHeader(
                      icon: Icons.print_rounded,
                      title: 'Modalità di stampa',
                    ),
                    const SizedBox(height: 16),

                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            _PrintModeOption(
                              icon: Icons.open_in_new_rounded,
                              iconColor: AppTheme.secondaryColor,
                              title: 'Dialog di sistema',
                              subtitle:
                                  'Apre la finestra di stampa del sistema operativo. '
                                  'Puoi scegliere la stampante ad ogni stampa.',
                              selected: settings.isSystemDialog,
                              onTap: () => ref
                                  .read(settingsProvider.notifier)
                                  .clearPrinter(),
                            ),
                            const Divider(height: 1),
                            _PrintModeOption(
                              icon: Icons.picture_as_pdf_rounded,
                              iconColor: AppTheme.dangerColor,
                              title: 'PDF / Anteprima',
                              subtitle:
                                  'Genera il PDF e apre il visualizzatore. '
                                  'Utile per salvare o inviare il documento.',
                              selected: settings.isPdfMode,
                              onTap: () => ref
                                  .read(settingsProvider.notifier)
                                  .setPdfMode(true),
                            ),
                            const Divider(height: 1),
                            _PrintModeOption(
                              icon: Icons.local_printshop_rounded,
                              iconColor: AppTheme.successColor,
                              title: 'Stampante diretta',
                              subtitle:
                                  'Stampa senza dialog su una stampante specifica. '
                                  'Seleziona la stampante nell\'elenco sottostante.',
                              selected: settings.hasSelectedPrinter,
                              // Sola lettura: la selezione avviene tramite tile
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Elenco stampanti ────────────────────────────────
                    Row(
                      children: [
                        const _SectionHeader(
                          icon: Icons.devices_rounded,
                          title: 'Stampanti disponibili',
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed:
                              _loadingPrinters ? null : _loadPrinters,
                          icon: _loadingPrinters
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : const Icon(Icons.refresh_rounded),
                          label: const Text('Aggiorna'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_printerError != null)
                      _ErrorCard(message: _printerError!)
                    else if (_loadingPrinters)
                      const _LoadingCard()
                    else if (_printers.isEmpty)
                      const _EmptyPrintersCard()
                    else
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: _printers.asMap().entries.map((e) {
                              final printer = e.value;
                              final isSelected =
                                  settings.hasSelectedPrinter &&
                                      settings.printerUrl ==
                                          printer.url.toString();
                              return Column(
                                children: [
                                  if (e.key > 0) const Divider(height: 1),
                                  _PrinterTile(
                                    printer: printer,
                                    isSelected: isSelected,
                                    onSelect: () => ref
                                        .read(settingsProvider
                                            .notifier)
                                        .selectPrinter(printer),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                    const SizedBox(height: 32),

                    // ── Badge impostazione corrente ──────────────────────
                    _CurrentSettingBadge(settings: settings),

                    const SizedBox(height: 48),

                    // ── Stampante Scontrini POS ─────────────────────────────
                    const _SectionHeader(
                      icon: Icons.receipt_long_rounded,
                      title: 'Stampante Scontrini (POS)',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Usata per stampare i ticket degli ordini direttamente sulla stampante termica.',
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    const _ThermalPrinterSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widgets interni ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textSecondary, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _PrintModeOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _PrintModeOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha:0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? AppTheme.secondaryColor
                          : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _RadioCircle(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _PrinterTile extends StatelessWidget {
  final Printer printer;
  final bool isSelected;
  final VoidCallback onSelect;

  const _PrinterTile({
    required this.printer,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.successColor.withValues(alpha:0.1)
                    : AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                printer.isDefault
                    ? Icons.star_rounded
                    : Icons.local_printshop_rounded,
                color: isSelected
                    ? AppTheme.successColor
                    : AppTheme.textSecondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          printer.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppTheme.secondaryColor
                                : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      if (printer.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.warningColor.withValues(alpha:0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Predefinita',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.warningColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (printer.model!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        printer.model.toString(),
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ),
                ],
              ),
            ),
            _RadioCircle(selected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  final bool selected;
  const _RadioCircle({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              selected ? AppTheme.secondaryColor : AppTheme.textLight,
          width: 2,
        ),
        color: selected ? AppTheme.secondaryColor : Colors.transparent,
      ),
      child: selected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}

class _CurrentSettingBadge extends StatelessWidget {
  final PrinterSettings settings;
  const _CurrentSettingBadge({required this.settings});

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = settings.isPdfMode
        ? (
            Icons.picture_as_pdf_rounded,
            AppTheme.dangerColor,
            'Modalità attiva: PDF / Anteprima'
          )
        : settings.hasSelectedPrinter
            ? (
                Icons.local_printshop_rounded,
                AppTheme.successColor,
                'Stampante attiva: ${settings.printerName}'
              )
            : (
                Icons.open_in_new_rounded,
                AppTheme.secondaryColor,
                'Modalità attiva: Dialog di sistema'
              );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha:0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.dangerColor.withValues(alpha:0.08),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppTheme.dangerColor),
            const SizedBox(width: 12),
            Expanded(
                child: Text(message,
                    style: const TextStyle(color: AppTheme.dangerColor))),
          ],
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Ricerca stampanti in corso…'),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPrintersCard extends StatelessWidget {
  const _EmptyPrintersCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 0,
      color: AppTheme.backgroundColor,
      child:  Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.print_disabled_rounded,
                  size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text('Nessuna stampante trovata',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 4),
              Text(
                'Verifica che le stampanti siano collegate e accese',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThermalPrinterSection extends ConsumerStatefulWidget {
  const _ThermalPrinterSection();

  @override
  ConsumerState<_ThermalPrinterSection> createState() =>
      _ThermalPrinterSectionState();
}

class _ThermalPrinterSectionState
    extends ConsumerState<_ThermalPrinterSection> {
  List<ftp.Printer> _discovered = [];
  bool _scanning = false;
  StreamSubscription<List<ftp.Printer>>? _sub;

  List<String> _cupsPrinters = [];
  bool _loadingCups = false;

  final _addressCtrl = TextEditingController();
  final _portCtrl = TextEditingController(text: '9100');
  final _nameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (Platform.isMacOS) _loadCupsPrinters();
  }

  @override
  void dispose() {
    _sub?.cancel();
    FlutterThermalPrinter.instance.stopScan();
    _addressCtrl.dispose();
    _portCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCupsPrinters() async {
    setState(() => _loadingCups = true);
    try {
      final result = await Process.run('/usr/bin/lpstat', ['-a']);
      if (mounted) {
        final names = (result.stdout as String)
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty)
            .map((l) => l.split(RegExp(r'\s+'))[0])
            .where((n) => n.isNotEmpty)
            .toList();
        setState(() { _cupsPrinters = names; _loadingCups = false; });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingCups = false);
    }
  }

  Future<void> _startScan() async {
    setState(() {
      _scanning = true;
      _discovered = [];
    });
    await _sub?.cancel();
    await FlutterThermalPrinter.instance
        .getPrinters(connectionTypes: [ftp.ConnectionType.USB]);
    _sub = FlutterThermalPrinter.instance.devicesStream.listen((printers) {
      if (mounted) setState(() => _discovered = printers);
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        FlutterThermalPrinter.instance.stopScan();
        setState(() => _scanning = false);
      }
    });
  }

  Future<void> _saveUsb(ftp.Printer p) async {
    await ref.read(thermalPrinterProvider.notifier).saveUsbPrinter(
          name: p.name ?? p.address ?? 'USB Printer',
          address: p.address ?? '',
          vendorId: p.vendorId,
          productId: p.productId,
        );
  }

  Future<void> _saveNetwork() async {
    final addr = _addressCtrl.text.trim();
    final port = int.tryParse(_portCtrl.text.trim()) ?? 9100;
    if (addr.isEmpty) return;
    await ref.read(thermalPrinterProvider.notifier).saveNetworkPrinter(
          address: addr,
          port: port,
          name: _nameCtrl.text.trim().isEmpty ? addr : _nameCtrl.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(thermalPrinterProvider);

    return configAsync.when(
      loading: () => const _LoadingCard(),
      error: (e, _) => _ErrorCard(message: e.toString()),
      data: (config) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (config.isConfigured)
            Card(
              color: AppTheme.successColor.withValues(alpha: 0.08),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppTheme.successColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(config.name ?? config.address ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          Text(
                            config.connectionType == 'USB'
                                ? 'USB'
                                : config.connectionType == 'CUPS'
                                    ? 'CUPS (macOS)'
                                    : '${config.address}:${config.port}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () =>
                          ref.read(thermalPrinterProvider.notifier).clear(),
                      icon: const Icon(Icons.delete_outline_rounded,
                          size: 18),
                      label: const Text('Rimuovi'),
                      style: TextButton.styleFrom(
                          foregroundColor: AppTheme.dangerColor),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 12),

          // CUPS (macOS only)
          if (Platform.isMacOS)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.computer_rounded),
                        const SizedBox(width: 8),
                        const Text('CUPS (macOS)', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: _loadingCups ? null : _loadCupsPrinters,
                          icon: _loadingCups
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.refresh_rounded, size: 18),
                          label: Text(_loadingCups ? 'Carico…' : 'Aggiorna'),
                        ),
                      ],
                    ),
                    if (_cupsPrinters.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      ..._cupsPrinters.map((name) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.print_rounded),
                        title: Text(name),
                        trailing: FilledButton(
                          onPressed: () => ref.read(thermalPrinterProvider.notifier).saveCupsPrinter(name: name),
                          child: const Text('Seleziona'),
                        ),
                      )),
                    ] else if (!_loadingCups)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('Nessuna stampante CUPS trovata.', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 8),

          // USB scan
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.usb_rounded),
                      const SizedBox(width: 8),
                      const Text('USB',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _scanning ? null : _startScan,
                        icon: _scanning
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white))
                            : const Icon(Icons.search_rounded, size: 18),
                        label: Text(_scanning ? 'Ricerca…' : 'Cerca'),
                      ),
                    ],
                  ),
                  if (_discovered.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ..._discovered.map((p) => ListTile(
                          dense: true,
                          leading: const Icon(Icons.print_rounded),
                          title: Text(p.name ?? p.address ?? 'Unknown'),
                          subtitle: Text(p.address ?? ''),
                          trailing: FilledButton(
                            onPressed: () => _saveUsb(p),
                            child: const Text('Seleziona'),
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Network printer
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                const Row(
                  children: [
                    Icon(Icons.lan_rounded),
                    SizedBox(width: 8),
                    Text('Rete',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nome (opzionale)',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _addressCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Indirizzo IP',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _portCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Porta',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: _saveNetwork,
                    icon: const Icon(Icons.save_rounded, size: 18),
                    label: const Text('Salva'),
                  ),
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}