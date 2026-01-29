import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:proyecto_tecnifix/features/auth/auth_gate.dart';
import 'package:proyecto_tecnifix/features/auth/presentation/pages/reset_password_page.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();

    _appLinks = AppLinks();

    _appLinks.uriLinkStream.listen((uri) async {
      if (uri == null || uri.scheme != 'myapp') return;

      final type = uri.queryParameters['type'];

      // 🔐 Reset de contraseña
      if (type == 'recovery') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
        );
        return;
      }

      // 🔥 LOGIN / SIGNUP (email o Google)
      if (type == 'signup' || type == 'login') {
        // Fuerza a Supabase a sincronizar la sesión
        await Supabase.instance.client.auth.refreshSession();
        // AuthController reaccionará vía onAuthStateChange
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AuthGate();
  }
}
