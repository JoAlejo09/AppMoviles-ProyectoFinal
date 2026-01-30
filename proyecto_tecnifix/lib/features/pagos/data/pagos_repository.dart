import 'package:supabase_flutter/supabase_flutter.dart';

class PagosRepository {
  final SupabaseClient _client;

  PagosRepository(this._client);

  // CLIENTE → PAGAR SOLICITUD
  Future<void> pagarSolicitud({required int solicitudId}) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    // validar que la solicitud es del cliente
    final solicitud = await _client
        .from('solicitudes')
        .select('id, cliente_id, estado')
        .eq('id', solicitudId)
        .maybeSingle();

    if (solicitud == null) {
      throw Exception('Solicitud no encontrada');
    }

    if (solicitud['cliente_id'] != user.id) {
      throw Exception('No tienes permiso para pagar esta solicitud');
    }

    if (solicitud['estado'] != 'finalizada') {
      throw Exception('La solicitud aún no puede pagarse');
    }

    // 💳 SIMULACIÓN DE PAGO
    await _client
        .from('solicitudes')
        .update({
          'estado': 'pagada',
          'pagada_en': DateTime.now().toIso8601String(),
        })
        .eq('id', solicitudId);
  }
}
