import 'package:biblia_ar_flutter/core/routing/route_names.dart';
import 'package:biblia_ar_flutter/data/models/perfil.dart';
import 'package:biblia_ar_flutter/data/models/tipo_usuario.dart';
import 'package:biblia_ar_flutter/features/profiles/perfil_provider.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Pantalla de seleccion y creacion de perfiles locales sin autenticacion, sin nuevas variables, 2026-07-23
class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PerfilProvider>().cargarPerfiles();
    });
  }

  Future<void> _seleccionarPerfil(Perfil perfil) async {
    await context.read<PerfilProvider>().seleccionarPerfil(perfil);
    if (!mounted) {
      return;
    }
    await context.read<ConfiguracionProvider>().cargar(perfil.id!);
    if (!mounted) {
      return;
    }
    Navigator.pushReplacementNamed(context, RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PerfilProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona tu perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Elige quién usará la app',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (provider.vCargando) const LinearProgressIndicator(),
            Expanded(
              child: ListView.builder(
                itemCount: provider.vPerfiles.length,
                itemBuilder: (context, index) {
                  final perfil = provider.vPerfiles[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        perfil.tipoUsuario == TipoUsuario.docente
                            ? Icons.school
                            : Icons.child_care,
                      ),
                      title: Text(perfil.nombre),
                      subtitle: Text(
                        perfil.tipoUsuario == TipoUsuario.docente
                            ? 'Docente'
                            : 'Niño',
                      ),
                      onTap: () => _seleccionarPerfil(perfil),
                    ),
                  );
                },
              ),
            ),
            BiarButton(
              label: 'Crear perfil',
              icon: Icons.person_add,
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.createProfile);
              },
            ),
          ],
        ),
      ),
    );
  }
}
