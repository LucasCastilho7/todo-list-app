import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_app/auth.dart';
import 'package:todo_list_app/pages/tarefas/registro_tarefas.dart';
import 'package:todo_list_app/pages/tarefas/ver_tarefas.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text(
      'Bem-vindo ao Todo List!',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton.icon(
      onPressed: signOut,
      icon: const Icon(Icons.logout),
      label: const Text('Sair'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _newTaskButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewTaskScreen()),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Nova Tarefa'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white70,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _viewTasks(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ViewTasksScreen()),
        );
      },
      icon: const Icon(Icons.remove_red_eye),
      label: const Text('Ver tarefas'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white70,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _newTaskButton(context),
            const SizedBox(height: 20),
            _viewTasks(context),
            const SizedBox(height: 20),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}

