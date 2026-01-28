import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../controllers/perfil_controller.dart';
import '../../../../core/services/location_service.dart';
import 'perfil_mapa_page.dart';

class PerfilFormPage extends StatefulWidget {
  const PerfilFormPage({super.key});

  @override
  State<PerfilFormPage> createState() => _PerfilFormPageState();
}

class _PerfilFormPageState extends State<PerfilFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _celularController = TextEditingController();

  String? _rol;
  double? _latitud;
  double? _longitud;

  @override
  void initState() {
    super.initState();
    final perfil = context.read<PerfilController>().perfil;

    if (perfil != null) {
      _nombreController.text = perfil.nombre ?? '';
      _apellidoController.text = perfil.apellido ?? '';
      _celularController.text = perfil.celular ?? '';
      _rol = perfil.rol;
      _latitud = perfil.latitud;
      _longitud = perfil.longitud;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _celularController.dispose();
    super.dispose();
  }

  Future<void> _obtenerUbicacion() async {
    try {
      final position = await LocationService.getCurrentPosition();

      final selectedPosition = await Navigator.push<LatLng>(
        context,
        MaterialPageRoute(
          builder: (_) => PerfilMapaPage(
            initialPosition: LatLng(position.latitude, position.longitude),
          ),
        ),
      );

      if (selectedPosition != null) {
        setState(() {
          _latitud = selectedPosition.latitude;
          _longitud = selectedPosition.longitude;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _guardarPerfil() async {
    if (!_formKey.currentState!.validate()) return;

    if (_rol == null || _latitud == null || _longitud == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos obligatorios')),
      );
      return;
    }

    final perfilController = context.read<PerfilController>();

    await perfilController.actualizarPerfil(
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      celular: _celularController.text.trim().isEmpty
          ? null
          : _celularController.text.trim(),
      rol: _rol!,
      latitud: _latitud!,
      longitud: _longitud!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final perfilController = context.watch<PerfilController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Completa tu perfil'),
        automaticallyImplyLeading: false, // 🚫 no salir
      ),
      body: perfilController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Nombre
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obligatorio'
                          : null,
                    ),

                    const SizedBox(height: 12),

                    // 👤 Apellido
                    TextFormField(
                      controller: _apellidoController,
                      decoration: const InputDecoration(
                        labelText: 'Apellido',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Campo obligatorio'
                          : null,
                    ),

                    const SizedBox(height: 12),

                    // 📞 Celular (opcional)
                    TextFormField(
                      controller: _celularController,
                      decoration: const InputDecoration(
                        labelText: 'Celular (opcional)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 20),

                    // 🎭 Rol
                    const Text(
                      'Selecciona tu rol',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text('Cliente'),
                      value: 'cliente',
                      groupValue: _rol,
                      onChanged: (value) {
                        setState(() => _rol = value);
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Técnico'),
                      value: 'tecnico',
                      groupValue: _rol,
                      onChanged: (value) {
                        setState(() => _rol = value);
                      },
                    ),

                    const SizedBox(height: 20),

                    // Ubicación
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(
                          _latitud == null
                              ? 'Seleccionar ubicación'
                              : 'Ubicación seleccionada',
                        ),
                        subtitle: _latitud != null
                            ? Text(
                                'Lat: ${_latitud!.toStringAsFixed(5)}, '
                                'Lng: ${_longitud!.toStringAsFixed(5)}',
                              )
                            : null,
                        trailing: ElevatedButton(
                          onPressed: _obtenerUbicacion,
                          child: const Text('Mapa'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (_latitud != null && _longitud != null)
                      Container(
                        height: 150,
                        margin: const EdgeInsets.only(top: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(_latitud!, _longitud!),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('perfil'),
                                position: LatLng(_latitud!, _longitud!),
                              ),
                            },
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            liteModeEnabled: true,
                          ),
                        ),
                      ),
                    // Guardar
                    ElevatedButton.icon(
                      onPressed: perfilController.isLoading
                          ? null
                          : _guardarPerfil,
                      icon: perfilController.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            )
                          : Icon(Icons.save),
                      label: Text(
                        perfilController.isLoading
                            ? 'Guardando'
                            : 'Guardar y continuar',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
