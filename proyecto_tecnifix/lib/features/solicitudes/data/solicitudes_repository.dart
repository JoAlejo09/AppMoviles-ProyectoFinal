import 'package:supabase_flutter/supabase_flutter.dart';

class SolicitudesRepository {
  final SupabaseClient _client;

  SolicitudesRepository(this._client);

  // ─────────────────────────────────────────────
  // CLIENTE
  // ─────────────────────────────────────────────

  /// Crear una solicitud (cliente)
  Future<Map<String, dynamic>> crearSolicitud({
    required int servicioId,
    required String problema,
    String? detalles,
    String? tecnicoId,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    final data = await _client
        .from('solicitudes')
        .insert({
          'cliente_id': user.id,
          'servicio_id': servicioId,
          'problema': problema,
          'detalles': detalles,
          'tecnico_id': tecnicoId,
          'estado': 'pendiente',
        })
        .select()
        .single();

    return data;
  }

  /// Obtener solicitudes del cliente autenticado
  Future<List<Map<String, dynamic>>> obtenerSolicitudesCliente() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client
        .from('solicitudes')
        .select('*, servicios(nombre)')
        .eq('cliente_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  // ─────────────────────────────────────────────
  // TÉCNICO
  // ─────────────────────────────────────────────

  /// Obtener solicitudes asignadas al técnico
  Future<List<Map<String, dynamic>>> obtenerSolicitudesTecnico() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client
        .from('solicitudes')
        .select('*, servicios(nombre), perfiles(nombre, apellido)')
        .eq('tecnico_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  /// Obtener solicitudes pendientes (para aceptar)
  Future<List<Map<String, dynamic>>> obtenerSolicitudesPendientes() async {
    final data = await _client
        .from('solicitudes')
        .select('*, servicios(nombre), perfiles(nombre, apellido)')
        .eq('estado', 'pendiente')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  /// Técnico acepta una solicitud
  Future<void> aceptarSolicitud(int solicitudId) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    await _client
        .from('solicitudes')
        .update({'estado': 'aceptada', 'tecnico_id': user.id})
        .eq('id', solicitudId);
  }

  // ─────────────────────────────────────────────
  // ESTADOS
  // ─────────────────────────────────────────────

  /// Cambiar estado de la solicitud
  Future<void> cambiarEstado({
    required int solicitudId,
    required String nuevoEstado,
  }) async {
    await _client
        .from('solicitudes')
        .update({'estado': nuevoEstado})
        .eq('id', solicitudId);
  }
}
