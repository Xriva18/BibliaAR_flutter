import 'package:biblia_ar_flutter/core/routing/route_names.dart';
import 'package:biblia_ar_flutter/core/session/usage_timer_service.dart';
import 'package:biblia_ar_flutter/data/models/tipo_usuario.dart';
import 'package:biblia_ar_flutter/features/profiles/perfil_provider.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_button.dart';
import 'package:biblia_ar_flutter/shared/widgets/usage_alert_listener.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Menu principal accesible con navegacion de maximo dos niveles, sin nuevas variables, 2026-07-23
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
    if (!mounted) {
      return;
    }
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.profiles, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final perfil = context.watch<PerfilProvider>().vPerfilActivo;
    final esDocente = perfil?.tipoUsuario == TipoUsuario.docente;

    return UsageAlertListener(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hola, ${perfil?.nombre ?? 'Usuario'}'),
          actions: [
            IconButton(
              tooltip: 'Cambiar perfil',
              onPressed: _cerrarSesion,
              icon: const Icon(Icons.switch_account),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '¿Qué quieres hacer hoy?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              BiarButton(
                label: 'Historias bíblicas',
                icon: Icons.auto_stories,
                onPressed: () => Navigator.pushNamed(context, RouteNames.lesson),
              ),
              const SizedBox(height: 12),
              BiarButton(
                label: 'Actividades',
                icon: Icons.extension,
                onPressed: () => Navigator.pushNamed(context, RouteNames.activities),
              ),
              const SizedBox(height: 12),
              BiarButton(
                label: 'Mi progreso',
                icon: Icons.insights,
                onPressed: () => Navigator.pushNamed(context, RouteNames.progress),
              ),
              const SizedBox(height: 12),
              BiarButton(
                label: 'Accesibilidad',
                icon: Icons.accessibility_new,
                onPressed: () => Navigator.pushNamed(context, RouteNames.settings),
              ),
              if (esDocente) ...[
                const SizedBox(height: 12),
                BiarButton(
                  label: 'Panel docente',
                  icon: Icons.school,
                  onPressed: () => Navigator.pushNamed(context, RouteNames.teacher),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
