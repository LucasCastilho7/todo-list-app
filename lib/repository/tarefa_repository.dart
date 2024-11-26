import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/database/db.dart';
import '../model/tarefa.dart';

class TarefaRepository {
  late Database db;
  List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => _tarefas;

  TarefaRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getTarefas();
  }

  Future<void> _getTarefas() async {
    db = await DB.instance.database;

    final List<Map<String, dynamic>> result = await db.query('tarefa');

    _tarefas = result.map((map) => Tarefa.fromMap(map)).toList();
  }

  Future<void> addTarefa(Tarefa tarefa) async {
    db = await DB.instance.database;

    final int id = await db.insert('tarefa', {
      'nome': tarefa.nome,
      'descricao': tarefa.descricao,
    });

    tarefa.id = id;

    _tarefas.add(tarefa);
  }

  Future<void> updateTarefa(int id, Tarefa tarefa) async {
    db = await DB.instance.database;

    final updateData = {
      'nome': tarefa.nome,
      'descricao': tarefa.descricao,
    };

    await db.update(
      'tarefa',
      updateData,
      where: 'id = ?',
      whereArgs: [id],
    );

    final index = _tarefas.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tarefas[index] = tarefa;
    }
  }

  Future<void> deleteTarefa(int id) async {
    db = await DB.instance.database;

    await db.delete(
      'tarefa',
      where: 'id = ?',
      whereArgs: [id],
    );

    _tarefas.removeWhere((t) => t.nome == id.toString());
  }

  Future<List<Tarefa>> fetchTarefas() async {
    await _getTarefas();
    return _tarefas;
  }
}
