import 'package:supabase_flutter/supabase_flutter.dart';

class TecnicoRepository {
  final SupabaseClient _client;

  TecnicoRepository(this._client);

  Future<Map<String, dynamic>?> obtenerDetalle() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    return await _client
        .from('tecnico_detalle')
        .select()
        .eq('id', user.id)
        .maybeSingle();
  }

  Future<void> guardarDetalle({
    required String especialidad,
    required int experienciaAnios,
    required String descripcion,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No autenticado');

    final existente = await obtenerDetalle();

    final data = {
      'id': user.id,
      'especialidad': especialidad,
      'experiencia_anios': experienciaAnios,
      'descripcion': descripcion,
    };

    if (existente == null) {
      await _client.from('tecnico_detalle').insert(data);
    } else {
      await _client.from('tecnico_detalle').update(data).eq('id', user.id);
    }
  }

  bool detalleCompleto(Map<String, dynamic> d) {
    return d['especialidad'] != null && d['experiencia_anios'] != null;
  }

  /// 🔥 TOP 5 técnicos por cercanía + reputación
  Future<List<Map<String, dynamic>>> obtenerTopTecnicos({
    required double lat,
    required double lng,
  }) async {
    final response = await _client.rpc(
      'obtener_tecnicos_cercanos',
      params: {'lat_cliente': lat, 'lng_cliente': lng},
    );

    return List<Map<String, dynamic>>.from(response);
  }
}
