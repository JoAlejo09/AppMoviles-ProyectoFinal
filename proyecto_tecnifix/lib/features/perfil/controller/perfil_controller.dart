import 'package:flutter/material.dart';
import '../data/perfil_repository.dart';

class PerfilController extends ChangeNotifier {
  final PerfilRepository _repository;

  PerfilController(this._repository);

  Map<String, dynamic>? _perfil;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get perfil => _perfil;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get perfilCompleto =>
      _perfil != null && _repository.perfilCompleto(_perfil!);

  Future<void> cargarPerfil() async {
    _isLoading = true;
    notifyListeners();

    _perfil = await _repository.obtenerPerfil();

    _isLoading = false;
    notifyListeners();
  }

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
    _isLoading = true;
    notifyListeners();

    await _repository.guardarPerfil(
      nombre: nombre,
      apellido: apellido,
      celular: celular,
      provincia: provincia,
      ciudad: ciudad,
      calle: calle,
      rol: rol,
      lat: lat,
      lng: lng,
    );

    _perfil = await _repository.obtenerPerfil();

    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _perfil = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
