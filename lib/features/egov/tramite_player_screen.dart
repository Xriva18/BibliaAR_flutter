import 'package:biblia_ar_flutter/core/di/repository_provider.dart';
import 'package:biblia_ar_flutter/core/feedback/multimodal_feedback.dart';
import 'package:biblia_ar_flutter/core/routing/route_names.dart';
import 'package:biblia_ar_flutter/features/lesson/lesson_player_provider.dart';
import 'package:biblia_ar_flutter/features/profiles/perfil_provider.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_error_view.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_loading_view.dart';
import 'package:biblia_ar_flutter/shared/widgets/content_player_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Reproductor de tramite eGovernment reutilizando ContentPlayerScaffold, sin nuevas variables, 2026-07-23
class TramitePlayerScreen extends StatefulWidget {
  const TramitePlayerScreen({super.key, required this.vLeccionId});

  final int vLeccionId;

  @override
  State<TramitePlayerScreen> createState() => _TramitePlayerScreenState();
}

class _TramitePlayerScreenState extends State<TramitePlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargar());
  }

  Future<void> _cargar() async {
    if (!mounted) return;
    final perfil = context.read<PerfilProvider>().vPerfilActivo;
    if (perfil?.id != null) {
      await context.read<ConfiguracionProvider>().cargar(perfil!.id!);
    }
    if (!mounted) return;

    final repos = context.read<RepositoryProvider>();
    final leccion = await repos.leccionRepository.obtenerPorId(widget.vLeccionId);
    final path = leccion?.contenidoMultimediaPath ??
        'assets/lessons/certificado_residencia/fragments.json';

    if (!mounted) return;
    await context.read<LessonPlayerProvider>().cargarLeccionPorPath(
          leccionId: widget.vLeccionId,
          assetsPath: path,
          perfilId: perfil?.id,
        );
  }

  Future<void> _finalizar() async {
    final perfil = context.read<PerfilProvider>().vPerfilActivo;
    if (perfil?.id != null) {
      await context.read<LessonPlayerProvider>().completarLeccion(perfil!.id!);
    }
    if (!mounted) return;
    await MultimodalFeedback.success(context, mensaje: '¡Trámite comprendido!');
    if (!mounted) return;
    Navigator.pushNamed(
      context,
      RouteNames.tramiteActividad,
      arguments: widget.vLeccionId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LessonPlayerProvider>();
    final configuracion = context.watch<ConfiguracionProvider>().vConfiguracion;
    final fragmento = provider.fragmentoActual;

    if (provider.vCargando) {
      return const Scaffold(body: BiarLoadingView(vMensaje: 'Cargando trámite...'));
    }
    if (provider.vError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trámite')),
        body: BiarErrorView(vMensaje: provider.vError!, onReintentar: _cargar),
      );
    }
    if (fragmento == null) {
      return const Scaffold(body: BiarLoadingView());
    }

    return ContentPlayerScaffold(
      vTitulo: provider.vLeccion?.titulo ?? 'Trámite',
      vFragmento: fragmento,
      vIndiceActual: provider.vIndiceFragmento,
      vTotalFragmentos: provider.vFragmentos.length,
      vReproduciendo: provider.vReproduciendo,
      vConfiguracion: configuracion,
      vEsUltimoFragmento: provider.esUltimoFragmento,
      vEsPrimerFragmento: provider.esPrimerFragmento,
      vTextoBotonFinal: 'Continuar al checklist',
      onAnterior: provider.fragmentoAnterior,
      onSiguiente: provider.fragmentoSiguiente,
      onAlternarReproduccion: provider.alternarReproduccion,
      onFinalizar: _finalizar,
    );
  }
}
