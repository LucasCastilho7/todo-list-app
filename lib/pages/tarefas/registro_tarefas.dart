import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_list_app/pages/tarefas/ver_tarefas.dart';
import 'package:todo_list_app/repository/tarefa_repository.dart';
import 'package:todo_list_app/model/tarefa.dart';

class NewTaskScreen extends StatefulWidget {
  final Tarefa? tarefa;

  const NewTaskScreen({super.key, this.tarefa});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TarefaRepository _repository = TarefaRepository();

  late String taskName;
  late String taskDescription;

  @override
  void initState() {
    super.initState();

    taskName = widget.tarefa?.nome ?? "";
    taskDescription = widget.tarefa?.descricao ?? "";
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final tarefa = Tarefa(nome: taskName, descricao: taskDescription);

      if (widget.tarefa == null) {
        await _repository.addTarefa(tarefa);
      } else {
        final id = widget.tarefa!.id!;
        await _repository.updateTarefa(id, tarefa);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewTasksScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarefa == null ? "Nova Tarefa" : "Editar Tarefa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: taskName,
                decoration: const InputDecoration(labelText: "Nome da Tarefa"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "O nome da tarefa é obrigatório.";
                  }
                  return null;
                },
                onSaved: (value) {
                  taskName = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: taskDescription,
                decoration: const InputDecoration(labelText: "Descrição"),
                onSaved: (value) {
                  taskDescription = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text(widget.tarefa == null ? "Salvar Tarefa" : "Editar Tarefa"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
