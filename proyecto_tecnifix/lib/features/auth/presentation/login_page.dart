import 'package:flutter/material.dart';
import '../auth_controller.dart';

class LoginPage extends StatelessWidget {
  //Controlador
  final AuthController controller;

  //Formulario
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginPage({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio de Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: (Column(
          children: [
            //email
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            //contraseña
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 16),
            // Botón login
            ElevatedButton(
              onPressed: () async {
                await controller.login(
                  emailController.text,
                  passwordController.text,
                );
              },
              child: const Text('Ingresar'),
            ),

            // Botón Google
            ElevatedButton(
              onPressed: controller.loginWithGoogle,
              child: const Text('Ingresar con Google'),
            ),
          ],
        )),
      ),
    );
  }
}
