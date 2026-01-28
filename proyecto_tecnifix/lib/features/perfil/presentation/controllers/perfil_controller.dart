import 'package:flutter/material.dart';
import '../../data/models/perfil_model.dart';
import '../../data/repositories/perfil_repository.dart';

class PerfilController extends ChangeNotifier {
  final PerfilRepository _repository;

  PerfilController(this._repository);

  PerfilModel? _perfil;
  bool _isLoading = false;
  String? _error;

  PerfilModel? get perfil => _perfil;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isPerfilCompleto {
    if (_perfil == null) return false;
    return _perfil!.nombre != null &&
        _perfil!.apellido != null &&
        _perfil!.rol != null &&
        _perfil!.latitud != null &&
        _perfil!.longitud != null;
  }

  Future<void> cargarPerfil(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _perfil = await _repository.getPerfilById(userId);
    } catch (e) {
      _error = 'Error al cargar el perfil';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> actualizarPerfil({
    required String nombre,
    required String apellido,
    required String rol,
    required double latitud,
    required double longitud,
    String? celular,
  }) async {
    if (_perfil == null) {
      _error = 'Perfil no cargado';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedPerfil = await _repository.updatePerfil(
        userId: _perfil!.id,
        nombre: nombre,
        apellido: apellido,
        rol: rol,
        latitud: latitud,
        longitud: longitud,
        celular: celular,
      );

      _perfil = updatedPerfil;
    } catch (e) {
      _error = 'No se pudo guardar el perfil. Revisa la conexión';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
