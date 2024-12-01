import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list_app/pages/home_page.dart';
import 'package:todo_list_app/pages/login.dart';
import '../auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _entryField(String title, TextEditingController controller, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Ops! ${errorMessage ?? ''}');
  }

  Widget _registerButton() {
    return FilledButton(
      onPressed: createUserWithEmailAndPassword,
      child: const Text('Registre-se'),
    );
  }

  Widget _registerText() {
    return const Text(
      'Registre-se',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _welcomeRegisterText() {
    return const Text(
      "Crie sua conta. É de graça!",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20.0),
    );
  }

  Widget _expandedContainer() {
    return Expanded(child: Container());
  }

  Widget _alreadyHaveAccountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Já possui uma conta?",
        ),
        TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text('Entre agora!'))
      ],
    );
  }

  Widget _space() {
    return const SizedBox(height: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registre-se',
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _registerText(),
            _welcomeRegisterText(),
            _expandedContainer(),
            _entryField('E-mail', _controllerEmail, false),
            _space(),
            _entryField('Senha', _controllerPassword, true),
            _errorMessage(),
            _registerButton(),
            _expandedContainer(),
            _alreadyHaveAccountRow()
          ],
        ),
      ),
    );
  }
}
