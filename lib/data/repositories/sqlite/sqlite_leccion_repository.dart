import 'package:biblia_ar_flutter/data/database/app_database.dart';
import 'package:biblia_ar_flutter/data/models/leccion.dart';
import 'package:biblia_ar_flutter/data/repositories/interfaces/leccion_repository.dart';

class SqliteLeccionRepository implements LeccionRepository {
  SqliteLeccionRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Leccion>> obtenerTodas() async {
    final db = await _database.database;
    final rows = await db.query('lecciones', orderBy: 'orden ASC');
    return rows.map(Leccion.fromMap).toList();
  }

  @override
  Future<List<Leccion>> obtenerPorCategoria(String categoria) async {
    final db = await _database.database;
    final rows = await db.query(
      'lecciones',
      where: 'categoria = ?',
      whereArgs: [categoria],
      orderBy: 'orden ASC',
    );
    return rows.map(Leccion.fromMap).toList();
  }

  @override
  Future<Leccion?> obtenerPorId(int id) async {
    final db = await _database.database;
    final rows = await db.query(
      'lecciones',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return Leccion.fromMap(rows.first);
  }
}
