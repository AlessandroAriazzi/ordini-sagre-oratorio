import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/menu_provider.dart';
import '../theme.dart';

class MenuEditorScreen extends ConsumerStatefulWidget {
  final int? menuId;

  const MenuEditorScreen({super.key, this.menuId});

  @override
  ConsumerState<MenuEditorScreen> createState() => _MenuEditorScreenState();
}

class _MenuEditorScreenState extends ConsumerState<MenuEditorScreen> {
  final _nomeMenuController = TextEditingController();
  final _nomeProdottoController = TextEditingController();
  final _prezzoProdottoController = TextEditingController();
  final _quantitaProdottoController = TextEditingController();
  String _categoriaSelezionata = 'Primo';

  final List<String> _categorie = ['Primo', 'Secondo', 'Contorno', 'Dolce', 'Bevanda'];

  @override
  void dispose() {
    _nomeMenuController.dispose();
    _nomeProdottoController.dispose();
    _prezzoProdottoController.dispose();
    _quantitaProdottoController.dispose();
    super.dispose();
  }

  Future<void> _showAddProdottoDialog(int menuId) async {
    _nomeProdottoController.clear();
    _prezzoProdottoController.clear();
    _quantitaProdottoController.text = '0';
    _categoriaSelezionata = 'Primo';

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          child: SizedBox(
            width: 480,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nuovo Prodotto',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Inserisci i dettagli del nuovo prodotto.',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nomeProdottoController,
                    decoration: const InputDecoration(
                      labelText: 'Nome prodotto',
                      prefixIcon: Icon(Icons.fastfood_rounded, size: 18),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _prezzoProdottoController,
                          decoration: const InputDecoration(
                            labelText: 'Prezzo',
                            prefixIcon: Icon(Icons.euro_rounded, size: 18),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _quantitaProdottoController,
                          decoration: const InputDecoration(
                            labelText: 'Quantità',
                            prefixIcon: Icon(Icons.inventory_2_rounded, size: 18),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _categoriaSelezionata,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      prefixIcon: Icon(Icons.category_rounded, size: 18),
                    ),
                    items: _categorie.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (value) => setDialogState(() => _categoriaSelezionata = value ?? 'Primo'),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annulla'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () {
                          if (_nomeProdottoController.text.isNotEmpty && _prezzoProdottoController.text.isNotEmpty) {
                            final prezzo = double.tryParse(_prezzoProdottoController.text) ?? 0.0;
                            final quantita = int.tryParse(_quantitaProdottoController.text) ?? 0;
                            ref.read(menusProvider.notifier).addProdotto(
                              menuId,
                              _nomeProdottoController.text,
                              prezzo,
                              _categoriaSelezionata,
                              quantita,
                            );
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Aggiungi'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showEditQuantitaDialog(int prodottoId, String nomeProdotto, int quantitaAttuale) async {
    final controller = TextEditingController(text: quantitaAttuale.toString());

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Modifica quantità',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  nomeProdotto,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Nuova quantità',
                    prefixIcon: Icon(Icons.format_list_numbered_rounded, size: 18),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autofocus: true,
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annulla'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () {
                        final nuovaQuantita = int.tryParse(controller.text) ?? 0;
                        ref.read(menusProvider.notifier).updateProdottoQuantita(prodottoId, nuovaQuantita);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('Salva'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
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

  Future<void> _showCreateMenuDialog() async {
    _nomeMenuController.clear();

    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(
          width: 440,
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nuovo Menù',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Inserisci il nome del nuovo menù.',
                  style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nomeMenuController,
                  decoration: const InputDecoration(
                    labelText: 'Nome menù',
                    prefixIcon: Icon(Icons.restaurant_menu_rounded, size: 18),
                  ),
                  autofocus: true,
                  onSubmitted: (_) {
                    if (_nomeMenuController.text.isNotEmpty) {
                      ref.read(menusProvider.notifier).addMenu(_nomeMenuController.text);
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annulla'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () {
                        if (_nomeMenuController.text.isNotEmpty) {
                          ref.read(menusProvider.notifier).addMenu(_nomeMenuController.text);
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('Crea Menù'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
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

  void _showDeleteMenuDialog(BuildContext context, dynamic menu) {
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
                  'Elimina menù',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vuoi eliminare "${menu.nome}"? Questa azione non può essere annullata.',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
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
                        ref.read(menusProvider.notifier).deleteMenu(menu.id!);
                        Navigator.pop(ctx);
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

  void _showDeleteProdottoDialog(BuildContext context, dynamic prodotto) {
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
                  'Elimina prodotto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vuoi eliminare "${prodotto.nome}"?',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
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
                        ref.read(menusProvider.notifier).deleteProdotto(prodotto.id!);
                        Navigator.pop(ctx);
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
    final menusAsync = ref.watch(menusProvider);

    return Scaffold(
      body: menusAsync.when(
        data: (menus) {
          // Edit view
          if (widget.menuId != null) {
            final menuList = menus.where((m) => m.id == widget.menuId).toList();
            final menu = menuList.isNotEmpty ? menuList.first : null;
            if (menu == null) {
              return const Center(child: Text('Menù non trovato'));
            }

            final prodottiPerCategoria = <String, List>{};
            for (final prodotto in menu.prodotti) {
              prodottiPerCategoria.putIfAbsent(prodotto.categoria, () => []).add(prodotto);
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
                        onTap: () => context.go('/menu/new'),
                        borderRadius: BorderRadius.circular(6),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chevron_left_rounded, size: 16, color: AppTheme.textSecondary),
                              SizedBox(width: 4),
                              Text('Menù', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Text('/', style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
                      ),
                      Text(
                        menu.nome,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () => _showAddProdottoDialog(menu.id!),
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Nuovo Prodotto'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

                // Products content
                Expanded(
                  child: menu.prodotti.isEmpty
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
                                child: const Icon(Icons.inventory_2_rounded, size: 36, color: AppTheme.textLight),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Nessun prodotto nel menù',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Aggiungi il primo prodotto per iniziare.',
                                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                              ),
                              const SizedBox(height: 20),
                              FilledButton.icon(
                                onPressed: () => _showAddProdottoDialog(menu.id!),
                                icon: const Icon(Icons.add_rounded, size: 16),
                                label: const Text('Nuovo Prodotto'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppTheme.secondaryColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _categorie.where((cat) => prodottiPerCategoria.containsKey(cat)).map((categoria) {
                              final prodotti = prodottiPerCategoria[categoria]!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          categoria.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.8,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '${prodotti.length}',
                                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.secondaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                                Expanded(flex: 3, child: Text('Nome', style: _headerStyle)),
                                                SizedBox(width: 120, child: Text('Prezzo', style: _headerStyle, textAlign: TextAlign.right)),
                                                SizedBox(width: 120, child: Text('Disponibili', style: _headerStyle, textAlign: TextAlign.center)),
                                                SizedBox(width: 100, child: Text('Stato', style: _headerStyle, textAlign: TextAlign.center)),
                                                SizedBox(width: 80),
                                              ],
                                            ),
                                          ),
                                          const Divider(height: 1, color: AppTheme.borderColor),
                                          ...prodotti.asMap().entries.map<Widget>((e) {
                                            final i = e.key;
                                            final prodotto = e.value;
                                            return Column(
                                              children: [
                                                if (i > 0) const Divider(height: 1, color: AppTheme.borderColor),
                                                _ProdottoRow(
                                                  prodotto: prodotto,
                                                  onEditQuantita: () => _showEditQuantitaDialog(prodotto.id!, prodotto.nome, prodotto.quantita),
                                                  onDelete: () => _showDeleteProdottoDialog(context, prodotto),
                                                ),
                                              ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ],
            );
          }

          // List view
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page header
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 28, 32, 20),
                child: Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Menù',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.textPrimary, letterSpacing: -0.3),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Gestisci i menù disponibili',
                          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _showCreateMenuDialog,
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('Nuovo Menù'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppTheme.borderColor),

              Expanded(
                child: menus.isEmpty
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
                              child: const Icon(Icons.restaurant_menu_rounded, size: 40, color: AppTheme.textLight),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Nessun menù',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Crea il primo menù per iniziare.',
                              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: _showCreateMenuDialog,
                              icon: const Icon(Icons.add_rounded, size: 16),
                              label: const Text('Nuovo Menù'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppTheme.secondaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(32),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.borderColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                              children: [
                                // Table header
                                Container(
                                  color: AppTheme.backgroundColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: const Row(
                                    children: [
                                      SizedBox(width: 40, child: Text('N°', style: _headerStyle)),
                                      SizedBox(width: 16),
                                      Expanded(flex: 3, child: Text('Nome', style: _headerStyle)),
                                      SizedBox(width: 160, child: Text('N° Prodotti', style: _headerStyle, textAlign: TextAlign.center)),
                                      SizedBox(width: 80),
                                    ],
                                  ),
                                ),
                                const Divider(height: 1, color: AppTheme.borderColor),
                                Expanded(
                                  child: ListView.separated(
                                    itemCount: menus.length,
                                    separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.borderColor),
                                    itemBuilder: (ctx, i) {
                                      final menu = menus[i];
                                      return _MenuRow(
                                        menu: menu,
                                        index: i + 1,
                                        onTap: () => context.go('/menu/${menu.id}'),
                                        onDelete: () => _showDeleteMenuDialog(context, menu),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ],
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

class _MenuRow extends StatefulWidget {
  final dynamic menu;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _MenuRow({
    required this.menu,
    required this.index,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_MenuRow> createState() => _MenuRowState();
}

class _MenuRowState extends State<_MenuRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          color: _hover ? AppTheme.backgroundColor : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  '${widget.index}',
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Text(
                  widget.menu.nome,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.textPrimary),
                ),
              ),
              SizedBox(
                width: 160,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: AppTheme.secondaryColor.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      '${widget.menu.prodotti.length} prodotti',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.secondaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      color: AppTheme.dangerColor,
                      tooltip: 'Elimina',
                      onPressed: widget.onDelete,
                      visualDensity: VisualDensity.compact,
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: AppTheme.textLight),
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

class _ProdottoRow extends StatefulWidget {
  final dynamic prodotto;
  final VoidCallback onEditQuantita;
  final VoidCallback onDelete;

  const _ProdottoRow({
    required this.prodotto,
    required this.onEditQuantita,
    required this.onDelete,
  });

  @override
  State<_ProdottoRow> createState() => _ProdottoRowState();
}

class _ProdottoRowState extends State<_ProdottoRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final isEsaurito = widget.prodotto.isEsaurito;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _hover ? AppTheme.backgroundColor : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                widget.prodotto.nome,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isEsaurito ? AppTheme.textLight : AppTheme.textPrimary,
                  decoration: isEsaurito ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: Text(
                '€${widget.prodotto.prezzo.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(
              width: 120,
              child: Text(
                isEsaurito ? '—' : '${widget.prodotto.quantita}',
                style: TextStyle(
                  fontSize: 13,
                  color: widget.prodotto.quantita < 10 && !isEsaurito ? AppTheme.warningColor : AppTheme.textSecondary,
                  fontWeight: widget.prodotto.quantita < 10 && !isEsaurito ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 100,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: isEsaurito ? AppTheme.dangerColor.withValues(alpha: 0.08) : AppTheme.successColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isEsaurito ? AppTheme.dangerColor.withValues(alpha: 0.2) : AppTheme.successColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    isEsaurito ? 'Esaurito' : 'Disponibile',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isEsaurito ? AppTheme.dangerColor : AppTheme.successColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    color: AppTheme.textSecondary,
                    tooltip: 'Modifica quantità',
                    onPressed: widget.onEditQuantita,
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 16),
                    color: AppTheme.dangerColor,
                    tooltip: 'Elimina',
                    onPressed: widget.onDelete,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
