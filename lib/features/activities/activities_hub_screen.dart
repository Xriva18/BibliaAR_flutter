import 'dart:convert';

import 'package:biblia_ar_flutter/core/feedback/multimodal_feedback.dart';
import 'package:biblia_ar_flutter/data/models/tipo_actividad.dart';
import 'package:biblia_ar_flutter/features/activities/actividad_provider.dart';
import 'package:biblia_ar_flutter/features/activities/widgets/completar_actividad_widget.dart';
import 'package:biblia_ar_flutter/features/activities/widgets/identificar_actividad_widget.dart';
import 'package:biblia_ar_flutter/features/activities/widgets/ordenar_actividad_widget.dart';
import 'package:biblia_ar_flutter/features/profiles/perfil_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// kguanoluisa, Hub de actividades interactivas con tres tipos sin penalizacion por error, sin nuevas variables, 2026-07-23
class ActivitiesHubScreen extends StatefulWidget {
  const ActivitiesHubScreen({super.key});

  @override
  State<ActivitiesHubScreen> createState() => _ActivitiesHubScreenState();
}

class _ActivitiesHubScreenState extends State<ActivitiesHubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActividadProvider>().cargarActividades(1);
    });
  }

  Future<void> _registrarResultado(int actividadId, bool correcto) async {
    final perfil = context.read<PerfilProvider>().vPerfilActivo;
    if (perfil?.id == null) {
      return;
    }
    await context.read<ActividadProvider>().registrarIntento(
          perfilId: perfil!.id!,
          actividadId: actividadId,
          resultado: correcto ? 'correcto' : 'incorrecto',
        );
    if (!mounted) {
      return;
    }
    if (correcto) {
      await MultimodalFeedback.success(context);
    } else {
      await MultimodalFeedback.intento(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ActividadProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Actividades')),
      body: provider.vCargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.vActividades.length,
              itemBuilder: (context, index) {
                final actividad = provider.vActividades[index];
                final payload =
                    jsonDecode(actividad.payloadJson) as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildActividad(
                      actividad.id!,
                      actividad.tipo,
                      payload,
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildActividad(
    int actividadId,
    TipoActividad tipo,
    Map<String, dynamic> payload,
  ) {
    switch (tipo) {
      case TipoActividad.completar:
        return CompletarActividadWidget(
          payload: payload,
          onResultado: (correcto) => _registrarResultado(actividadId, correcto),
        );
      case TipoActividad.ordenar:
        return OrdenarActividadWidget(
          payload: payload,
          onResultado: (correcto) => _registrarResultado(actividadId, correcto),
        );
      case TipoActividad.identificar:
        return IdentificarActividadWidget(
          payload: payload,
          onResultado: (correcto) => _registrarResultado(actividadId, correcto),
        );
    }
  }
}
