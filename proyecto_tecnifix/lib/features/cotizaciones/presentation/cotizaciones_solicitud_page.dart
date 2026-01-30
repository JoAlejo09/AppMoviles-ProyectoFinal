import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/cotizaciones_controller.dart';

class CotizacionesSolicitudPage extends StatefulWidget {
  final Map<String, dynamic> solicitud;

  const CotizacionesSolicitudPage({super.key, required this.solicitud});

  @override
  State<CotizacionesSolicitudPage> createState() =>
      _CotizacionesSolicitudPageState();
}

class _CotizacionesSolicitudPageState extends State<CotizacionesSolicitudPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CotizacionesController>().cargarCotizacionesSolicitud(
        widget.solicitud['id'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CotizacionesController>();
    final estadoSolicitud = widget.solicitud['estado'];

    return Scaffold(
      appBar: AppBar(title: const Text('Cotizaciones')),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.cotizaciones.isEmpty
          ? const Center(child: Text('No hay cotizaciones aún'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.cotizaciones.length,
              itemBuilder: (context, index) {
                final c = controller.cotizaciones[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${c['tecnico']['nombre']} ${c['tecnico']['apellido']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text('Precio: \$${c['precio']}'),
                        if (c['mensaje'] != null) ...[
                          const SizedBox(height: 6),
                          Text(c['mensaje']),
                        ],
                        const SizedBox(height: 12),

                        // 🔘 BOTONES SOLO SI LA SOLICITUD ESTÁ ABIERTA
                        if (estadoSolicitud == 'abierta')
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await controller.aceptarCotizacion(
                                      cotizacionId: c['id'],
                                      solicitudId: widget.solicitud['id'],
                                      tecnicoId: c['tecnico']['id'],
                                    );

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await controller.rechazarCotizacion(
                                      cotizacionId: c['id'],
                                      solicitudId: widget.solicitud['id'],
                                    );
                                  },
                                  child: const Text('Rechazar'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
