import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository {
  final SupabaseClient _client;

  ChatRepository(this._client);

  /// Obtener mensajes de una solicitud
  Future<List<Map<String, dynamic>>> obtenerMensajes(int solicitudId) async {
    final data = await _client
        .from('mensajes')
        .select('*, perfiles(nombre, apellido)')
        .eq('solicitud_id', solicitudId)
        .order('created_at');

    return List<Map<String, dynamic>>.from(data);
  }

  /// Enviar mensaje
  Future<void> enviarMensaje({
    required int solicitudId,
    required String mensaje,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No autenticado');

    await _client.from('mensajes').insert({
      'solicitud_id': solicitudId,
      'emisor_id': user.id,
      'mensaje': mensaje,
    });
  }
}
