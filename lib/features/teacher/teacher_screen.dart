import 'package:biblia_ar_flutter/core/accessibility/biar_design_tokens.dart';
import 'package:biblia_ar_flutter/core/di/repository_provider.dart';
import 'package:biblia_ar_flutter/data/models/perfil.dart';
import 'package:biblia_ar_flutter/data/models/resultado_actividad.dart';
import 'package:biblia_ar_flutter/data/models/tipo_usuario.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_empty_view.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Panel docente mobile-first con lista de ninos y detalle de resultados agrupados, sin nuevas variables, 2026-07-23
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
    if (!mounted) return;
    setState(() {
      vPerfilesNinos = perfiles;
      vCargando = false;
    });
  }

  Future<void> _seleccionarPerfil(Perfil perfil) async {
    final repos = context.read<RepositoryProvider>();
    final resultados = await repos.progresoRepository.obtenerResultadosPorPerfil(perfil.id!);
    if (!mounted) return;
    setState(() {
      vPerfilSeleccionado = perfil;
      vResultados = resultados;
    });
  }

  Map<int, List<ResultadoActividad>> _agruparPorActividad() {
    final mapa = <int, List<ResultadoActividad>>{};
    for (final resultado in vResultados) {
      mapa.putIfAbsent(resultado.actividadId, () => []).add(resultado);
    }
    return mapa;
  }

  Color _colorEstado(String resultado) {
    if (resultado == 'correcto') {
      return Colors.green.shade100;
    }
    return Colors.orange.shade100;
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.sizeOf(context).width;
    final esPantallaAncha = ancho >= 720;

    if (vCargando) {
      return const Scaffold(
        body: BiarLoadingView(vMensaje: 'Cargando perfiles...'),
      );
    }

    if (!esPantallaAncha) {
      return Scaffold(
        appBar: AppBar(
          title: Text(vPerfilSeleccionado == null ? 'Panel docente' : vPerfilSeleccionado!.nombre),
          leading: vPerfilSeleccionado != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() {
                    vPerfilSeleccionado = null;
                    vResultados = [];
                  }),
                )
              : null,
        ),
        body: vPerfilSeleccionado == null
            ? _buildListaNinos()
            : _buildDetalleResultados(),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Panel docente')),
      body: Row(
        children: [
          SizedBox(width: 280, child: _buildListaNinos()),
          const VerticalDivider(width: 1),
          Expanded(child: _buildDetalleResultados()),
        ],
      ),
    );
  }

  Widget _buildListaNinos() {
    if (vPerfilesNinos.isEmpty) {
      return const BiarEmptyView(
        vMensaje: 'No hay perfiles de niño registrados.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(BiarSpacing.md),
      itemCount: vPerfilesNinos.length,
      separatorBuilder: (_, __) => const SizedBox(height: BiarSpacing.sm),
      itemBuilder: (context, index) {
        final perfil = vPerfilesNinos[index];
        final seleccionado = vPerfilSeleccionado?.id == perfil.id;
        return ListTile(
          selected: seleccionado,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BiarRadius.md),
          ),
          leading: Icon(
            BiarModuleIcons.historias,
            color: seleccionado ? Theme.of(context).colorScheme.primary : null,
          ),
          title: Text(perfil.nombre),
          subtitle: const Text('Ver progreso y actividades'),
          onTap: () => _seleccionarPerfil(perfil),
        );
      },
    );
  }

  Widget _buildDetalleResultados() {
    if (vPerfilSeleccionado == null) {
      return const Center(
        child: Text('Selecciona un perfil de niño para ver resultados'),
      );
    }

    if (vResultados.isEmpty) {
      return BiarEmptyView(
        vMensaje: 'Sin intentos registrados para ${vPerfilSeleccionado!.nombre}.',
      );
    }

    final agrupados = _agruparPorActividad();

    return ListView.builder(
      padding: const EdgeInsets.all(BiarSpacing.md),
      itemCount: agrupados.length,
      itemBuilder: (context, index) {
        final actividadId = agrupados.keys.elementAt(index);
        final intentos = agrupados[actividadId]!;
        final ultimo = intentos.last;

        return Card(
          margin: const EdgeInsets.only(bottom: BiarSpacing.sm),
          child: ListTile(
            title: Text('Actividad #$actividadId'),
            subtitle: Text('${intentos.length} intento(s) registrados'),
            trailing: Chip(
              label: Text(ultimo.resultado),
              backgroundColor: _colorEstado(ultimo.resultado),
            ),
          ),
        );
      },
    );
  }
}
