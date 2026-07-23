import 'dart:convert';

import 'package:biblia_ar_flutter/core/constants/app_constants.dart';
import 'package:biblia_ar_flutter/data/models/estado_progreso.dart';
import 'package:biblia_ar_flutter/data/models/fragmento_narrativo.dart';
import 'package:biblia_ar_flutter/data/models/leccion.dart';
import 'package:biblia_ar_flutter/data/models/progreso.dart';
import 'package:biblia_ar_flutter/data/repositories/interfaces/leccion_repository.dart';
import 'package:biblia_ar_flutter/data/repositories/interfaces/progreso_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// kguanoluisa, Provider del reproductor de leccion multimedia con fragmentos narrativos sincronizados, variables v_fragmentos y v_indiceFragmento, 2026-07-23
class LessonPlayerProvider extends ChangeNotifier {
  LessonPlayerProvider({
    required LeccionRepository leccionRepository,
    required ProgresoRepository progresoRepository,
  })  : _leccionRepository = leccionRepository,
        _progresoRepository = progresoRepository;

  final LeccionRepository _leccionRepository;
  final ProgresoRepository _progresoRepository;

  Leccion? vLeccion;
  List<FragmentoNarrativo> vFragmentos = [];
  int vIndiceFragmento = 0;
  bool vReproduciendo = false;
  bool vCargando = false;

  FragmentoNarrativo? get fragmentoActual {
    if (vFragmentos.isEmpty) {
      return null;
    }
    return vFragmentos[vIndiceFragmento];
  }

  bool get esUltimoFragmento => vIndiceFragmento >= vFragmentos.length - 1;
  bool get esPrimerFragmento => vIndiceFragmento == 0;

  Future<void> cargarLeccion({int leccionId = 1, int? perfilId}) async {
    vCargando = true;
    notifyListeners();

    vLeccion = await _leccionRepository.obtenerPorId(leccionId);
    await _cargarFragmentosDesdeAssets();

    if (perfilId != null) {
      await _progresoRepository.guardar(
        Progreso(
          perfilId: perfilId,
          leccionId: leccionId,
          estado: EstadoProgreso.enCurso,
          fecha: DateTime.now(),
        ),
      );
    }

    vCargando = false;
    notifyListeners();
  }

  Future<void> _cargarFragmentosDesdeAssets() async {
    final raw = await rootBundle.loadString(AppConstants.leccionBuenSamaritanoPath);
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final fragmentosJson = data['fragmentos'] as List<dynamic>;

    final subtitulosRaw =
        await rootBundle.loadString(AppConstants.subtitulosBuenSamaritanoPath);
    final subtitulosData = jsonDecode(subtitulosRaw) as Map<String, dynamic>;
    final subtitulos = subtitulosData['fragmentos'] as List<dynamic>;

    vFragmentos = fragmentosJson.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      final id = map['id'] as int;
      final subtitulo = subtitulos.cast<Map<String, dynamic>>().firstWhere(
            (frag) => frag['id'] == id,
            orElse: () => {'texto': map['descripcion'] ?? '', 'pictogramas': []},
          );
      map['texto'] = subtitulo['texto'];
      map['pictogramas'] = subtitulo['pictogramas'] ?? [];
      return FragmentoNarrativo.fromMap(map);
    }).toList();
  }

  void alternarReproduccion() {
    vReproduciendo = !vReproduciendo;
    notifyListeners();
  }

  void fragmentoAnterior() {
    if (!esPrimerFragmento) {
      vIndiceFragmento--;
      notifyListeners();
    }
  }

  void fragmentoSiguiente() {
    if (!esUltimoFragmento) {
      vIndiceFragmento++;
      notifyListeners();
    }
  }

  Future<void> completarLeccion(int perfilId) async {
    if (vLeccion?.id == null) {
      return;
    }
    await _progresoRepository.guardar(
      Progreso(
        perfilId: perfilId,
        leccionId: vLeccion!.id!,
        estado: EstadoProgreso.completada,
        fecha: DateTime.now(),
      ),
    );
  }
}
