import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  final VoidCallback onBack;

  const ForgotPasswordPage({super.key, required this.onBack});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _recuperarPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = context.read<AuthController>();

    try {
      await authController.recoverPassword(emailController.text.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Revisa tu correo para restablecer la contraseña'),
        ),
      );

      /// 👈 NO Navigator.pop
      widget.onBack();
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
        title: const Text('Recuperar contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ingresa tu email para enviarte el enlace de recuperación de contraseña.',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 24),

              /// EMAIL
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Email obligatorio' : null,
              ),

              const SizedBox(height: 32),

              /// ERROR
              if (authController.error != null)
                Text(
                  authController.error!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 12),

              /// BUTTON
              ElevatedButton(
                onPressed: authController.isLoading ? null : _recuperarPassword,
                child: authController.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Recuperar contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
