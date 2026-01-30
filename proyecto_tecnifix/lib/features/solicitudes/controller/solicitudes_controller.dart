import 'dart:io';
import 'package:flutter/material.dart';
import '../data/solicitudes_repository.dart';

class SolicitudesController extends ChangeNotifier {
  final SolicitudesRepository _repository;

  SolicitudesController(this._repository);

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Map<String, dynamic>> _misSolicitudes = [];
  List<Map<String, dynamic>> _solicitudesDisponibles = [];
  List<Map<String, dynamic>> _trabajosTecnico = [];

  List<Map<String, dynamic>> get misSolicitudes => _misSolicitudes;
  List<Map<String, dynamic>> get solicitudesDisponibles =>
      _solicitudesDisponibles;
  List<Map<String, dynamic>> get trabajosTecnico => _trabajosTecnico;

  void reset() {
    _isLoading = false;
    _error = null;
    _misSolicitudes = [];
    _solicitudesDisponibles = [];
    _trabajosTecnico = [];
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // CLIENTE → CREAR SOLICITUD
  // ─────────────────────────────────────────────
  Future<void> crearSolicitud({
    required String categoria,
    required String descripcion,
    required double latServicio,
    required double lngServicio,
    String? direccionServicio,
    List<File> imagenes = const [],
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final solicitudId = await _repository.crearSolicitud(
        categoria: categoria,
        descripcion: descripcion,
        latServicio: latServicio,
        lngServicio: lngServicio,
        direccionServicio: direccionServicio,
      );

      for (final file in imagenes) {
        final path = await _repository.subirImagenSolicitud(
          solicitudId: solicitudId,
          file: file,
        );
        await _repository.guardarImagenSolicitud(
          solicitudId: solicitudId,
          path: path,
        );
      }

      await cargarMisSolicitudes();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────────
  // CLIENTE → MIS SOLICITUDES
  // ─────────────────────────────────────────────
  Future<void> cargarMisSolicitudes() async {
    _misSolicitudes = await _repository.obtenerMisSolicitudes();
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // TÉCNICO → DISPONIBLES
  // ─────────────────────────────────────────────
  Future<void> cargarSolicitudesDisponibles({required String categoria}) async {
    _isLoading = true;
    notifyListeners();

    _solicitudesDisponibles = await _repository.obtenerSolicitudesDisponibles(
      categoria: categoria,
    );

    _isLoading = false;
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // TÉCNICO → MIS TRABAJOS
  // ─────────────────────────────────────────────
  Future<void> cargarTrabajosTecnico() async {
    _isLoading = true;
    notifyListeners();

    _trabajosTecnico = await _repository.obtenerTrabajosTecnico();

    _isLoading = false;
    notifyListeners();
  }

  // ─────────────────────────────────────────────
  // TÉCNICO → FINALIZAR TRABAJO
  // ─────────────────────────────────────────────
  Future<void> finalizarTrabajo(int solicitudId) async {
    _isLoading = true;
    notifyListeners();

    await _repository.finalizarTrabajo(solicitudId);
    await cargarTrabajosTecnico();

    _isLoading = false;
    notifyListeners();
  }

  Future<String> obtenerImagenFirmada(String path) async {
    return await _repository.obtenerImagenFirmada(path);
  }

  // ─────────────────────────────────────────────
  // TÉCNICO → INICIAR TRABAJO
  // ─────────────────────────────────────────────
  Future<void> iniciarTrabajo(int solicitudId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.iniciarTrabajo(solicitudId);

      // refrescar trabajos del técnico
      await cargarTrabajosTecnico();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
