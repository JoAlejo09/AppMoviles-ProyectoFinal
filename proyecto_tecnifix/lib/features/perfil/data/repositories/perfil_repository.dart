import 'package:proyecto_tecnifix/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/perfil_model.dart';

class PerfilRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<PerfilModel?> getPerfilById(String userId) async {
    final response = await _client
        .from('perfiles')
        .select()
        .eq('id', userId)
        .single();

    if (response == null) return null;

    return PerfilModel.fromMap(response);
  }

  Future<PerfilModel> updatePerfil({
    required String userId,
    required String nombre,
    required String apellido,
    required String rol,
    required double latitud,
    required double longitud,
    String? celular,
  }) async {
    final updates = {
      'nombre': nombre,
      'apellido': apellido,
      'rol': rol,
      'latitud': latitud,
      'longitud': longitud,
      'celular': celular,
    };

    final data = await _client
        .from('perfiles')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();

    return PerfilModel.fromMap(data);
  }
}
