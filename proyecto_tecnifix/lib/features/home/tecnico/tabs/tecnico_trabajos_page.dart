import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../solicitudes/controller/solicitudes_controller.dart';
import '../../../solicitudes/presentation/tecnico/detalle_solicitud_tecnico_page.dart';

class TecnicoTrabajosPage extends StatefulWidget {
  const TecnicoTrabajosPage({super.key});

  @override
  State<TecnicoTrabajosPage> createState() => _TecnicoTrabajosPageState();
}

class _TecnicoTrabajosPageState extends State<TecnicoTrabajosPage> {
  bool _cargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_cargado) {
      context.read<SolicitudesController>().cargarSolicitudesTecnico();
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

    // 📭 Sin trabajos
    if (controller.solicitudes.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No tienes trabajos asignados aún 👷‍♂️',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mis trabajos')),
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
                    builder: (_) => DetalleSolicitudTecnicoPage(solicitud: s),
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
