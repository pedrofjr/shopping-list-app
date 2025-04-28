import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/item_service.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;
  const ItemFormScreen({super.key, this.item});

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _quantidadeController;
  bool _comprado = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.item?.nome ?? '');
    _quantidadeController = TextEditingController(text: widget.item?.quantidade.toString() ?? '');
    _comprado = widget.item?.comprado ?? false;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final item = Item(
        id: widget.item?.id,
        nome: _nomeController.text,
        quantidade: int.parse(_quantidadeController.text),
        comprado: _comprado,
      );
      if (widget.item == null) {
        await ItemService.addItem(item);
      } else {
        await ItemService.updateItem(item);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar item: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Novo Item' : 'Editar Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantidadeController,
                      decoration: const InputDecoration(labelText: 'Quantidade'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Informe a quantidade';
                        if (int.tryParse(value) == null) return 'Informe um número válido';
                        if (int.parse(value) < 0) return 'Quantidade não pode ser negativa';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () async {
                      int value = int.tryParse(_quantidadeController.text) ?? 0;
                      if (value > 0) {
                        setState(() {
                          _quantidadeController.text = (value - 1).toString();
                        });
                        if (value - 1 == 0) {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Quantidade zerada'),
                              content: const Text('Deseja apagar este item?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Não'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Sim'),
                                ),
                              ],
                            ),
                          );
                          if (shouldDelete == true && widget.item?.id != null) {
                            setState(() => _isSaving = true);
                            try {
                              await ItemService.deleteItem(widget.item!.id!);
                              if (mounted) Navigator.pop(context, true);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao apagar item: $e')),
                              );
                            } finally {
                              setState(() => _isSaving = false);
                            }
                          }
                        }
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      int value = int.tryParse(_quantidadeController.text) ?? 0;
                      setState(() {
                        _quantidadeController.text = (value + 1).toString();
                      });
                    },
                  ),
                ],
              ),
              CheckboxListTile(
                title: const Text('Comprado'),
                value: _comprado,
                onChanged: (val) {
                  setState(() => _comprado = val ?? false);
                },
              ),
              const SizedBox(height: 20),
              _isSaving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveItem,
                      child: Text(widget.item == null ? 'Adicionar' : 'Salvar'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
