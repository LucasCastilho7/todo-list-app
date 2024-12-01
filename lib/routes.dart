import 'package:flutter/cupertino.dart';
import 'package:todo_list_app/pages/home_page.dart';
import 'package:todo_list_app/pages/login.dart';
import 'package:todo_list_app/pages/register.dart';
import 'package:todo_list_app/pages/tarefas/registro_tarefas.dart';
import 'package:todo_list_app/pages/tarefas/ver_tarefas.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder>{
    '/login': (_) => const LoginPage(),
    '/register': (_) => const RegisterPage(),
    '/home-page': (_) => HomePage(),
    '/tasks': (_) => const ViewTasksScreen(),
    '/form-tasks': (_) => const NewTaskScreen(),
  };

  static String initial = '/login';

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
