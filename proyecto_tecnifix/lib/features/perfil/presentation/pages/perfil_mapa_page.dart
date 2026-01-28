import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PerfilMapaPage extends StatefulWidget {
  final LatLng initialPosition;
  const PerfilMapaPage({super.key, required this.initialPosition});

  @override
  State<PerfilMapaPage> createState() => _PerfilMapaPageState();
}

class _PerfilMapaPageState extends State<PerfilMapaPage> {
  LatLng? _selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona tu ubicacion:')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.initialPosition,
          zoom: 16,
        ),
        onTap: (position) {
          setState(() => _selectedPosition = position);
        },
        markers: _selectedPosition == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('selected'),
                  position: _selectedPosition!,
                ),
              },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _selectedPosition == null
            ? null
            : () => Navigator.pop(context, _selectedPosition),
        label: const Text('Confirmar'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
