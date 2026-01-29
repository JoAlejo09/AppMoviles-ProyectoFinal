import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifica tu correo'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_unread_outlined, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Te enviamos un correo de verificación.\n'
              'Revisa tu bandeja de entrada y confirma tu cuenta.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Reenviar correo
            ElevatedButton(
              onPressed: () async {
                await auth.resendVerificationEmail();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Correo reenviado')),
                );
              },
              child: const Text('Reenviar correo'),
            ),

            const SizedBox(height: 12),

            // Cerrar sesión
            TextButton(
              onPressed: () async {
                await auth.logout();
              },
              child: const Text('Cerrar sesión'),
            ),

            const SizedBox(height: 20),

            const Text(
              'Una vez confirmes el correo, vuelve a abrir la app.',
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
