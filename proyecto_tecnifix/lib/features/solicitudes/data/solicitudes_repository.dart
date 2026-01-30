import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class SolicitudesRepository {
  final SupabaseClient _client;

  SolicitudesRepository(this._client);

  // CLIENTE → CREAR SOLICITUD
  Future<int> crearSolicitud({
    required String categoria,
    required String descripcion,
    required double latServicio,
    required double lngServicio,
    String? direccionServicio,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final response = await _client
        .from('solicitudes')
        .insert({
          'cliente_id': user.id,
          'categoria': categoria,
          'descripcion': descripcion,
          'latitud_servicio': latServicio,
          'longitud_servicio': lngServicio, // ✅ CORREGIDO
          'direccion_servicio': direccionServicio,
          'estado': 'abierta', // ✅ ESTADO REAL
        })
        .select('id')
        .single();

    return response['id'] as int;
  }

  // IMÁGENES
  Future<String> subirImagenSolicitud({
    required int solicitudId,
    required File file,
  }) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    final path = 'solicitudes/$solicitudId/$fileName';

    await _client.storage.from('solicitudes').upload(path, file);
    return path;
  }

  Future<void> guardarImagenSolicitud({
    required int solicitudId,
    required String path,
  }) async {
    await _client.from('solicitud_imagenes').insert({
      'solicitud_id': solicitudId,
      'imagen_url': path,
    });
  }

  Future<String> obtenerImagenFirmada(String path) async {
    return await _client.storage
        .from('solicitudes')
        .createSignedUrl(path, 60 * 60);
  }

  // ─────────────────────────────────────────────
  // CLIENTE → MIS SOLICITUDES
  // ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> obtenerMisSolicitudes() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client
        .from('solicitudes')
        .select('*, solicitud_imagenes(imagen_url)')
        .eq('cliente_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  // ─────────────────────────────────────────────
  // TÉCNICO → SOLICITUDES DISPONIBLES
  // ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> obtenerSolicitudesDisponibles({
    required String categoria,
  }) async {
    final data = await _client
        .from('solicitudes')
        .select('*, solicitud_imagenes(imagen_url)')
        .eq('estado', 'abierta')
        .filter('tecnico_id', 'is', null)
        .ilike('categoria', '%$categoria%')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  // ─────────────────────────────────────────────
  // TÉCNICO → MIS TRABAJOS
  // ─────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> obtenerTrabajosTecnico() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final data = await _client
        .from('solicitudes')
        .select('*, solicitud_imagenes(imagen_url)')
        .eq('tecnico_id', user.id)
        .filter('estado', 'in', ('aceptada', 'finalizada')) // ✅ CORREGIDO
        .order('updated_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  // ─────────────────────────────────────────────
  // TÉCNICO → FINALIZAR TRABAJO
  // ─────────────────────────────────────────────
  Future<void> finalizarTrabajo(int solicitudId) async {
    await _client
        .from('solicitudes')
        .update({'estado': 'finalizada'})
        .eq('id', solicitudId);
  }

  // ─────────────────────────────────────────────
  // TÉCNICO → INICIAR TRABAJO
  // ─────────────────────────────────────────────
  Future<void> iniciarTrabajo(int solicitudId) async {
    await _client
        .from('solicitudes')
        .update({'estado': 'en_proceso'})
        .eq('id', solicitudId);
  }
}
