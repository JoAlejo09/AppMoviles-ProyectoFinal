import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_tecnifix/features/home/tecnico/home_tecnico_page.dart';

import '../perfil/controller/perfil_controller.dart';
import 'cliente/home_cliente_page.dart';

class HomeGate extends StatelessWidget {
  const HomeGate({super.key});

  @override
  Widget build(BuildContext context) {
    final perfil = context.watch<PerfilController>();

    final rol = perfil.perfil?['rol'];

    if (rol == 'tecnico') {
      return HomeTecnicoPage();
    }

    // default: cliente
    return HomeClientePage();
  }
}
