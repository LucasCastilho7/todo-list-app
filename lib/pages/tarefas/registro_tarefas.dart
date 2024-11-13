import 'package:flutter/material.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formkey = GlobalKey<FormState>();
  String taskName = "";
  String taskDescription = "";
  String recurrence = 'Diariamente';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nova Tarefa")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Nome da Tarefa"),
                onChanged: (value) {
                  setState(() {
                    taskName = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Descrição"),
                onChanged: (value) {
                  setState(() {
                    taskDescription = value;
                  });
                },
              ),
              DropdownButtonFormField(
                value: recurrence,
                decoration: const InputDecoration(labelText: "Recorrência"),
                items: ['Diariamente', 'Semanalmente', 'Mensalmente'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    recurrence = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // WIP: Save task to Firebase
                },
                child: const Text("Salvar Tarefa"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
