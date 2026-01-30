import 'package:flutter/material.dart';
import 'package:proyecto_tecnifix/features/cotizaciones/data/cotiizaciones_repository.dart';

class CotizacionesController extends ChangeNotifier {
  final CotizacionesRepository _repository;

  CotizacionesController(this._repository);

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Map<String, dynamic>> _cotizaciones = [];
  List<Map<String, dynamic>> _misCotizaciones = [];

  List<Map<String, dynamic>> get cotizaciones => _cotizaciones;
  List<Map<String, dynamic>> get misCotizaciones => _misCotizaciones;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  // CLIENTE → CARGAR COTIZACIONES
  Future<void> cargarCotizacionesSolicitud(int solicitudId) async {
    try {
      _setLoading(true);
      _setError(null);

      _cotizaciones = await _repository.obtenerCotizacionesSolicitud(
        solicitudId,
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // CLIENTE → ACEPTAR
  Future<void> aceptarCotizacion({
    required int cotizacionId,
    required int solicitudId,
    required String tecnicoId,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      await _repository.aceptarCotizacion(
        cotizacionId: cotizacionId,
        solicitudId: solicitudId,
        tecnicoId: tecnicoId,
      );
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // CLIENTE → RECHAZAR
  Future<void> rechazarCotizacion({
    required int cotizacionId,
    required int solicitudId,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      await _repository.rechazarCotizacion(cotizacionId);
      await cargarCotizacionesSolicitud(solicitudId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // TÉCNICO → CREAR
  Future<void> crearCotizacion({
    required int solicitudId,
    required double precio,
    String? mensaje,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      await _repository.crearCotizacion(
        solicitudId: solicitudId,
        precio: precio,
        mensaje: mensaje,
      );
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // TÉCNICO → MIS COTIZACIONES
  Future<void> cargarMisCotizaciones() async {
    try {
      _setLoading(true);
      _setError(null);

      _misCotizaciones = await _repository.obtenerMisCotizaciones();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
