import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tecnifix/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:proyecto_tecnifix/features/auth/presentation/pages/register_page.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Image.asset('assets/images/logo.png', height: 120),

            const SizedBox(height: 20),

            // EMAIL
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),

            const SizedBox(height: 12),

            // PASSWORD
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),

            const SizedBox(height: 20),

            // ERROR
            if (auth.error != null)
              Text(auth.error!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 12),

            // BOTÓN LOGIN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: auth.isLoading
                    ? null
                    : () {
                        auth.login(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      },
                child: auth.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Entrar'),
              ),
            ),

            const SizedBox(height: 12),

            // BOTÓN GOOGLE
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: auth.isLoading
                    ? null
                    : () {
                        auth.signInWithGoogle();
                      },
                child: const Text('Continuar con Google'),
              ),
            ),

            const SizedBox(height: 20),

            // LINKS
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text('Crear cuenta'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                );
              },
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ],
        ),
      ),
    );
  }
}
