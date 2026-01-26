import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:proyecto_tecnifix/features/auth/auth_controller.dart';
import 'package:proyecto_tecnifix/features/auth/data/auth_repository.dart';
import 'package:proyecto_tecnifix/features/auth/presentation/auth_gate.dart';
import 'package:proyecto_tecnifix/features/auth/presentation/login_page.dart';
import 'package:proyecto_tecnifix/features/auth/presentation/email_verification_page.dart';
import 'package:proyecto_tecnifix/features/auth/presentation/splash/splash_screen_page.dart';
//import 'package:proyecto_tecnifix/features/profile/presentation/profile_page.dart';

import 'core/config/app_theme.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // ✅ Se crea UNA sola instancia del controller
  final AuthController authController = AuthController(
    AuthRepository(Supabase.instance.client),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      home: FutureBuilder(
        // ⏳ Delay visual del splash
        future: Future.delayed(const Duration(seconds: 2)),
        builder: (context, snapshot) {
          // 🟡 Mientras carga → Splash
          if (snapshot.connectionState != ConnectionState.done) {
            return const SplashPage();
          }

          // 🟢 Luego → AuthGate decide
          return AuthGate(
            controller: authController,
            login: LoginPage(controller: authController),
            emailVerificacion: EmailVerificationPage(
              controller: authController,
              email: authController.currentUser?.email ?? '',
            ),
            home: const Scaffold(body: Text('data')), //const PerfilPage(),
          );
        },
      ),
    );
  }
}
