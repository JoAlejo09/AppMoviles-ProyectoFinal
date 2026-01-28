import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onForgotPassword;

  const LoginPage({
    super.key,
    required this.onBack,
    required this.onForgotPassword,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = context.read<AuthController>();

    try {
      await authController.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } catch (_) {}
  }

  Future<void> _loginGoogle() async {
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
        title: const Text('Inicio de sesión'),
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
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty
                    ? 'El email es obligatorio'
                    : null,
              ),

              const SizedBox(height: 12),

              /// PASSWORD
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingrese la contraseña'
                    : null,
              ),

              const SizedBox(height: 16),

              /// ERROR
              if (authController.error != null)
                Text(
                  authController.error!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 8),

              /// FORGOT PASSWORD
              TextButton(
                onPressed: widget.onForgotPassword,
                child: const Text('¿Olvidaste tu contraseña?'),
              ),

              const SizedBox(height: 16),

              /// LOGIN
              ElevatedButton.icon(
                onPressed: authController.isLoading ? null : _login,
                icon: const Icon(Icons.login),
                label: authController.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Iniciar sesión'),
              ),

              const SizedBox(height: 8),

              /// GOOGLE
              ElevatedButton.icon(
                onPressed: authController.isLoading ? null : _loginGoogle,
                icon: const Icon(
                  Icons.g_mobiledata,
                  color: Colors.red,
                  size: 28,
                ),
                label: authController.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Ingresar con Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
