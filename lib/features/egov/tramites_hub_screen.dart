import 'package:biblia_ar_flutter/core/accessibility/biar_design_tokens.dart';
import 'package:biblia_ar_flutter/core/di/repository_provider.dart';
import 'package:biblia_ar_flutter/core/routing/route_names.dart';
import 'package:biblia_ar_flutter/data/models/leccion.dart';
import 'package:biblia_ar_flutter/data/models/leccion_categoria.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_empty_view.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_loading_view.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_menu_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Hub de tramites accesibles eGovernment con listado local por categoria, variable v_tramites, 2026-07-23
class TramitesHubScreen extends StatefulWidget {
  const TramitesHubScreen({super.key});

  @override
  State<TramitesHubScreen> createState() => _TramitesHubScreenState();
}

class _TramitesHubScreenState extends State<TramitesHubScreen> {
  List<Leccion> vTramites = [];
  bool vCargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => vCargando = true);
    final repos = context.read<RepositoryProvider>();
    final tramites =
        await repos.leccionRepository.obtenerPorCategoria(LeccionCategoria.tramite);
    if (!mounted) return;
    setState(() {
      vTramites = tramites;
      vCargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trámites accesibles')),
      body: vCargando
          ? const BiarLoadingView(vMensaje: 'Cargando trámites...')
          : vTramites.isEmpty
              ? BiarEmptyView(
                  vMensaje: 'No hay trámites disponibles offline.',
                  onAccion: _cargar,
                  vAccionLabel: 'Reintentar',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(BiarSpacing.md),
                  itemCount: vTramites.length,
                  separatorBuilder: (_, __) => const SizedBox(height: BiarSpacing.sm),
                  itemBuilder: (context, index) {
                    final tramite = vTramites[index];
                    return BiarMenuCard(
                      vTitulo: tramite.titulo,
                      vSubtitulo: tramite.referenciaBiblica,
                      vIcono: BiarModuleIcons.tramites,
                      onTap: () => Navigator.pushNamed(
                        context,
                        RouteNames.tramite,
                        arguments: tramite.id,
                      ),
                    );
                  },
                ),
    );
  }
}
