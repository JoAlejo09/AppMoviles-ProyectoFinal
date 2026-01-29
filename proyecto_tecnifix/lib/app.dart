import 'package:flutter/material.dart';
import 'core/config/app_theme.dart';
import 'core/app_root.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TecniFix',
      theme: AppTheme.lightTheme,
      home: const AppRoot(),
    );
  }
}
