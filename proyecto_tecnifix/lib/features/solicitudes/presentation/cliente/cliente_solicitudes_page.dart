import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tecnifix/features/solicitudes/presentation/cliente/detalle_solicitud_page.dart';

import '../../controller/solicitudes_controller.dart';
import 'crear_solicitud_page.dart';

class ClienteSolicitudesPage extends StatefulWidget {
  const ClienteSolicitudesPage({super.key});

  @override
  State<ClienteSolicitudesPage> createState() => _ClienteSolicitudesPageState();
}

class _ClienteSolicitudesPageState extends State<ClienteSolicitudesPage> {
  bool _cargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_cargado) {
      context.read<SolicitudesController>().cargarSolicitudesCliente();
      _cargado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SolicitudesController>();

    // ⏳ Cargando
    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 📭 Sin solicitudes
    if (controller.solicitudes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mis solicitudes')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Aún no tienes solicitudes',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Crear solicitud'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CrearSolicitudPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    // 📄 Con solicitudes
    return Scaffold(
      appBar: AppBar(title: const Text('Mis solicitudes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CrearSolicitudPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.solicitudes.length,
        itemBuilder: (_, i) {
          final s = controller.solicitudes[i];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(s['problema']),
              subtitle: Text('Estado: ${s['estado']}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetalleSolicitudClientePage(solicitud: s),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
