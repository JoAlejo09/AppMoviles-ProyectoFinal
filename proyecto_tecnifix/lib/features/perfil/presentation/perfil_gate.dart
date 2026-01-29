import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/perfil_controller.dart';
import '../../tecnico/controller/tecnico_controller.dart';
import 'completar_perfil_page.dart';
import '../../tecnico/presentation/completar_tecnico_detalle_page.dart';
import '../../home/home_gate.dart';

class PerfilGate extends StatefulWidget {
  const PerfilGate({super.key});

  @override
  State<PerfilGate> createState() => _PerfilGateState();
}

class _PerfilGateState extends State<PerfilGate> {
  bool _perfilCargado = false;
  bool _tecnicoCargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final perfilController = context.read<PerfilController>();

    // 🔹 Cargar perfil base UNA sola vez
    if (!_perfilCargado) {
      perfilController.cargarPerfil();
      _perfilCargado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final perfilController = context.watch<PerfilController>();

    // ⏳ Cargando perfil
    if (perfilController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final perfil = perfilController.perfil;

    // 1️⃣ PERFIL BASE NO COMPLETO → formulario base
    if (!perfilController.perfilCompleto) {
      _tecnicoCargado = false; // reset por si cambia rol
      return const CompletarPerfilPage();
    }

    // 2️⃣ SI ES TÉCNICO → validar detalle técnico
    if (perfil != null && perfil['rol'] == 'tecnico') {
      final tecnicoController = context.watch<TecnicoController>();

      // Cargar detalle técnico UNA sola vez
      if (!_tecnicoCargado) {
        tecnicoController.cargarDetalle();
        _tecnicoCargado = true;
      }

      // ⏳ Cargando detalle técnico
      if (tecnicoController.isLoading) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      // 🧑‍🔧 Detalle técnico incompleto
      if (!tecnicoController.detalleCompleto) {
        return const CompletarTecnicoDetallePage();
      }
    }

    // 3️⃣ TODO COMPLETO → HOME
    return const HomeGate();
  }
}
