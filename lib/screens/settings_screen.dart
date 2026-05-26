import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../providers/settings_provider.dart';
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
    final settingsAsync = ref.watch(settingsNotifierProvider);

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
                                  .read(settingsNotifierProvider.notifier)
                                  .clearPrinter(),
                            ),
                            const Divider(height: 1),
                            _PrintModeOption(
                              icon: Icons.picture_as_pdf_rounded,
                              iconColor: Colors.red.shade600,
                              title: 'PDF / Anteprima',
                              subtitle:
                                  'Genera il PDF e apre il visualizzatore. '
                                  'Utile per salvare o inviare il documento.',
                              selected: settings.isPdfMode,
                              onTap: () => ref
                                  .read(settingsNotifierProvider.notifier)
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
                                        .read(settingsNotifierProvider
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

                    const SizedBox(height: 16),

                    // Nota informativa cross-platform
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              color: Colors.blue.shade600, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Le impostazioni vengono salvate localmente e funzionano '
                              'su macOS e Windows. La stampa diretta richiede che la '
                              'stampante sia accessibile dalla rete o collegata via USB.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue.shade700,
                              ),
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
                    : Colors.grey.shade100,
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
              selected ? AppTheme.secondaryColor : Colors.grey.shade400,
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
            Colors.red.shade600,
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
    return Card(
      elevation: 0,
      color: Colors.grey.shade100,
      child: const Padding(
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