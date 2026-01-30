import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/solicitudes_controller.dart';
import 'detalle_solicitud_cliente_page.dart';

class MisSolicitudesPage extends StatefulWidget {
  const MisSolicitudesPage({super.key});

  @override
  State<MisSolicitudesPage> createState() => _MisSolicitudesPageState();
}

class _MisSolicitudesPageState extends State<MisSolicitudesPage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 🔥 Ejecutar DESPUÉS del build
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<SolicitudesController>().cargarMisSolicitudes();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final solicitudes = context.watch<SolicitudesController>();

    if (solicitudes.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (solicitudes.misSolicitudes.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No tienes solicitudes aún')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mis solicitudes')),
      body: ListView.builder(
        itemCount: solicitudes.misSolicitudes.length,
        itemBuilder: (context, index) {
          final s = solicitudes.misSolicitudes[index];
          final imagenes = s['solicitud_imagenes'] as List<dynamic>?;
          final imageUrl = imagenes != null && imagenes.isNotEmpty
              ? imagenes.first['imagen_url']
              : null;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              leading: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.assignment_outlined, size: 40),
              title: Text(
                s['categoria'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s['descripcion'],
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
