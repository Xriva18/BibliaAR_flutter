import 'package:biblia_ar_flutter/features/profiles/perfil_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Panel de configuracion sensorial accesible en menos de tres pasos, sin nuevas variables, 2026-07-23
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final perfil = context.read<PerfilProvider>().vPerfilActivo;
      if (perfil?.id != null) {
        await context.read<ConfiguracionProvider>().cargar(perfil!.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final configuracion = context.watch<ConfiguracionProvider>().vConfiguracion;

    if (configuracion == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Accesibilidad')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Intérprete LSE'),
            value: configuracion.lseActivo,
            onChanged: context.read<ConfiguracionProvider>().toggleLse,
          ),
          SwitchListTile(
            title: const Text('Subtítulos'),
            value: configuracion.subtitulosActivos,
            onChanged: context.read<ConfiguracionProvider>().toggleSubtitulos,
          ),
          SwitchListTile(
            title: const Text('Narración de audio'),
            value: configuracion.audioActivo,
            onChanged: context.read<ConfiguracionProvider>().toggleAudio,
          ),
          SwitchListTile(
            title: const Text('Pictogramas'),
            value: configuracion.pictogramasActivos,
            onChanged: context.read<ConfiguracionProvider>().togglePictogramas,
          ),
          const SizedBox(height: 16),
          Text('Velocidad de audio', style: Theme.of(context).textTheme.titleLarge),
          Slider(
            value: configuracion.velocidadAudio,
            min: 0.5,
            max: 2.0,
            divisions: 6,
            label: '${configuracion.velocidadAudio.toStringAsFixed(1)}x',
            onChanged: context.read<ConfiguracionProvider>().actualizarVelocidad,
          ),
          Text('Volumen', style: Theme.of(context).textTheme.titleLarge),
          Slider(
            value: configuracion.volumenAudio,
            min: 0,
            max: 1,
            divisions: 10,
            label: '${(configuracion.volumenAudio * 100).round()}%',
            onChanged: context.read<ConfiguracionProvider>().actualizarVolumen,
          ),
        ],
      ),
    );
  }
}
