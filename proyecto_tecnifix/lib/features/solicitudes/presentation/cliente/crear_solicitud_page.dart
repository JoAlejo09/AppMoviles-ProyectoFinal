import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/services/location_service.dart';
import '../../controller/solicitudes_controller.dart';

class CrearSolicitudPage extends StatefulWidget {
  const CrearSolicitudPage({super.key});

  @override
  State<CrearSolicitudPage> createState() => _CrearSolicitudPageState();
}

class _CrearSolicitudPageState extends State<CrearSolicitudPage> {
  final _formKey = GlobalKey<FormState>();

  final _categoriaCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();

  final List<File> _imagenes = [];
  final ImagePicker _picker = ImagePicker();

  GoogleMapController? _mapController;
  Marker? _marker;
  double? _lat;
  double? _lng;

  static const LatLng _defaultPos = LatLng(-0.180653, -78.467834);

  @override
  void dispose() {
    _categoriaCtrl.dispose();
    _descripcionCtrl.dispose();
    _direccionCtrl.dispose();
    super.dispose();
  }

  // ───────── IMÁGENES (CÁMARA) ─────────
  Future<void> _agregarImagen() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera, // ✅ SOLO CÁMARA
      imageQuality: 75,
      maxWidth: 1280,
    );

    if (picked != null) {
      setState(() {
        _imagenes.add(File(picked.path));
      });
    }
  }

  void _eliminarImagen(int index) {
    setState(() => _imagenes.removeAt(index));
  }

  // ───────── UBICACIÓN ─────────
  Future<void> _usarMiUbicacion() async {
    final pos = await LocationService.getCurrentPosition();
    _setUbicacion(pos.latitude, pos.longitude);
  }

  void _setUbicacion(double lat, double lng) {
    setState(() {
      _lat = lat;
      _lng = lng;
      _marker = Marker(
        markerId: const MarkerId('servicio'),
        position: LatLng(lat, lng),
      );
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
  }

  // ───────── GUARDAR ─────────
  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona la ubicación del servicio')),
      );
      return;
    }

    await context.read<SolicitudesController>().crearSolicitud(
      categoria: _categoriaCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim(),
      direccionServicio: _direccionCtrl.text.trim(),
      latServicio: _lat!,
      lngServicio: _lng!,
      imagenes: _imagenes,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final solicitudes = context.watch<SolicitudesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Crear solicitud')),
      body: solicitudes.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ───────── CATEGORÍA ─────────
                  TextFormField(
                    controller: _categoriaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      hintText: 'Ej: Electricidad, Plomería',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Campo obligatorio' : null,
                  ),

                  const SizedBox(height: 12),

                  // ───────── DESCRIPCIÓN ─────────
                  TextFormField(
                    controller: _descripcionCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Descripción del problema',
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Campo obligatorio' : null,
                  ),

                  const SizedBox(height: 12),

                  // ───────── DIRECCIÓN ─────────
                  TextFormField(
                    controller: _direccionCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Referencia / Dirección',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ───────── IMÁGENES ─────────
                  const Text(
                    'Imágenes del problema',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    children: [
                      ..._imagenes.asMap().entries.map(
                        (e) => Stack(
                          children: [
                            Image.file(
                              e.value,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => _eliminarImagen(e.key),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _agregarImagen,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ───────── UBICACIÓN ─────────
                  ElevatedButton.icon(
                    onPressed: _usarMiUbicacion,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Usar ubicación del servicio'),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 220,
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: _defaultPos,
                        zoom: 14,
                      ),
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      onMapCreated: (c) => _mapController = c,
                      markers: _marker != null ? {_marker!} : {},
                      onTap: (pos) =>
                          _setUbicacion(pos.latitude, pos.longitude),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ───────── GUARDAR ─────────
                  ElevatedButton(
                    onPressed: _guardar,
                    child: const Text('Publicar solicitud'),
                  ),
                ],
              ),
            ),
    );
  }
}
