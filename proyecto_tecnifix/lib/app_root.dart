import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';
import 'features/auth/presentation/auth_gate.dart';
import 'features/auth/presentation/pages/reset_password_page.dart';
import 'core/splash/splash_screen_page.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late final AppLinks _appLinks;

  //cuando es true, SOLO se muestra ResetPasswordPage
  bool _showResetPassword = false;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();

    _handleInitialLink();
    _appLinks.uriLinkStream.listen(_handleUri);
  }

  Future<void> _handleInitialLink() async {
    final uri = await _appLinks.getInitialLink();
    if (uri != null) {
      _handleUri(uri);
    }
  }

  void _handleUri(Uri uri) {
    if (uri.scheme != 'com.example.proyecto_tecnifix') return;

    if (uri.host == 'reset-callback') {
      setState(() {
        _showResetPassword = true;
      });
    }
    if (uri.host == 'login-callback') {
      // AuthGate se encarga
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseClient>(create: (_) => Supabase.instance.client),
        ProxyProvider<SupabaseClient, AuthRepository>(
          update: (_, client, __) => AuthRepository(client),
        ),
        ChangeNotifierProxyProvider<AuthRepository, AuthController>(
          create: (context) => AuthController(context.read<AuthRepository>()),
          update: (_, repo, controller) => controller ?? AuthController(repo),
        ),
      ],
      child: Builder(
        builder: (_) {
          /// 🔥 PRIORIDAD ABSOLUTA
          if (_showResetPassword) {
            return const ResetPasswordPage();
          }

          /// flujo normal
          return const AuthGate();
        },
      ),
    );
  }
}
