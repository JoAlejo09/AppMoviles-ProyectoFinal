import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tecnifix/features/perfil/presentation/editar_perfil_page.dart';

import '../../../perfil/controller/perfil_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ClientePerfilPage extends StatelessWidget {
  const ClientePerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final perfilController = context.watch<PerfilController>();
    final perfil = perfilController.perfil;

    if (perfil == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<PerfilController>().reset();
              context.read<AuthController>().logout();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item('Nombre', perfil['nombre']),
          _item('Apellido', perfil['apellido']),
          _item('Celular', perfil['celular']),
          _item('Provincia', perfil['provincia']),
          _item('Ciudad', perfil['ciudad']),
          _item('Calle', perfil['calle']),
          _item('Rol', perfil['rol']),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Editar perfil'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditarPerfilPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _item(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 5, child: Text(value?.toString() ?? '-')),
        ],
      ),
    );
  }
}
