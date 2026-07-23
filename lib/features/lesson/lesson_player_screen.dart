import 'package:biblia_ar_flutter/core/feedback/multimodal_feedback.dart';
import 'package:biblia_ar_flutter/core/routing/route_names.dart';
import 'package:biblia_ar_flutter/features/profiles/perfil_provider.dart';
import 'package:biblia_ar_flutter/features/lesson/lesson_player_provider.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_button.dart';
import 'package:biblia_ar_flutter/shared/widgets/floating_lse_player.dart';
import 'package:biblia_ar_flutter/shared/widgets/pictogram_bar.dart';
import 'package:biblia_ar_flutter/shared/widgets/subtitle_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Reproductor multimedia de leccion con LSE flotante, subtitulos y pictogramas, sin nuevas variables, 2026-07-23
class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({super.key});

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      final perfil = context.read<PerfilProvider>().vPerfilActivo;
      if (perfil?.id != null) {
        await context.read<ConfiguracionProvider>().cargar(perfil!.id!);
      }
      if (!mounted) {
        return;
      }
      await context.read<LessonPlayerProvider>().cargarLeccion(
            perfilId: perfil?.id,
          );
    });
  }

  Future<void> _finalizarLeccion() async {
    final perfil = context.read<PerfilProvider>().vPerfilActivo;
    if (perfil?.id != null) {
      await context.read<LessonPlayerProvider>().completarLeccion(perfil!.id!);
    }
    if (!mounted) {
      return;
    }
    await MultimodalFeedback.success(context, mensaje: '¡Actividad lista!');
    if (!mounted) {
      return;
    }
    Navigator.pushNamed(context, RouteNames.activities);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LessonPlayerProvider>();
    final configuracion = context.watch<ConfiguracionProvider>().vConfiguracion;
    final fragmento = provider.fragmentoActual;

    if (provider.vCargando || fragmento == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.vLeccion?.titulo ?? 'Lección'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    height: 220,
                    child: ColoredBox(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.landscape,
                            size: 72,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fragmento.titulo,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              fragmento.descripcion,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (configuracion?.subtitulosActivos ?? true)
                  SubtitleOverlay(vTexto: fragmento.textoSubtitulo),
                const SizedBox(height: 12),
                if (configuracion?.pictogramasActivos ?? true)
                  PictogramBar(vPictogramas: fragmento.pictogramas),
                const SizedBox(height: 80),
                Row(
                  children: [
                    Expanded(
                      child: BiarButton(
                        label: 'Anterior',
                        icon: Icons.skip_previous,
                        expanded: false,
                        onPressed: provider.esPrimerFragmento
                            ? null
                            : provider.fragmentoAnterior,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: BiarButton(
                        label: provider.vReproduciendo ? 'Pausar' : 'Reproducir',
                        icon: provider.vReproduciendo ? Icons.pause : Icons.play_arrow,
                        expanded: false,
                        onPressed: provider.alternarReproduccion,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: BiarButton(
                        label: 'Siguiente',
                        icon: Icons.skip_next,
                        expanded: false,
                        onPressed: provider.esUltimoFragmento
                            ? null
                            : provider.fragmentoSiguiente,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (provider.esUltimoFragmento)
                  BiarButton(
                    label: '¡Actividad lista!',
                    icon: Icons.celebration,
                    onPressed: _finalizarLeccion,
                  ),
              ],
            ),
          ),
          if (configuracion?.lseActivo ?? true)
            FloatingLsePlayer(
              vTitulo: fragmento.titulo,
              vDescripcion: fragmento.descripcion,
              vVideoAsset: fragmento.videoLseAsset,
            ),
        ],
      ),
    );
  }
}
