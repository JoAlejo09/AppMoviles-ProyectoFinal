import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import '../../perfil/presentation/controllers/perfil_controller.dart';

import 'pages/welcome_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/email_verification_page.dart';

/// Estados posibles del flujo de autenticación
enum AuthView { welcome, login, register, forgotPassword }

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  AuthView _view = AuthView.welcome;

  /// Bandera para evitar cargar el perfil múltiples veces
  bool _perfilCargado = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    // Mostrar mensajes one-time del AuthController
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auth.oneTimeMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(auth.oneTimeMessage!)));
        auth.clearOneTimeMessage();
      }
    });

    // 🚪 USUARIO NO LOGUEADO
    if (!auth.isLoggedIn) {
      _perfilCargado = false; // reset por si vuelve a login

      switch (_view) {
        case AuthView.login:
          return LoginPage(
            onBack: () => setState(() => _view = AuthView.welcome),
            onForgotPassword: () =>
                setState(() => _view = AuthView.forgotPassword),
          );

        case AuthView.register:
          return RegisterPage(
            onBack: () => setState(() => _view = AuthView.welcome),
          );

        case AuthView.forgotPassword:
          return ForgotPasswordPage(
            onBack: () => setState(() => _view = AuthView.login),
          );

        case AuthView.welcome:
        default:
          return WelcomePage(
            onLogin: () => setState(() => _view = AuthView.login),
            onRegister: () => setState(() => _view = AuthView.register),
          );
      }
    }

    // 📧 USUARIO LOGUEADO PERO EMAIL NO VERIFICADO
    if (!auth.isEmailConfirmed) {
      return const EmailVerificationPage();
    }

    // 👤 USUARIO LOGUEADO + EMAIL VERIFICADO → CARGAR PERFIL
    final perfilController = context.watch<PerfilController>();

    if (!_perfilCargado) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        perfilController.cargarPerfil(auth.userId!);
      });
      _perfilCargado = true;
    }

    // ⏳ ESPERANDO PERFIL
    if (perfilController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ❌ ERROR AL CARGAR PERFIL (estado crítico)
    if (perfilController.error != null) {
      return Scaffold(
        body: Center(
          child: Text(
            perfilController.error!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // 🏠 HOME TEMPORAL (Funcionalidad 2 se agrega después)
    return const Scaffold(
      body: Center(child: Text('HOME', style: TextStyle(fontSize: 20))),
    );
  }
}
