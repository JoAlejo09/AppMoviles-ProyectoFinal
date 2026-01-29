import 'package:flutter/material.dart';

import '../../../solicitudes/presentation/cliente/crear_solicitud_page.dart';

class ClienteInicioPage extends StatelessWidget {
  const ClienteInicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TecniFix')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '¿Qué servicio necesitas hoy?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Encuentra técnicos cercanos y confiables en minutos.'),
            const SizedBox(height: 32),

            // 🔥 BOTÓN PRINCIPAL
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Crear solicitud'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CrearSolicitudPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
