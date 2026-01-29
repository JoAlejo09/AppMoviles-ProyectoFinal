import 'package:flutter/material.dart';
import '../data/tecnico_repository.dart';

class TecnicoController extends ChangeNotifier {
  final TecnicoRepository _repository;

  TecnicoController(this._repository);

  Map<String, dynamic>? _detalle;
  bool _isLoading = false;

  Map<String, dynamic>? get detalle => _detalle;
  bool get isLoading => _isLoading;

  bool get detalleCompleto =>
      _detalle != null && _repository.detalleCompleto(_detalle!);

  Future<void> cargarDetalle() async {
    _isLoading = true;
    notifyListeners();

    _detalle = await _repository.obtenerDetalle();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> guardarDetalle({
    required String especialidad,
    required int experienciaAnios,
    required String descripcion,
  }) async {
    _isLoading = true;
    notifyListeners();

    await _repository.guardarDetalle(
      especialidad: especialidad,
      experienciaAnios: experienciaAnios,
      descripcion: descripcion,
    );

    _detalle = await _repository.obtenerDetalle();

    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _detalle = null;
    _isLoading = false;
    notifyListeners();
  }
}
