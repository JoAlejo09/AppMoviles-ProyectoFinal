import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/tecnico_controller.dart';

class CompletarTecnicoDetallePage extends StatefulWidget {
  const CompletarTecnicoDetallePage({super.key});

  @override
  State<CompletarTecnicoDetallePage> createState() =>
      _CompletarTecnicoDetallePageState();
}

class _CompletarTecnicoDetallePageState
    extends State<CompletarTecnicoDetallePage> {
  final _formKey = GlobalKey<FormState>();

  final _especialidadCtrl = TextEditingController();
  final _experienciaCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();

  @override
  void dispose() {
    _especialidadCtrl.dispose();
    _experienciaCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final tecnico = context.read<TecnicoController>();

    await tecnico.guardarDetalle(
      especialidad: _especialidadCtrl.text.trim(),
      experienciaAnios: int.parse(_experienciaCtrl.text),
      descripcion: _descripcionCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tecnico = context.watch<TecnicoController>();

    if (tecnico.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Datos del técnico')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _especialidadCtrl,
              decoration: const InputDecoration(labelText: 'Especialidad'),
              validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
            ),
            TextFormField(
              controller: _experienciaCtrl,
              decoration: const InputDecoration(
                labelText: 'Años de experiencia',
              ),
              keyboardType: TextInputType.number,
              validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
            ),
            TextFormField(
              controller: _descripcionCtrl,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _guardar,
              child: const Text('Guardar y continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
