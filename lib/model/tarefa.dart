class Tarefa {
  int? id;
  String nome;
  String? descricao;

  Tarefa({this.id, required this.nome, this.descricao});

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
    );
  }

  @override
  String toString() {
    return 'Tarefa{id: $id, nome: $nome, descricao: $descricao}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }
}
