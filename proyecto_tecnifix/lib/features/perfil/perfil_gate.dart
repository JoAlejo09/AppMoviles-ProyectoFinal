import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/perfil_controller.dart';
import '../tecnico/controller/tecnico_controller.dart';
import 'presentation/completar_perfil_page.dart';
import '../tecnico/presentation/completar_tecnico_detalle_page.dart';
import '../home/home_gate.dart';

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

    if (!_perfilCargado) {
      _perfilCargado = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<PerfilController>().cargarPerfil();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final perfilController = context.watch<PerfilController>();

    // ⏳ Cargando perfil base
    if (perfilController.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final perfil = perfilController.perfil;

    // 1️⃣ PERFIL BASE INCOMPLETO
    if (!perfilController.perfilCompleto) {
      _tecnicoCargado = false; // reset por si cambia rol
      return const CompletarPerfilPage();
    }

    // 2️⃣ PERFIL TÉCNICO → validar detalle técnico
    if (perfil != null && perfil['rol'] == 'tecnico') {
      final tecnicoController = context.watch<TecnicoController>();

      if (!_tecnicoCargado) {
        _tecnicoCargado = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context.read<TecnicoController>().cargarDetalle();
        });
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
