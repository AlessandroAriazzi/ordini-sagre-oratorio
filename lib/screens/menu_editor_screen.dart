import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/menu_provider.dart';

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
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.add_shopping_cart, color: Colors.blue.shade700, size: 28),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Nuovo Prodotto',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nomeProdottoController,
                  decoration: InputDecoration(
                    labelText: 'Nome prodotto',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.fastfood),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _prezzoProdottoController,
                        decoration: InputDecoration(
                          labelText: 'Prezzo',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.euro),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _quantitaProdottoController,
                        decoration: InputDecoration(
                          labelText: 'Quantità',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.inventory),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _categoriaSelezionata,
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items: _categorie.map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  )).toList(),
                  onChanged: (value) {
                    setState(() => _categoriaSelezionata = value ?? 'Primo');
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annulla'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_nomeProdottoController.text.isNotEmpty &&
                            _prezzoProdottoController.text.isNotEmpty) {
                          final prezzo = double.tryParse(_prezzoProdottoController.text) ?? 0.0;
                          final quantita = int.tryParse(_quantitaProdottoController.text) ?? 0;
                          ref.read(menusNotifierProvider.notifier).addProdotto(
                            menuId,
                            _nomeProdottoController.text,
                            prezzo,
                            _categoriaSelezionata,
                            quantita,
                          );
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Aggiungi'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Future<void> _showEditQuantitaDialog(int prodottoId, String nomeProdotto, int quantitaAttuale) async {
    final controller = TextEditingController(text: quantitaAttuale.toString());
    
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.inventory_2, color: Colors.orange.shade700, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Modifica Quantità',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          nomeProdotto,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Nuova quantità',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.format_list_numbered),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annulla'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      final nuovaQuantita = int.tryParse(controller.text) ?? 0;
                      ref.read(menusNotifierProvider.notifier).updateProdottoQuantita(
                        prodottoId,
                        nuovaQuantita,
                      );
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Salva'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.restaurant_menu, color: Colors.green.shade700, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Nuovo Menù',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nomeMenuController,
                decoration: InputDecoration(
                  labelText: 'Nome menù',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.title),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annulla'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_nomeMenuController.text.isNotEmpty) {
                        ref.read(menusNotifierProvider.notifier).addMenu(_nomeMenuController.text);
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Crea'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menusAsync = ref.watch(menusNotifierProvider);

    return Scaffold(
      appBar: widget.menuId != null ? AppBar(
        title: const Text('Modifica Menù'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/menu/new'),
        ),
      ) : null,
      body: menusAsync.when(
        data: (menus) {
          if (widget.menuId != null) {
            final menuList = menus.where((m) => m.id == widget.menuId).toList();
            final menu = menuList.isNotEmpty ? menuList.first : null;
            if (menu == null) {
              return const Center(child: Text('Menù non trovato'));
            }

            // Raggruppa prodotti per categoria
            final prodottiPerCategoria = <String, List>{};
            for (final prodotto in menu.prodotti) {
              prodottiPerCategoria.putIfAbsent(prodotto.categoria, () => []).add(prodotto);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.restaurant_menu, size: 40, color: Colors.blue.shade700),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu.nome,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${menu.prodotti.length} prodotti',
                                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showAddProdottoDialog(menu.id!),
                            icon: const Icon(Icons.add),
                            label: const Text('Nuovo Prodotto'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (menu.prodotti.isEmpty)
                    Card(
                      elevation: 0,
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: const Padding(
                        padding: EdgeInsets.all(48),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.inventory_2, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Nessun prodotto nel menù',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Aggiungi il primo prodotto per iniziare',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ..._categorie.where((cat) => prodottiPerCategoria.containsKey(cat)).map((categoria) {
                      final prodotti = prodottiPerCategoria[categoria]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Icon(_getCategoriaIcon(categoria), color: Colors.blue.shade700),
                                const SizedBox(width: 12),
                                Text(
                                  categoria,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${prodotti.length} prodotti',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...prodotti.map((prodotto) => Card(
                            elevation: 1,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: prodotto.isEsaurito ? Colors.red.shade50 : Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  prodotto.isEsaurito ? Icons.remove_shopping_cart : Icons.shopping_cart,
                                  color: prodotto.isEsaurito ? Colors.red.shade700 : Colors.green.shade700,
                                ),
                              ),
                              title: Text(
                                prodotto.nome,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    '€ ${prodotto.prezzo.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: prodotto.isEsaurito ? Colors.red.shade50 : Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      prodotto.isEsaurito 
                                        ? 'ESAURITO' 
                                        : 'Disponibili: ${prodotto.quantita}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: prodotto.isEsaurito ? Colors.red.shade700 : Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    tooltip: 'Modifica quantità',
                                    onPressed: () => _showEditQuantitaDialog(
                                      prodotto.id!,
                                      prodotto.nome,
                                      prodotto.quantita,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    tooltip: 'Elimina',
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          title: const Text('Conferma eliminazione'),
                                          content: Text('Vuoi eliminare "${prodotto.nome}"?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Annulla'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                ref.read(menusNotifierProvider.notifier).deleteProdotto(prodotto.id!);
                                                Navigator.pop(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text('Elimina'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )),
                          const SizedBox(height: 24),
                        ],
                      );
                    }),
                ],
              ),
            );
          }

          // Vista lista menù
          if (menus.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 24),
                  const Text(
                    'Nessun menù presente',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Crea il primo menù per iniziare',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _showCreateMenuDialog,
                    icon: const Icon(Icons.add, size: 28),
                    label: const Text('Crea primo menù', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: menus.length,
            itemBuilder: (context, index) {
              final menu = menus[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(20),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.restaurant_menu, color: Colors.blue.shade700, size: 32),
                  ),
                  title: Text(
                    menu.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${menu.prodotti.length} prodotti',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: 'Elimina menù',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: const Text('Conferma eliminazione'),
                              content: Text('Vuoi eliminare il menù "${menu.nome}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Annulla'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    ref.read(menusNotifierProvider.notifier).deleteMenu(menu.id!);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Elimina'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => context.go('/menu/${menu.id}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Errore: $error')),
      ),
      floatingActionButton: widget.menuId == null
          ? FloatingActionButton.extended(
              onPressed: _showCreateMenuDialog,
              icon: const Icon(Icons.add),
              label: const Text('Nuovo Menù'),
            )
          : null,
    );
  }

  IconData _getCategoriaIcon(String categoria) {
    switch (categoria) {
      case 'Primo':
        return Icons.ramen_dining;
      case 'Secondo':
        return Icons.set_meal;
      case 'Contorno':
        return Icons.lunch_dining;
      case 'Dolce':
        return Icons.cake;
      case 'Bevanda':
        return Icons.local_drink;
      default:
        return Icons.fastfood;
    }
  }
}