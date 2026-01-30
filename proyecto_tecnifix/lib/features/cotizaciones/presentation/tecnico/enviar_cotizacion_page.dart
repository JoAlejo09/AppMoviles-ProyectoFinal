import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/cotizaciones_controller.dart';

class EnviarCotizacionPage extends StatefulWidget {
  final int solicitudId;

  const EnviarCotizacionPage({super.key, required this.solicitudId});

  @override
  State<EnviarCotizacionPage> createState() => _EnviarCotizacionPageState();
}

class _EnviarCotizacionPageState extends State<EnviarCotizacionPage> {
  final _formKey = GlobalKey<FormState>();
  final _precioController = TextEditingController();
  final _mensajeController = TextEditingController();

  @override
  void dispose() {
    _precioController.dispose();
    _mensajeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CotizacionesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Enviar cotización')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ───── PRECIO ─────
              const Text(
                'Precio del servicio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _precioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ej: 50.00',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa un precio';
                  }
                  final precio = double.tryParse(value);
                  if (precio == null || precio <= 0) {
                    return 'El precio debe ser mayor a 0';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ───── MENSAJE ─────
              const Text(
                'Mensaje (opcional)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _mensajeController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:
                      'Ej: Incluye materiales y mano de obra. Tiempo estimado: 2 horas.',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // ───── BOTÓN ─────
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: controller.isLoading
                      ? const Text('Enviando...')
                      : const Text('Enviar cotización'),
                  onPressed: controller.isLoading
                      ? null
                      : () => _enviarCotizacion(context),
                ),
              ),

              if (controller.error != null) ...[
                const SizedBox(height: 16),
                Text(
                  controller.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ENVIAR
  // ─────────────────────────────────────────────
  Future<void> _enviarCotizacion(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<CotizacionesController>();

    try {
      await controller.crearCotizacion(
        solicitudId: widget.solicitudId,
        precio: double.parse(_precioController.text),
        mensaje: _mensajeController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cotización enviada correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (_) {
      // error ya manejado por controller
    }
  }
}
