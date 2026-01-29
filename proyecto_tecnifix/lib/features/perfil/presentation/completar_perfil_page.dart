import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/services/location_service.dart';
import '../controller/perfil_controller.dart';
import '../../auth/presentation/controllers/auth_controller.dart';

class CompletarPerfilPage extends StatefulWidget {
  const CompletarPerfilPage({super.key});

  @override
  State<CompletarPerfilPage> createState() => _CompletarPerfilPageState();
}

class _CompletarPerfilPageState extends State<CompletarPerfilPage> {
  final _formKey = GlobalKey<FormState>();

  // ───────── Datos personales ─────────
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _celularCtrl = TextEditingController();

  // ───────── Dirección ─────────
  final _provinciaCtrl = TextEditingController();
  final _ciudadCtrl = TextEditingController();
  final _calleCtrl = TextEditingController();

  // ───────── Rol ─────────
  String? _rol; // cliente | tecnico

  // ───────── Ubicación ─────────
  double? _lat;
  double? _lng;

  GoogleMapController? _mapController;
  Marker? _marker;

  static const LatLng _posicionInicial = LatLng(
    -0.180653,
    -78.467834,
  ); // Quito por defecto

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

  // 📍 Usar ubicación actual (CON SERVICIO)
  Future<void> _usarMiUbicacion() async {
    try {
      final position = await LocationService.getCurrentPosition();
      _setLocation(position.latitude, position.longitude);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _setLocation(double lat, double lng) {
    setState(() {
      _lat = lat;
      _lng = lng;
      _marker = Marker(
        markerId: const MarkerId('ubicacion'),
        position: LatLng(lat, lng),
      );
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (_rol == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un tipo de cuenta')),
      );
      return;
    }

    if (_lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona tu ubicación en el mapa')),
      );
      return;
    }

    final perfil = context.read<PerfilController>();

    await perfil.guardarPerfil(
      nombre: _nombreCtrl.text.trim(),
      apellido: _apellidoCtrl.text.trim(),
      celular: _celularCtrl.text.trim(),
      provincia: _provinciaCtrl.text.trim(),
      ciudad: _ciudadCtrl.text.trim(),
      calle: _calleCtrl.text.trim(),
      rol: _rol!,
      lat: _lat!,
      lng: _lng!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final perfil = context.watch<PerfilController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completa tu perfil'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthController>().logout();
            },
          ),
        ],
      ),
      body: perfil.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ───────── Datos personales ─────────
                  const Text(
                    'Datos personales',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Campo obligatorio' : null,
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _apellidoCtrl,
                    decoration: const InputDecoration(labelText: 'Apellido'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Campo obligatorio' : null,
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _celularCtrl,
                    decoration: const InputDecoration(labelText: 'Celular'),
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 20),

                  // ───────── Dirección ─────────
                  const Text(
                    'Dirección',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _provinciaCtrl,
                    decoration: const InputDecoration(labelText: 'Provincia'),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _ciudadCtrl,
                    decoration: const InputDecoration(labelText: 'Ciudad'),
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _calleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Calle / Referencia',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ───────── Rol ─────────
                  const Text(
                    'Tipo de cuenta',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  RadioListTile<String>(
                    title: const Text('Cliente'),
                    value: 'cliente',
                    groupValue: _rol,
                    onChanged: (value) => setState(() => _rol = value),
                  ),

                  RadioListTile<String>(
                    title: const Text('Técnico'),
                    value: 'tecnico',
                    groupValue: _rol,
                    onChanged: (value) => setState(() => _rol = value),
                  ),

                  const SizedBox(height: 20),

                  // ───────── Ubicación ─────────
                  ElevatedButton.icon(
                    onPressed: _usarMiUbicacion,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Usar mi ubicación'),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 220,
                    child: GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: _posicionInicial,
                        zoom: 14,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      markers: _marker != null ? {_marker!} : {},
                      onTap: (pos) {
                        _setLocation(pos.latitude, pos.longitude);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ───────── Guardar ─────────
                  ElevatedButton(
                    onPressed: _guardar,
                    child: const Text('Guardar perfil'),
                  ),
                ],
              ),
            ),
    );
  }
}
