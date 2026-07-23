import 'package:biblia_ar_flutter/core/routing/route_names.dart';
import 'package:biblia_ar_flutter/data/models/tipo_usuario.dart';
import 'package:biblia_ar_flutter/features/profiles/perfil_provider.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Pantalla de creacion de perfil de nino o docente con configuracion por defecto, variables v_nombreController y v_tipoUsuario, 2026-07-23
class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final TextEditingController vNombreController = TextEditingController();
  TipoUsuario vTipoUsuario = TipoUsuario.nino;

  @override
  void dispose() {
    vNombreController.dispose();
    super.dispose();
  }

  Future<void> _crearPerfil() async {
    final nombre = vNombreController.text.trim();
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe un nombre para el perfil')),
      );
      return;
    }

    final provider = context.read<PerfilProvider>();
    final perfil = await provider.crearPerfil(
      nombre: nombre,
      tipoUsuario: vTipoUsuario,
    );
    await provider.seleccionarPerfil(perfil);
    if (!mounted) {
      return;
    }
    await context.read<ConfiguracionProvider>().cargar(perfil.id!);
    if (!mounted) {
      return;
    }
    Navigator.pushNamedAndRemoveUntil(context, RouteNames.home, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: vNombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text('Tipo de usuario', style: Theme.of(context).textTheme.titleLarge),
            RadioListTile<TipoUsuario>(
              title: const Text('Niño'),
              value: TipoUsuario.nino,
              groupValue: vTipoUsuario,
              onChanged: (value) => setState(() => vTipoUsuario = value!),
            ),
            RadioListTile<TipoUsuario>(
              title: const Text('Docente'),
              value: TipoUsuario.docente,
              groupValue: vTipoUsuario,
              onChanged: (value) => setState(() => vTipoUsuario = value!),
            ),
            const Spacer(),
            BiarButton(
              label: 'Guardar perfil',
              icon: Icons.save,
              onPressed: _crearPerfil,
            ),
          ],
        ),
      ),
    );
  }
}
