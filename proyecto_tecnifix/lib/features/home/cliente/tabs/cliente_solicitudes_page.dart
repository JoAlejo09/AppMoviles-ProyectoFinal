import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tecnifix/features/solicitudes/controller/solicitudes_controller.dart';

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

    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (controller.solicitudes.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Aún no tienes solicitudes.\nCrea tu primera solicitud 👋',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mis solicitudes')),
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
                // 🔜 DetalleSolicitudPage
              },
            ),
          );
        },
      ),
    );
  }
}
