import 'package:flutter/material.dart';

import 'tabs/tecnico_trabajos_page.dart';
import 'tabs/tecnico_mapa_page.dart';
import 'tabs/tecnico_perfil_page.dart';

class HomeTecnicoPage extends StatefulWidget {
  const HomeTecnicoPage({super.key});

  @override
  State<HomeTecnicoPage> createState() => _HomeTecnicoPageState();
}

class _HomeTecnicoPageState extends State<HomeTecnicoPage> {
  int _index = 0;

  final _pages = const [
    TecnicoTrabajosPage(),
    TecnicoMapaPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Trabajos'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
