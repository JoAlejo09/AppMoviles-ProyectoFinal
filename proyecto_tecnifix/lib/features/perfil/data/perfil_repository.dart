import 'package:supabase_flutter/supabase_flutter.dart';

class PerfilRepository {
  final SupabaseClient _client;

  PerfilRepository(this._client);

  Future<Map<String, dynamic>?> obtenerPerfil() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    return await _client
        .from('perfiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
  }

  /// CREA o ACTUALIZA el perfil
  Future<void> guardarPerfil({
    required String nombre,
    required String apellido,
    required String celular,
    required String provincia,
    required String ciudad,
    required String calle,
    required String rol,
    required double lat,
    required double lng,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final perfilExistente = await obtenerPerfil();

    final data = {
      'id': user.id,
      'email': user.email,
      'nombre': nombre,
      'apellido': apellido,
      'celular': celular,
      'provincia': provincia,
      'ciudad': ciudad,
      'calle': calle,
      'rol': rol,
      'latitud': lat,
      'longitud': lng,
    };

    if (perfilExistente == null) {
      // 🔥 PRIMERA VEZ → INSERT
      await _client.from('perfiles').insert(data);
    } else {
      // 🔁 YA EXISTE → UPDATE
      await _client.from('perfiles').update(data).eq('id', user.id);
    }
  }

  bool perfilCompleto(Map<String, dynamic> p) {
    bool hasText(dynamic v) => v != null && v.toString().trim().isNotEmpty;

    return hasText(p['nombre']) &&
        hasText(p['apellido']) &&
        hasText(p['celular']) &&
        hasText(p['rol']) &&
        p['latitud'] != null &&
        p['longitud'] != null;
  }
}
