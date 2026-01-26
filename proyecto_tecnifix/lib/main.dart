import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://opaepvuoeilpbomacgeq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9wYWVwdnVvZWlscGJvbWFjZ2VxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjkzMDcxNTQsImV4cCI6MjA4NDg4MzE1NH0.Nsdmlvvs4nbKImKRXb9Qw6WNyLxA-shSo1WcAZa2p4k',
  );
  runApp(MyApp());
}
