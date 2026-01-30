import 'package:flutter/material.dart';
import 'package:proyecto_tecnifix/features/home/tecnico/tabs/tecnico_perfil_page.dart';
import 'package:proyecto_tecnifix/features/home/tecnico/tabs/tecnico_trabajos_page.dart';

import '../../solicitudes/presentation/tecnico/solicitudes_disponibles_page.dart';

class HomeTecnicoPage extends StatefulWidget {
  const HomeTecnicoPage({super.key});

  @override
  State<HomeTecnicoPage> createState() => _HomeTecnicoPageState();
}

class _HomeTecnicoPageState extends State<HomeTecnicoPage> {
  int _index = 0;

  final _pages = const [
    SolicitudesDisponiblesPage(),
    TecnicoTrabajosPage(),
    TecnicoPerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Disponibles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Mis trabajos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_accessibility_outlined),
            label: 'Perfils',
          ),
        ],
      ),
    );
  }
}
