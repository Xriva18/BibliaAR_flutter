import 'package:biblia_ar_flutter/core/di/repository_provider.dart';
import 'package:biblia_ar_flutter/data/models/perfil.dart';
import 'package:biblia_ar_flutter/data/models/resultado_actividad.dart';
import 'package:biblia_ar_flutter/data/models/tipo_usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Panel docente para consultar progreso local por perfil de nino, variables v_perfilSeleccionado y v_resultados, 2026-07-23
class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  List<Perfil> vPerfilesNinos = [];
  Perfil? vPerfilSeleccionado;
  List<ResultadoActividad> vResultados = [];
  bool vCargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPerfiles();
  }

  Future<void> _cargarPerfiles() async {
    final repos = context.read<RepositoryProvider>();
    final perfiles = await repos.perfilRepository.obtenerPorTipo(TipoUsuario.nino.value);
    setState(() {
      vPerfilesNinos = perfiles;
      vCargando = false;
    });
  }

  Future<void> _seleccionarPerfil(Perfil perfil) async {
    final repos = context.read<RepositoryProvider>();
    final resultados = await repos.progresoRepository.obtenerResultadosPorPerfil(perfil.id!);
    setState(() {
      vPerfilSeleccionado = perfil;
      vResultados = resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel docente')),
      body: vCargando
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: vPerfilesNinos.length,
                    itemBuilder: (context, index) {
                      final perfil = vPerfilesNinos[index];
                      return ListTile(
                        selected: vPerfilSeleccionado?.id == perfil.id,
                        title: Text(perfil.nombre),
                        onTap: () => _seleccionarPerfil(perfil),
                      );
                    },
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  flex: 3,
                  child: vPerfilSeleccionado == null
                      ? const Center(child: Text('Selecciona un perfil de niño'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: vResultados.length,
                          itemBuilder: (context, index) {
                            final resultado = vResultados[index];
                            return ListTile(
                              title: Text('Actividad #${resultado.actividadId}'),
                              subtitle: Text(
                                'Intento ${resultado.intentoNumero} · ${resultado.resultado}',
                              ),
                              trailing: Text(
                                '${resultado.fecha.day}/${resultado.fecha.month}',
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
