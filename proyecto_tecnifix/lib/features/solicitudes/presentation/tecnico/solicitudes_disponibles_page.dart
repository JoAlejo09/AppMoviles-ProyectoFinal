import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/solicitudes_controller.dart';
import '../../../tecnico/controller/tecnico_controller.dart';
import 'detalle_solicitud_tecnico_page.dart';

class SolicitudesDisponiblesPage extends StatefulWidget {
  const SolicitudesDisponiblesPage({super.key});

  @override
  State<SolicitudesDisponiblesPage> createState() =>
      _SolicitudesDisponiblesPageState();
}

class _SolicitudesDisponiblesPageState
    extends State<SolicitudesDisponiblesPage> {
  @override
  void initState() {
    super.initState();

    // ✅ Cargar UNA sola vez al entrar
    Future.microtask(() {
      if (!mounted) return;

      final tecnico = context.read<TecnicoController>();
      final solicitudes = context.read<SolicitudesController>();

      final categoria = tecnico.detalle?['especialidad'];

      debugPrint('📌 Categoria técnico: $categoria');

      if (categoria != null && categoria.isNotEmpty) {
        solicitudes.cargarSolicitudesDisponibles(categoria: categoria);
      } else {
        debugPrint('❌ Técnico sin especialidad');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final solicitudes = context.watch<SolicitudesController>();

    if (solicitudes.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (solicitudes.solicitudesDisponibles.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No hay solicitudes disponibles',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes disponibles')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: solicitudes.solicitudesDisponibles.length,
        itemBuilder: (context, index) {
          final s = solicitudes.solicitudesDisponibles[index];

          final imagenes = s['solicitud_imagenes'] as List<dynamic>?;
          final imageUrl = (imagenes != null && imagenes.isNotEmpty)
              ? imagenes.first['imagen_url']
              : null;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.build_outlined, size: 40),
              title: Text(
                s['categoria'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                s['descripcion'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
