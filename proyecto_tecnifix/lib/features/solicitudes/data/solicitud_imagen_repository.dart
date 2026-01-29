import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

class SolicitudImagenRepository {
  final SupabaseClient _client;

  SolicitudImagenRepository(this._client);

  /// Subir imagen y retornar URL pública
  Future<String> subirImagen({
    required File file,
    required int solicitudId,
  }) async {
    final fileName =
        'solicitud_$solicitudId/${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';

    await _client.storage.from('solicitudes').upload(fileName, file);

    return _client.storage.from('solicitudes').getPublicUrl(fileName);
  }

  /// Guardar URL en BD
  Future<void> guardarImagen({
    required int solicitudId,
    required String url,
  }) async {
    await _client.from('solicitud_imagenes').insert({
      'solicitud_id': solicitudId,
      'imagen_url': url,
    });
  }

  Future<List<String>> obtenerImagenes(int solicitudId) async {
    final data = await _client
        .from('solicitud_imagenes')
        .select('imagen_url')
        .eq('solicitud_id', solicitudId);

    return List<String>.from(data.map((e) => e['imagen_url']));
  }
}
