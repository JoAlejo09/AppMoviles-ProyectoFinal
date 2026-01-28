import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onBack;

  const RegisterPage({super.key, required this.onBack});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = context.read<AuthController>();

    try {
      await authController.register(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      // ❗ NO navegación
      // AuthGate reaccionará (EmailVerificationPage)
    } catch (_) {}
  }

  Future<void> _registrarConGoogle() async {
    final authController = context.read<AuthController>();

    try {
      await authController.loginWithGoogle();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        title: const Text('Crear nuevo usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// EMAIL
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Email obligatorio' : null,
              ),

              const SizedBox(height: 12),

              /// PASSWORD
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (value) => value == null || value.length < 6
                    ? 'La contraseña debe tener al menos 6 caracteres'
                    : null,
              ),

              const SizedBox(height: 16),

              /// ERROR
              if (authController.error != null)
                Text(
                  authController.error!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 20),

              /// REGISTER BUTTON
              ElevatedButton(
                onPressed: authController.isLoading ? null : _registrar,
                child: authController.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Registrarse'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: authController.isLoading
                    ? null
                    : _registrarConGoogle,
                icon: const Icon(
                  Icons.g_mobiledata,
                  color: Colors.red,
                  size: 28,
                ),
                label: authController.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Registrarse con Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
