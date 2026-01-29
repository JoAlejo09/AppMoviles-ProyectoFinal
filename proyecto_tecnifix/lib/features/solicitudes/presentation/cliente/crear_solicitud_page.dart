import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../controller/solicitudes_controller.dart';
import '../../../perfil/controller/perfil_controller.dart';
import '../../../tecnico/data/tecnico_repository.dart';
import '../../data/solicitud_imagen_repository.dart';
import '../../../../core/services/supabase_service.dart';

class CrearSolicitudPage extends StatefulWidget {
  const CrearSolicitudPage({super.key});

  @override
  State<CrearSolicitudPage> createState() => _CrearSolicitudPageState();
}

class _CrearSolicitudPageState extends State<CrearSolicitudPage> {
  final _formKey = GlobalKey<FormState>();

  int? _servicioId;
  final _problemaCtrl = TextEditingController();
  final _detallesCtrl = TextEditingController();

  // ───── Técnicos ─────
  String? _tecnicoSeleccionadoId;
  List<Map<String, dynamic>> _tecnicos = [];
  bool _cargandoTecnicos = false;

  // ───── Imágenes ─────
  final List<File> _imagenes = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _problemaCtrl.dispose();
    _detallesCtrl.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // Cargar TOP 5 técnicos
  // ─────────────────────────────────────────────
  Future<void> _cargarTecnicos() async {
    final perfil = context.read<PerfilController>().perfil;
    if (perfil == null) return;

    setState(() => _cargandoTecnicos = true);

    final repo = TecnicoRepository(SupabaseService.client);

    final data = await repo.obtenerTopTecnicos(
      lat: perfil['latitud'],
      lng: perfil['longitud'],
    );

    setState(() {
      _tecnicos = data;
      _cargandoTecnicos = false;
    });
  }

  // ─────────────────────────────────────────────
  // Seleccionar imagen (cámara o galería)
  // ─────────────────────────────────────────────
  Future<void> _seleccionarImagen() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (picked != null) {
      setState(() {
        _imagenes.add(File(picked.path));
      });
    }
  }

  // ─────────────────────────────────────────────
  // Crear solicitud + subir imágenes
  // ─────────────────────────────────────────────
  Future<void> _crearSolicitud() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<SolicitudesController>();

    // 1️⃣ Crear solicitud
    final solicitudId = await controller.crearSolicitud(
      servicioId: _servicioId!,
      problema: _problemaCtrl.text.trim(),
      detalles: _detallesCtrl.text.trim(),
      tecnicoId: _tecnicoSeleccionadoId,
    );

    // 2️⃣ Subir imágenes (si hay)
    if (_imagenes.isNotEmpty) {
      final imgRepo = SolicitudImagenRepository(SupabaseService.client);

      for (final img in _imagenes) {
        final url = await imgRepo.subirImagen(
          file: img,
          solicitudId: solicitudId,
        );

        await imgRepo.guardarImagen(solicitudId: solicitudId, url: url);
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final solicitudes = context.watch<SolicitudesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud')),
      body: solicitudes.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ───────── Servicio ─────────
                  DropdownButtonFormField<int>(
                    value: _servicioId,
                    decoration: const InputDecoration(labelText: 'Servicio'),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text('Electricidad')),
                      DropdownMenuItem(value: 2, child: Text('Plomería')),
                      DropdownMenuItem(value: 3, child: Text('Carpintería')),
                    ],
                    onChanged: (v) {
                      setState(() => _servicioId = v);
                      _cargarTecnicos();
                    },
                    validator: (v) =>
                        v == null ? 'Selecciona un servicio' : null,
                  ),

                  const SizedBox(height: 12),

                  // ───────── Problema ─────────
                  TextFormField(
                    controller: _problemaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Describe el problema',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Campo obligatorio' : null,
                  ),

                  const SizedBox(height: 12),

                  // ───────── Detalles ─────────
                  TextFormField(
                    controller: _detallesCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Detalles (opcional)',
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 20),

                  // ───────── Fotos ─────────
                  const Text(
                    'Fotos del problema',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._imagenes.map(
                        (img) => Stack(
                          children: [
                            Image.file(
                              img,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _imagenes.remove(img));
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _seleccionarImagen,
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.camera_alt),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ───────── Técnicos ─────────
                  const Text(
                    'Técnicos recomendados',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  if (_cargandoTecnicos)
                    const Center(child: CircularProgressIndicator()),

                  if (!_cargandoTecnicos && _tecnicos.isEmpty)
                    const Text(
                      'No hay técnicos cercanos disponibles',
                      style: TextStyle(color: Colors.grey),
                    ),

                  ..._tecnicos.map((t) {
                    final selected = _tecnicoSeleccionadoId == t['id'];

                    return Card(
                      child: ListTile(
                        title: Text('${t['nombre']} ${t['apellido']}'),
                        subtitle: Text(
                          '⭐ ${t['reputacion'].toStringAsFixed(1)} • '
                          '${t['distancia'].toStringAsFixed(1)} km',
                        ),
                        trailing: selected
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _tecnicoSeleccionadoId = t['id'];
                          });
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 28),

                  // ───────── Crear ─────────
                  ElevatedButton(
                    onPressed: _crearSolicitud,
                    child: const Text('Crear solicitud'),
                  ),
                ],
              ),
            ),
    );
  }
}
