import 'package:biblia_ar_flutter/data/database/app_database.dart';
import 'package:biblia_ar_flutter/data/models/leccion_categoria.dart';
import 'package:biblia_ar_flutter/data/repositories/sqlite/sqlite_leccion_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('LeccionRepository filtra por categoria tramite', () async {
    final database = AppDatabase.instance;
    await database.close();

    final db = await database.database;
    final repo = SqliteLeccionRepository(database);

    final tramites = await repo.obtenerPorCategoria(LeccionCategoria.tramite);
    final biblicos = await repo.obtenerPorCategoria(LeccionCategoria.biblico);

    expect(tramites, isNotEmpty);
    expect(tramites.every((l) => l.categoria == LeccionCategoria.tramite), isTrue);
    expect(biblicos.every((l) => l.categoria == LeccionCategoria.biblico), isTrue);

    await db.close();
    await database.close();
  });
}
