import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tecnifix/features/chat/controller/chat_controller.dart';
import 'package:proyecto_tecnifix/features/chat/data/chat_repository.dart';
import 'package:proyecto_tecnifix/features/solicitudes/controller/solicitudes_controller.dart';
import 'package:proyecto_tecnifix/features/solicitudes/data/solicitudes_repository.dart';
import 'package:proyecto_tecnifix/features/tecnico/controller/tecnico_controller.dart';
import 'package:proyecto_tecnifix/features/tecnico/data/tecnico_repository.dart';

import 'app.dart';
import 'core/services/supabase_service.dart';

// AUTH
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';

// PERFIL
import 'features/perfil/data/perfil_repository.dart';
import 'features/perfil/controller/perfil_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        // AUTH
        ChangeNotifierProvider(
          create: (_) => AuthController(AuthRepository(SupabaseService.client)),
        ),

        // PERFIL
        Provider(create: (_) => PerfilRepository(SupabaseService.client)),

        ChangeNotifierProvider(
          create: (context) =>
              PerfilController(context.read<PerfilRepository>()),
        ),

        //TECNICO
        ChangeNotifierProvider(
          create: (_) =>
              TecnicoController(TecnicoRepository(SupabaseService.client)),
        ),
        //CLIENTE
        //SOLICITUDES
        ChangeNotifierProvider(
          create: (_) => SolicitudesController(
            SolicitudesRepository(SupabaseService.client),
          ),
        ),
        //CHATS
        ChangeNotifierProvider(
          create: (_) => ChatController(ChatRepository(SupabaseService.client)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
