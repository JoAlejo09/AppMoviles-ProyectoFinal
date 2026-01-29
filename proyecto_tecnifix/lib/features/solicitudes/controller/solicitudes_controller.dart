import 'package:flutter/material.dart';
import '../data/solicitudes_repository.dart';

class SolicitudesController extends ChangeNotifier {
  final SolicitudesRepository _repository;

  SolicitudesController(this._repository);

  bool isLoading = false;

  /// Lista general usada por las vistas
  List<Map<String, dynamic>> solicitudes = [];

  // ─────────────────────────────────────────────
  // CLIENTE
  // ─────────────────────────────────────────────

  Future<void> cargarSolicitudesCliente() async {
    try {
      _setLoading(true);
      solicitudes = await _repository.obtenerSolicitudesCliente();
    } catch (e, st) {
      debugPrint('❌ Error cargarSolicitudesCliente: $e');
      debugPrint('$st');
      solicitudes = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<int> crearSolicitud({
    required int servicioId,
    required String problema,
    String? detalles,
    String? tecnicoId,
  }) async {
    try {
      _setLoading(true);

      final data = await _repository.crearSolicitud(
        servicioId: servicioId,
        problema: problema,
        detalles: detalles,
        tecnicoId: tecnicoId,
      );

      // refrescar lista cliente
      solicitudes = await _repository.obtenerSolicitudesCliente();

      return data['id'] as int;
    } catch (e, st) {
      debugPrint('❌ Error al crear solicitud: $e');
      debugPrint('$st');
      rethrow; // la UI debe enterarse
    } finally {
      _setLoading(false);
    }
  }

  // ─────────────────────────────────────────────
  // TÉCNICO
  // ─────────────────────────────────────────────

  Future<void> cargarSolicitudesTecnico() async {
    try {
      _setLoading(true);
      solicitudes = await _repository.obtenerSolicitudesTecnico();
    } catch (e, st) {
      debugPrint('❌ Error cargarSolicitudesTecnico: $e');
      debugPrint('$st');
      solicitudes = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> cargarSolicitudesPendientes() async {
    try {
      _setLoading(true);
      solicitudes = await _repository.obtenerSolicitudesPendientes();
    } catch (e, st) {
      debugPrint('❌ Error cargarSolicitudesPendientes: $e');
      debugPrint('$st');
      solicitudes = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> aceptarSolicitud(int solicitudId) async {
    try {
      _setLoading(true);

      await _repository.aceptarSolicitud(solicitudId);

      // Volver a cargar pendientes
      solicitudes = await _repository.obtenerSolicitudesPendientes();
    } catch (e, st) {
      debugPrint('❌ Error aceptarSolicitud: $e');
      debugPrint('$st');
    } finally {
      _setLoading(false);
    }
  }

  // ─────────────────────────────────────────────
  // ESTADOS
  // ─────────────────────────────────────────────

  Future<void> cambiarEstado({
    required int solicitudId,
    required String nuevoEstado,
  }) async {
    try {
      _setLoading(true);

      await _repository.cambiarEstado(
        solicitudId: solicitudId,
        nuevoEstado: nuevoEstado,
      );
    } catch (e, st) {
      debugPrint('❌ Error cambiarEstado: $e');
      debugPrint('$st');
    } finally {
      _setLoading(false);
    }
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
