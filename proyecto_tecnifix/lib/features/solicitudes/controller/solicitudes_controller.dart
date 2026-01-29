import 'package:flutter/material.dart';
import '../data/solicitudes_repository.dart';

class SolicitudesController extends ChangeNotifier {
  final SolicitudesRepository _repository;

  SolicitudesController(this._repository);

  bool isLoading = false;

  /// Lista general usada por las vistas
  List<Map<String, dynamic>> solicitudes = [];

  // CLIENTE
  Future<void> cargarSolicitudesCliente() async {
    _setLoading(true);

    solicitudes = await _repository.obtenerSolicitudesCliente();

    _setLoading(false);
  }

  Future<int> crearSolicitud({
    required int servicioId,
    required String problema,
    String? detalles,
    String? tecnicoId,
  }) async {
    _setLoading(true);

    final data = await _repository.crearSolicitud(
      servicioId: servicioId,
      problema: problema,
      detalles: detalles,
      tecnicoId: tecnicoId,
    );

    // refrescar lista cliente
    solicitudes = await _repository.obtenerSolicitudesCliente();

    _setLoading(false);

    return data['id'] as int;
  }
  // TÉCNICO

  Future<void> cargarSolicitudesTecnico() async {
    _setLoading(true);

    solicitudes = await _repository.obtenerSolicitudesTecnico();

    _setLoading(false);
  }

  Future<void> cargarSolicitudesPendientes() async {
    _setLoading(true);

    solicitudes = await _repository.obtenerSolicitudesPendientes();

    _setLoading(false);
  }

  Future<void> aceptarSolicitud(int solicitudId) async {
    _setLoading(true);

    await _repository.aceptarSolicitud(solicitudId);

    // Volver a cargar pendientes
    solicitudes = await _repository.obtenerSolicitudesPendientes();

    _setLoading(false);
  }

  // ─────────────────────────────────────────────
  // ESTADOS
  // ─────────────────────────────────────────────

  Future<void> cambiarEstado({
    required int solicitudId,
    required String nuevoEstado,
  }) async {
    _setLoading(true);

    await _repository.cambiarEstado(
      solicitudId: solicitudId,
      nuevoEstado: nuevoEstado,
    );

    _setLoading(false);
  }

  // ─────────────────────────────────────────────
  // UTILIDAD
  // ─────────────────────────────────────────────

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void reset() {
    solicitudes = [];
    isLoading = false;
    notifyListeners();
  }
}
