import 'package:supabase_flutter/supabase_flutter.dart';

class CotizacionesRepository {
  final SupabaseClient _client;

  CotizacionesRepository(this._client);

  // ─────────────────────────────────────────────
  // TÉCNICO → CREAR COTIZACIÓN
  // ─────────────────────────────────────────────
  Future<void> crearCotizacion({
    required int solicitudId,
    required double precio,
    String? mensaje,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    if (precio <= 0) {
      throw Exception('El precio debe ser mayor a 0');
    }

    // 🔒 Evitar doble cotización
    final existente = await _client
        .from('cotizaciones')
        .select('id')
        .eq('solicitud_id', solicitudId)
        .eq('tecnico_id', user.id)
        .maybeSingle();

    if (existente != null) {
      throw Exception('Ya enviaste una cotización para esta solicitud');
    }

    await _client.from('cotizaciones').insert({
      'solicitud_id': solicitudId,
      'tecnico_id': user.id,
      'precio': precio,
      if (mensaje != null && mensaje.isNotEmpty) 'mensaje': mensaje,
      'estado': 'pendiente',
    });
  }

  // ─────────────────────────────────────────────
  // CLIENTE → VER COTIZACIONES DE SU SOLICITUD
  // ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> obtenerCotizacionesSolicitud(
    int solicitudId,
  ) async {
    final data = await _client
        .from('cotizaciones')
        .select('''
          id,
          solicitud_id,
          tecnico_id,
          precio,
          mensaje,
          estado,
          created_at,
          tecnico:perfiles (
            id,
            nombre,
            apellido
          )
        ''')
        .eq('solicitud_id', solicitudId)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(data);
  }

  // ─────────────────────────────────────────────
  // CLIENTE → RECHAZAR COTIZACIÓN
  // ─────────────────────────────────────────────
  Future<void> rechazarCotizacion(int cotizacionId) async {
    await _client
        .from('cotizaciones')
        .update({'estado': 'rechazada'})
        .eq('id', cotizacionId);
  }

  // ─────────────────────────────────────────────
  // CLIENTE → ACEPTAR COTIZACIÓN
  // ─────────────────────────────────────────────
  Future<void> aceptarCotizacion({
    required int cotizacionId,
    required int solicitudId,
    required String tecnicoId,
  }) async {
    // 1️⃣ Aceptar la cotización seleccionada
    await _client
        .from('cotizaciones')
        .update({'estado': 'aceptada'})
        .eq('id', cotizacionId);

    // 2️⃣ Rechazar las demás
    await _client
        .from('cotizaciones')
        .update({'estado': 'rechazada'})
        .eq('solicitud_id', solicitudId)
        .neq('id', cotizacionId);

    // 3️⃣ Asignar técnico y cambiar estado de solicitud
    await _client
        .from('solicitudes')
        .update({'estado': 'aceptada', 'tecnico_id': tecnicoId})
        .eq('id', solicitudId);
  }

  // ─────────────────────────────────────────────
  // TÉCNICO → VER MIS COTIZACIONES
  // ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> obtenerMisCotizaciones() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client
        .from('cotizaciones')
        .select('''
          id,
          solicitud_id,
          tecnico_id,
          precio,
          mensaje,
          estado,
          created_at,
          solicitudes (
            id,
            categoria,
            descripcion,
            estado
          )
        ''')
        .eq('tecnico_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }
}
