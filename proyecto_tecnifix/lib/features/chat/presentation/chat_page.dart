import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controller/chat_controller.dart';

class ChatPage extends StatefulWidget {
  final int solicitudId;

  const ChatPage({super.key, required this.solicitudId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _mensajeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatController>().cargarMensajes(widget.solicitudId);
  }

  @override
  void dispose() {
    _mensajeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatController>();
    final userId = context.read<ChatController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: chat.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: chat.mensajes.length,
                    itemBuilder: (_, i) {
                      final m = chat.mensajes[i];
                      final esMio =
                          m['emisor_id'] ==
                          Supabase.instance.client.auth.currentUser!.id;

                      return Align(
                        alignment: esMio
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: esMio
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(m['mensaje']),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _mensajeCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_mensajeCtrl.text.trim().isEmpty) return;

                    await chat.enviarMensaje(
                      solicitudId: widget.solicitudId,
                      mensaje: _mensajeCtrl.text.trim(),
                    );

                    _mensajeCtrl.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
