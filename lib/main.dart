import 'package:flutter/material.dart';
import 'screens/item_list_screen.dart';

void main() {
  runApp(const ItemManagerApp());
}

class ItemManagerApp extends StatelessWidget {
  const ItemManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ItemListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
