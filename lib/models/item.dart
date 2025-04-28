class Item {
  final int? id;
  final String nome;
  final int quantidade;
  final bool comprado;

  Item({this.id, required this.nome, required this.quantidade, this.comprado = false});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      nome: json['nome'],
      quantidade: json['quantidade'],
      comprado: json['comprado'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'quantidade': quantidade,
      'comprado': comprado,
    };
  }
}
