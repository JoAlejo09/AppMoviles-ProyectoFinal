import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Supabase (una sola vez)
  await SupabaseService.initialize();

  runApp(const MyApp());
}
