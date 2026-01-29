import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tecnifix/features/auth/presentation/pages/login_page.dart';
import 'package:proyecto_tecnifix/features/perfil/presentation/perfil_gate.dart';

import 'presentation/controllers/auth_controller.dart';
//import 'presentation/pages/welcome_page.dart';
import '../perfil/presentation/perfil_gate.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    // 1️⃣ Cargando auth
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 2️⃣ No autenticado
    if (!auth.isAuthenticated) {
      return const LoginPage();
    }

    // 3️⃣ Autenticado → decidir perfil
    return const PerfilGate();
  }
}
