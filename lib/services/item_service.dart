import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ItemService {
  // Altere para o endpoint correto da sua API
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<List<Item>> fetchItems() async {
    final response = await http.get(Uri.parse('$baseUrl/items'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Item.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar itens');
    }
  }

  static Future<Item> addItem(Item item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/items'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao adicionar item');
    }
  }

  static Future<Item> updateItem(Item item) async {
    if (item.id == null) throw Exception('Item sem ID');
    final response = await http.put(
      Uri.parse('$baseUrl/items/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erro ao atualizar item');
    }
  }

  static Future<void> deleteItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/items/$id'));
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Erro ao remover item');
    }
  }

  static Future<void> reorderItems(List<int> ids) async {
    final response = await http.put(
      Uri.parse('$baseUrl/items/reorder'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ids),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao reordenar itens');
    }
  }
}
