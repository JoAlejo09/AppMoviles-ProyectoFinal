import 'package:flutter/material.dart';
import '../data/chat_repository.dart';

class ChatController extends ChangeNotifier {
  final ChatRepository _repository;

  ChatController(this._repository);

  List<Map<String, dynamic>> mensajes = [];
  bool isLoading = false;

  Future<void> cargarMensajes(int solicitudId) async {
    isLoading = true;
    notifyListeners();

    mensajes = await _repository.obtenerMensajes(solicitudId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> enviarMensaje({
    required int solicitudId,
    required String mensaje,
  }) async {
    await _repository.enviarMensaje(solicitudId: solicitudId, mensaje: mensaje);

    await cargarMensajes(solicitudId);
  }

  void reset() {
    mensajes = [];
    isLoading = false;
    notifyListeners();
  }
}
