import 'package:biblia_ar_flutter/data/models/leccion.dart';

abstract class LeccionRepository {
  Future<List<Leccion>> obtenerTodas();
  Future<Leccion?> obtenerPorId(int id);
}
