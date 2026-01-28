import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  Future<void> _resendEmail(
    BuildContext context,
    AuthController authController,
  ) async {
    try {
      final email = authController.userEmail;

      if (email == null) {
        throw Exception('No se pudo obtener el email del usuario');
      }

      await authController.resendEmail(email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Te enviamos nuevamente el correo de verificación'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verifica tu correo'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.mark_email_unread_outlined, size: 80),

              const SizedBox(height: 24),

              const Text(
                'Revisa tu correo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 16),

              Text(
                'Hemos enviado un enlace de verificación a:\n\n'
                '${authController.userEmail ?? ''}',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: authController.isLoading
                    ? null
                    : () => _resendEmail(context, authController),
                icon: const Icon(Icons.refresh),
                label: authController.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Reenviar correo'),
              ),

              const SizedBox(height: 16),

              const Text(
                'Una vez que confirmes tu correo, '
                'regresa a la app y continuaremos automáticamente.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
