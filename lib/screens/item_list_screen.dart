import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/item_service.dart';
import 'item_form_screen.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  late Future<List<Item>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    setState(() {
      _itemsFuture = ItemService.fetchItems();
    });
  }

  void _deleteItem(int id) async {
    await ItemService.deleteItem(id);
    _refreshItems();
  }

  void _toggleComprado(Item item) async {
    await ItemService.updateItem(
      Item(
        id: item.id,
        nome: item.nome,
        quantidade: item.quantidade,
        comprado: !item.comprado,
      ),
    );
    _refreshItems();
  }

  void _openForm({Item? item}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemFormScreen(item: item),
      ),
    );
    if (result == true) {
      _refreshItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Itens')),
      body: FutureBuilder<List<Item>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum item encontrado.'));
          }
          final items = snapshot.data!;
          return ReorderableListView.builder(
            itemCount: items.length,
            onReorder: (oldIndex, newIndex) async {
              if (newIndex > oldIndex) newIndex--;
              final item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
              setState(() {
                _itemsFuture = Future.value(List<Item>.from(items));
              });
              try {
                await ItemService.reorderItems(items.map((e) => e.id!).toList());
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao salvar ordem: $e')),
                );
              }
            },
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                key: ValueKey(item.id),
                child: ListTile(
                  title: Text(item.nome),
                  subtitle: Text('Quantidade: ${item.quantidade}'),
                  leading: IconButton(
                    icon: Icon(
                      item.comprado ? Icons.check_box : Icons.check_box_outline_blank,
                      color: item.comprado ? Colors.green : null,
                    ),
                    onPressed: () => _toggleComprado(item),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openForm(item: item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteItem(item.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
