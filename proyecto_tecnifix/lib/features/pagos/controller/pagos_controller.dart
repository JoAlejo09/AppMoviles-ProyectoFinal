import 'package:flutter/material.dart';
import '../data/pagos_repository.dart';

class PagosController extends ChangeNotifier {
  final PagosRepository _repository;

  PagosController(this._repository);

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> pagarSolicitud(int solicitudId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _repository.pagarSolicitud(solicitudId: solicitudId);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
