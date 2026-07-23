import 'package:biblia_ar_flutter/core/di/repository_provider.dart';
import 'package:biblia_ar_flutter/data/models/estado_progreso.dart';
import 'package:biblia_ar_flutter/data/models/leccion.dart';
import 'package:biblia_ar_flutter/data/models/progreso.dart';
import 'package:biblia_ar_flutter/features/profiles/perfil_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Pantalla de progreso local del nino con lecciones completadas, sin nuevas variables, 2026-07-23
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<Leccion> vLecciones = [];
  List<Progreso> vProgresos = [];
  bool vCargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final repos = context.read<RepositoryProvider>();
    final perfil = context.read<PerfilProvider>().vPerfilActivo;
    if (perfil?.id == null) {
      return;
    }

    final lecciones = await repos.leccionRepository.obtenerTodas();
    final progresos = await repos.progresoRepository.obtenerPorPerfil(perfil!.id!);

    setState(() {
      vLecciones = lecciones;
      vProgresos = progresos;
      vCargando = false;
    });
  }

  String _estadoLeccion(int leccionId) {
    final progreso = vProgresos.where((p) => p.leccionId == leccionId).toList();
    if (progreso.isEmpty) {
      return 'No iniciada';
    }
    switch (progreso.first.estado) {
      case EstadoProgreso.completada:
        return 'Completada';
      case EstadoProgreso.enCurso:
        return 'En curso';
      case EstadoProgreso.noIniciada:
        return 'No iniciada';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi progreso')),
      body: vCargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vLecciones.length,
              itemBuilder: (context, index) {
                final leccion = vLecciones[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.auto_stories),
                    title: Text(leccion.titulo),
                    subtitle: Text(leccion.referenciaBiblica),
                    trailing: Text(_estadoLeccion(leccion.id!)),
                  ),
                );
              },
            ),
    );
  }
}
