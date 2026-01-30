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
  @override
  void initState() {
    super.initState();

    // ✅ Cargar UNA sola vez (patrón correcto con Provider)
    Future.microtask(() {
      if (!mounted) return;
      context.read<SolicitudesController>().cargarTrabajosTecnico();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SolicitudesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mis trabajos')),
      body: _buildBody(controller),
    );
  }

  Widget _buildBody(SolicitudesController controller) {
    // ⏳ Cargando
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 📭 Sin trabajos asignados
    if (controller.trabajosTecnico.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.build_outlined, size: 72, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Aún no tienes trabajos asignados.\n'
                'Cuando un cliente acepte tu cotización,\n'
                'aparecerá aquí.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // 📋 Lista de trabajos
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.trabajosTecnico.length,
      itemBuilder: (context, index) {
        final s = controller.trabajosTecnico[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              s['categoria'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s['descripcion'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Estado: ${s['estado']}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
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
    );
  }
}
