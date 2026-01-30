import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/pagos_controller.dart';

class PagoSolicitudPage extends StatelessWidget {
  final int solicitudId;
  final double monto;

  const PagoSolicitudPage({
    super.key,
    required this.solicitudId,
    required this.monto,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PagosController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pago del servicio')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de pago',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Monto a pagar'),
                Text(
                  '\$${monto.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            const Text(
              'Método de pago',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Card(
              child: ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Pago simulado'),
                subtitle: const Text('Stripe / PayPhone próximamente'),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: controller.isLoading
                    ? null
                    : () => _confirmarPago(context),
                child: controller.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirmar pago'),
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
    );
  }

  Future<void> _confirmarPago(BuildContext context) async {
    final controller = context.read<PagosController>();

    try {
      await controller.pagarSolicitud(solicitudId);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pago realizado correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (_) {}
  }
}
