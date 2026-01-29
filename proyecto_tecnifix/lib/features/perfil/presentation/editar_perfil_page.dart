import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/perfil_controller.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreCtrl;
  late TextEditingController _apellidoCtrl;
  late TextEditingController _celularCtrl;
  late TextEditingController _provinciaCtrl;
  late TextEditingController _ciudadCtrl;
  late TextEditingController _calleCtrl;

  @override
  void initState() {
    super.initState();

    final perfil = context.read<PerfilController>().perfil!;

    _nombreCtrl = TextEditingController(text: perfil['nombre']);
    _apellidoCtrl = TextEditingController(text: perfil['apellido']);
    _celularCtrl = TextEditingController(text: perfil['celular']);
    _provinciaCtrl = TextEditingController(text: perfil['provincia']);
    _ciudadCtrl = TextEditingController(text: perfil['ciudad']);
    _calleCtrl = TextEditingController(text: perfil['calle']);
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _celularCtrl.dispose();
    _provinciaCtrl.dispose();
    _ciudadCtrl.dispose();
    _calleCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final perfilController = context.read<PerfilController>();
    final perfil = perfilController.perfil!;

    await perfilController.guardarPerfil(
      nombre: _nombreCtrl.text.trim(),
      apellido: _apellidoCtrl.text.trim(),
      celular: _celularCtrl.text.trim(),
      provincia: _provinciaCtrl.text.trim(),
      ciudad: _ciudadCtrl.text.trim(),
      calle: _calleCtrl.text.trim(),
      rol: perfil['rol'], // 🔒 NO se cambia aquí
      lat: perfil['latitud'],
      lng: perfil['longitud'],
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _apellidoCtrl,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _celularCtrl,
                decoration: const InputDecoration(labelText: 'Celular'),
              ),
              TextFormField(
                controller: _provinciaCtrl,
                decoration: const InputDecoration(labelText: 'Provincia'),
              ),
              TextFormField(
                controller: _ciudadCtrl,
                decoration: const InputDecoration(labelText: 'Ciudad'),
              ),
              TextFormField(
                controller: _calleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Calle / Referencia',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardar,
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
