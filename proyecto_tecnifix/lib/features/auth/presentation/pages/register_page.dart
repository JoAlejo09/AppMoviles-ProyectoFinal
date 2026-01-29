import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? localError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar contraseña',
              ),
            ),
            const SizedBox(height: 16),

            if (localError != null)
              Text(localError!, style: const TextStyle(color: Colors.red)),

            if (auth.error != null)
              Text(auth.error!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: auth.isLoading
                    ? null
                    : () async {
                        if (_passwordController.text !=
                            _confirmController.text) {
                          setState(() {
                            localError = 'Las contraseñas no coinciden';
                          });
                          return;
                        }

                        localError = null;

                        await auth.register(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      },
                child: auth.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Registrarme'),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Te enviaremos un correo para verificar tu cuenta.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
