import 'package:flutter/material.dart';
import '../auth_controller.dart';

// Pantalla de verificación de correo
class EmailVerificationPage extends StatelessWidget {
  final AuthController controller;
  final String email;

  const EmailVerificationPage({
    super.key,
    required this.controller,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mensaje informativo
            const Text(
              'Revisa tu correo y confirma tu cuenta',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Botón reenviar correo
            ElevatedButton(
              onPressed: () {
                controller.resendEmail(email);
              },
              child: const Text('Reenviar correo'),
            ),
          ],
        ),
      ),
    );
  }
}
