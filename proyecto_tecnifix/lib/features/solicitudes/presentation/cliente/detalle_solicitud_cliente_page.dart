import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:proyecto_tecnifix/features/solicitudes/controller/solicitudes_controller.dart';
import 'package:proyecto_tecnifix/features/cotizaciones/presentation/cotizaciones_solicitud_page.dart';
import 'package:proyecto_tecnifix/features/pagos/presentation/pago_solicitud_page.dart';

class DetalleSolicitudClientePage extends StatelessWidget {
  final Map<String, dynamic> solicitud;

  const DetalleSolicitudClientePage({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final imagenes = solicitud['solicitud_imagenes'] as List<dynamic>? ?? [];

    final lat = (solicitud['latitud_servicio'] as num).toDouble();
    final lng = (solicitud['longitud_servicio'] as num).toDouble();
    final position = LatLng(lat, lng);

    final controller = context.read<SolicitudesController>();
    final estado = solicitud['estado'] as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de solicitud')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ───────── CATEGORÍA ─────────
          Text(
            solicitud['categoria'],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // ───────── ESTADO ─────────
          Chip(
            label: Text(
              estado.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: _colorEstado(estado),
          ),

          const SizedBox(height: 12),

          // ───────── DESCRIPCIÓN ─────────
          Text(solicitud['descripcion']),

          const SizedBox(height: 16),

          // ───────── IMÁGENES ─────────
          if (imagenes.isNotEmpty) ...[
            const Text(
              'Imágenes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: imagenes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final path = imagenes[index]['imagen_url'] as String;

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FutureBuilder<String>(
                      future: controller.obtenerImagenFirmada(path),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            width: 120,
                            height: 120,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        if (snapshot.hasError || !snapshot.hasData) {
                          return const SizedBox(
                            width: 120,
                            height: 120,
                            child: Icon(Icons.broken_image),
                          );
                        }

                        return Image.network(
                          snapshot.data!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ───────── MAPA ─────────
          const Text(
            'Ubicación del servicio',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 220,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: position, zoom: 14),
              markers: {
                Marker(
                  markerId: const MarkerId('servicio'),
                  position: position,
                ),
              },
              zoomControlsEnabled: false,
            ),
          ),

          const SizedBox(height: 32),

          // ───────── ACCIONES ─────────

          // 🔹 VER COTIZACIONES
          if (estado == 'abierta')
            _BotonAccion(
              icon: Icons.list_alt,
              label: 'Ver cotizaciones',
              color: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CotizacionesSolicitudPage(solicitud: solicitud),
                  ),
                );
              },
            ),

          // 🔹 PAGAR SERVICIO
          if (estado == 'finalizada')
            _BotonAccion(
              icon: Icons.payment,
              label: 'Pagar servicio',
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PagoSolicitudPage(
                      solicitudId: solicitud['id'],
                      monto:
                          (solicitud['precio_final'] as num?)?.toDouble() ?? 0,
                    ),
                  ),
                );
              },
            ),

          // 🔹 PAGADO
          if (estado == 'pagada')
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Servicio pagado ✅',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // COLOR POR ESTADO
  // ─────────────────────────────────────────────
  Color _colorEstado(String estado) {
    switch (estado) {
      case 'abierta':
        return Colors.orange;
      case 'aceptada':
        return Colors.blueGrey;
      case 'en_proceso':
        return Colors.deepOrange;
      case 'finalizada':
        return Colors.purple;
      case 'pagada':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

// ─────────────────────────────────────────────
// BOTÓN REUTILIZABLE
// ─────────────────────────────────────────────
class _BotonAccion extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _BotonAccion({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(label),
          style: ElevatedButton.styleFrom(backgroundColor: color),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
