import 'package:biblia_ar_flutter/core/accessibility/biar_design_tokens.dart';
import 'package:biblia_ar_flutter/core/accessibility/biar_theme.dart';
import 'package:biblia_ar_flutter/core/routing/route_names.dart';
import 'package:biblia_ar_flutter/core/session/usage_timer_service.dart';
import 'package:biblia_ar_flutter/data/models/tipo_usuario.dart';
import 'package:biblia_ar_flutter/features/auth/auth_provider.dart';
import 'package:biblia_ar_flutter/features/profiles/perfil_provider.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_menu_card.dart';
import 'package:biblia_ar_flutter/shared/widgets/usage_alert_listener.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Home rediseñado con grid de BiarMenuCard, badge de rol y acceso a tramites, sin nuevas variables, 2026-07-23
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<UsageTimerService>().start();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final perfil = context.read<PerfilProvider>().vPerfilActivo;
      if (perfil?.id != null) {
        await context.read<ConfiguracionProvider>().cargar(perfil!.id!);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final timer = context.read<UsageTimerService>();
    if (state == AppLifecycleState.paused) {
      timer.pause();
    } else if (state == AppLifecycleState.resumed) {
      timer.resume();
    }
  }

  Future<void> _cerrarSesion() async {
    await context.read<PerfilProvider>().cerrarSesionPerfil();
    if (!mounted) return;
    await context.read<AuthProvider>().cerrarSesion();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final perfil = context.watch<PerfilProvider>().vPerfilActivo;
    final esDocente = perfil?.tipoUsuario == TipoUsuario.docente;
    final rolLabel = esDocente ? 'Docente' : 'Niño';

    return UsageAlertListener(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hola, ${perfil?.nombre ?? 'Usuario'}'),
          actions: [
            IconButton(
              tooltip: 'Cerrar sesión',
              onPressed: _cerrarSesion,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(BiarSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '¿Qué quieres hacer hoy?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Chip(label: Text(rolLabel)),
                ],
              ),
              const SizedBox(height: BiarSpacing.md),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: BiarSpacing.sm,
                  mainAxisSpacing: BiarSpacing.sm,
                  childAspectRatio: 0.95,
                  children: [
                    BiarMenuCard(
                      vTitulo: 'Historias',
                      vSubtitulo: 'El Buen Samaritano',
                      vIcono: BiarModuleIcons.historias,
                      onTap: () => Navigator.pushNamed(context, RouteNames.lesson),
                    ),
                    BiarMenuCard(
                      vTitulo: 'Actividades',
                      vSubtitulo: 'Juegos de repaso',
                      vIcono: BiarModuleIcons.actividades,
                      onTap: () => Navigator.pushNamed(context, RouteNames.activities),
                    ),
                    BiarMenuCard(
                      vTitulo: 'Trámites',
                      vSubtitulo: 'Trámites accesibles',
                      vIcono: BiarModuleIcons.tramites,
                      vColor: BiarTheme.infoColor,
                      onTap: () => Navigator.pushNamed(context, RouteNames.tramites),
                    ),
                    BiarMenuCard(
                      vTitulo: 'Progreso',
                      vSubtitulo: 'Tu avance',
                      vIcono: BiarModuleIcons.progreso,
                      onTap: () => Navigator.pushNamed(context, RouteNames.progress),
                    ),
                    BiarMenuCard(
                      vTitulo: 'Accesibilidad',
                      vSubtitulo: 'LSE, audio, subtítulos',
                      vIcono: BiarModuleIcons.accesibilidad,
                      onTap: () => Navigator.pushNamed(context, RouteNames.settings),
                    ),
                    if (esDocente)
                      BiarMenuCard(
                        vTitulo: 'Panel docente',
                        vSubtitulo: 'Seguimiento local',
                        vIcono: BiarModuleIcons.docente,
                        onTap: () => Navigator.pushNamed(context, RouteNames.teacher),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
