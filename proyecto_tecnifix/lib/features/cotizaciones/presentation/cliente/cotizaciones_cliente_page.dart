import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/cotizaciones_controller.dart';

class CotizacionesClientePage extends StatefulWidget {
  final int solicitudId;

  const CotizacionesClientePage({super.key, required this.solicitudId});

  @override
  State<CotizacionesClientePage> createState() =>
      _CotizacionesClientePageState();
}

class _CotizacionesClientePageState extends State<CotizacionesClientePage> {
  @override
  void initState() {
    super.initState();

    // 🔄 Cargar cotizaciones al entrar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CotizacionesController>().cargarCotizacionesSolicitud(
        widget.solicitudId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CotizacionesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cotizaciones recibidas')),
      body: Builder(
        builder: (_) {
          // ───── LOADING ─────
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ───── ERROR ─────
          if (controller.error != null) {
            return Center(
              child: Text(
                controller.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          final cotizaciones = controller.cotizaciones;

          // ───── VACÍO ─────
          if (cotizaciones.isEmpty) {
            return const Center(
              child: Text('No hay cotizaciones para esta solicitud'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cotizaciones.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final c = cotizaciones[index];
              final tecnico = c['tecnico'];

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ───── TÉCNICO ─────
                      Text(
                        '${tecnico?['nombre'] ?? ''} ${tecnico?['apellido'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ───── PRECIO ─────
                      Text(
                        'Precio: \$${c['precio']}',
                        style: const TextStyle(fontSize: 15),
                      ),

                      if (c['mensaje'] != null &&
                          c['mensaje'].toString().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          c['mensaje'],
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // ───── ESTADO ─────
                      _EstadoChip(estado: c['estado']),

                      const SizedBox(height: 16),

                      // ───── ACCIONES ─────
                      if (c['estado'] == 'pendiente')
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: controller.isLoading
                                    ? null
                                    : () =>
                                          _rechazarCotizacion(context, c['id']),
                                child: const Text('Rechazar'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: controller.isLoading
                                    ? null
                                    : () => _confirmarAceptar(context, c),
                                child: const Text('Aceptar'),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CONFIRMAR ACEPTACIÓN
  // ─────────────────────────────────────────────
  Future<void> _confirmarAceptar(
    BuildContext context,
    Map<String, dynamic> cotizacion,
  ) async {
    final controller = context.read<CotizacionesController>();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Aceptar cotización'),
        content: const Text(
          '¿Deseas aceptar esta cotización? '
          'Las demás serán rechazadas automáticamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await controller.aceptarCotizacion(
        cotizacionId: cotizacion['id'],
        solicitudId: widget.solicitudId,
        tecnicoId: cotizacion['tecnico_id'],
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cotización aceptada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  // ─────────────────────────────────────────────
  // RECHAZAR
  // ─────────────────────────────────────────────
  Future<void> _rechazarCotizacion(
    BuildContext context,
    int cotizacionId,
  ) async {
    final controller = context.read<CotizacionesController>();

    try {
      await controller.rechazarCotizacion(
        cotizacionId: cotizacionId,
        solicitudId: widget.solicitudId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cotización rechazada')));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }
}

// ─────────────────────────────────────────────
// CHIP DE ESTADO
// ─────────────────────────────────────────────
class _EstadoChip extends StatelessWidget {
  final String estado;

  const _EstadoChip({required this.estado});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (estado) {
      case 'aceptada':
        color = Colors.green;
        break;
      case 'rechazada':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Chip(
      label: Text(
        estado.toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
