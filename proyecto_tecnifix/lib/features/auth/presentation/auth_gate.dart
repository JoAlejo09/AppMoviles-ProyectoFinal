import 'package:flutter/material.dart';
import '../auth_controller.dart';
import '../presentation/welcome_page.dart';

class AuthGate extends StatelessWidget {
  final AuthController controller;

  final Widget login;
  final Widget emailVerificacion;
  final Widget home;

  const AuthGate({
    super.key,
    required this.controller,
    required this.login,
    required this.emailVerificacion,
    required this.home,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Escucha cambios de autenticación
      stream: controller.authChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Si NO hay sesión envia a Login
        if (!controller.isLoggedIn) {
          return WelcomePage(controller: controller);
        }

        // Si hay sesión pero NO confirmó email
        if (!controller.isEmailConfirmed) {
          return emailVerificacion;
        }

        // Si todo está correcto envia a Home
        return home;
      },
    );
  }
}
