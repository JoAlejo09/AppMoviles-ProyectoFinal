import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/chat_repository.dart';

class ChatController extends ChangeNotifier {
  final ChatRepository _repository;
  final SupabaseClient _client = Supabase.instance.client;

  List<Map<String, dynamic>> mensajes = [];
  bool isLoading = false;

  RealtimeChannel? _channel;

  ChatController(this._repository);

  // ───────── Cargar + escuchar ─────────
  Future<void> iniciarChat(int solicitudId) async {
    isLoading = true;
    notifyListeners();

    mensajes = await _repository.obtenerMensajes(solicitudId);
    _escucharRealtime(solicitudId);

    isLoading = false;
    notifyListeners();
  }

  // ───────── Realtime ─────────
  void _escucharRealtime(int solicitudId) {
    _channel?.unsubscribe();

    _channel = _client.channel('mensajes_$solicitudId');

    _channel!
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'mensajes',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'solicitud_id',
            value: solicitudId,
          ),
          callback: (payload) {
            mensajes.add(payload.newRecord);
            notifyListeners();
          },
        )
        .subscribe();
  }

  // ───────── Enviar mensaje ─────────
  Future<void> enviarMensaje({
    required int solicitudId,
    required String mensaje,
  }) async {
    await _repository.enviarMensaje(solicitudId: solicitudId, mensaje: mensaje);
  }

  // ───────── Limpieza ─────────
  void disposeChat() {
    _channel?.unsubscribe();
    _channel = null;
    mensajes = [];
  }

  @override
  void dispose() {
    disposeChat();
    super.dispose();
  }
}
