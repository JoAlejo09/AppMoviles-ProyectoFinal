import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/solicitudes_controller.dart';
import '../../data/solicitud_imagen_repository.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../chat/presentation/chat_page.dart';

class DetalleSolicitudTecnicoPage extends StatefulWidget {
  final Map<String, dynamic> solicitud;

  const DetalleSolicitudTecnicoPage({super.key, required this.solicitud});

  @override
  State<DetalleSolicitudTecnicoPage> createState() =>
      _DetalleSolicitudTecnicoPageState();
}

class _DetalleSolicitudTecnicoPageState
    extends State<DetalleSolicitudTecnicoPage> {
  List<String> _imagenes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarImagenes();
  }

  Future<void> _cargarImagenes() async {
    final repo = SolicitudImagenRepository(SupabaseService.client);
    final imgs = await repo.obtenerImagenes(widget.solicitud['id']);

    setState(() {
      _imagenes = imgs;
      _loading = false;
    });
  }

  Future<void> _cambiarEstado(String estado) async {
    final controller = context.read<SolicitudesController>();

    await controller.cambiarEstado(
      solicitudId: widget.solicitud['id'],
      nuevoEstado: estado,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.solicitud;

    return Scaffold(
      appBar: AppBar(title: const Text('Trabajo asignado')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _item('Problema', s['problema']),
                _item('Estado', s['estado']),
                _item('Cliente', s['perfiles']?['nombre']),
                const SizedBox(height: 20),

                // ───── Fotos ─────
                const Text(
                  'Fotos del problema',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                if (_imagenes.isEmpty) const Text('No se adjuntaron fotos'),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _imagenes
                      .map(
                        (url) => Image.network(
                          url,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 24),

                // ───── Acciones ─────
                if (s['estado'] == 'aceptada')
                  ElevatedButton(
                    onPressed: () => _cambiarEstado('en_proceso'),
                    child: const Text('Marcar en proceso'),
                  ),

                if (s['estado'] == 'en_proceso')
                  ElevatedButton(
                    onPressed: () => _cambiarEstado('finalizada'),
                    child: const Text('Finalizar trabajo'),
                  ),

                const SizedBox(height: 12),

                // ───── Chat ─────
                ElevatedButton.icon(
                  icon: const Icon(Icons.chat),
                  label: const Text('Abrir chat'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(solicitudId: s['id']),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  Widget _item(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 5, child: Text(value?.toString() ?? '-')),
        ],
      ),
    );
  }
}
