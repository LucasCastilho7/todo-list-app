import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/model/custom_notification.dart';
import 'package:todo_list_app/repository/tarefa_repository.dart';
import 'package:todo_list_app/model/tarefa.dart';
import 'package:todo_list_app/pages/tarefas/registro_tarefas.dart';
import 'package:todo_list_app/service/notification_service.dart';

class ViewTasksScreen extends StatefulWidget {
  const ViewTasksScreen({super.key});

  @override
  State<ViewTasksScreen> createState() => _ViewTasksScreenState();
}

class _ViewTasksScreenState extends State<ViewTasksScreen> with RouteAware {
  final NotificationService notificationService = NotificationService();
  final TarefaRepository _repository = TarefaRepository();
  List<Tarefa> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
    checkForNotifications();
  }

  checkForNotifications() async {
    await Provider.of<NotificationService>(context, listen: false).checkForNotifications();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tarefas = await _repository.fetchTarefas();
    setState(() {
      _tarefas = tarefas;
    });
  }

  Future<void> _deleteTask(int id) async {
    await _repository.deleteTarefa(id);
    await _loadTasks();
  }

  showNotification() {
    notificationService.showNotification(
      CustomNotification(
          id: 1, title: 'Você tem tarefas pendentes!', body: 'Clique para visualizar suas tarefas.', payload: '/tasks'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tarefas"),
        actions: [
          const IconButton(
            icon: Icon(Icons.notification_add),
            onPressed: null,
            tooltip: 'Em breve!',
          ),
        ],
      ),
      body: _tarefas.isEmpty
          ? const Center(child: Text("Nenhuma tarefa encontrada"))
          : ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(tarefa.nome),
                    subtitle: Text(tarefa.descricao ?? "Sem descrição"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewTaskScreen(
                                  tarefa: tarefa,
                                ),
                              ),
                            ).then((_) => _loadTasks());
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, tarefa.id!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Excluir Tarefa"),
          content: const Text("Tem certeza de que deseja excluir esta tarefa?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTask(id);
              },
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    );
  }
}
