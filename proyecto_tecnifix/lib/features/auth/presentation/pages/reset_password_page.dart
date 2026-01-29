import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nueva contraseña'),
            ),
            const SizedBox(height: 16),

            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),

            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      setState(() => loading = true);
                      try {
                        await Supabase.instance.client.auth.updateUser(
                          UserAttributes(
                            password: _passwordController.text.trim(),
                          ),
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        setState(() => error = e.toString());
                      }
                      setState(() => loading = false);
                    },
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text('Actualizar contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}
