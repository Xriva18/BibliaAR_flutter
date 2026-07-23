import 'dart:convert';

import 'package:biblia_ar_flutter/data/database/migrations/migration_v1.dart';
import 'package:biblia_ar_flutter/data/database/migrations/migration_v2.dart';
import 'package:biblia_ar_flutter/data/models/leccion_categoria.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

// kguanoluisa, Base de datos SQLite con migracion v2 de categoria y seed de tramite eGovernment, variable v_database, 2026-07-23
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();
  static Database? _database;

  static const String databaseName = 'biar.db';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, databaseName);

    return openDatabase(
      path,
      version: MigrationV2.version,
      onCreate: (db, version) async {
        for (final statement in MigrationV1.statements) {
          await db.execute(statement);
        }
        await _seedInitialData(db);
        await _seedTramiteData(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < MigrationV2.version) {
          for (final statement in MigrationV2.statements) {
            await db.execute(statement);
          }
          await _seedTramiteData(db);
        }
      },
    );
  }

  Future<void> _seedInitialData(Database db) async {
    final now = DateTime.now().toIso8601String();
    const leccionPath = 'assets/lessons/buen_samaritano/fragments.json';

    await db.insert('lecciones', {
      'titulo': 'El Buen Samaritano',
      'referencia_biblica': 'Lucas 10:25-37',
      'contenido_multimedia_path': leccionPath,
      'categoria': LeccionCategoria.biblico,
      'orden': 1,
      'updated_at': now,
      'sync_status': 'local',
    });

    final actividadesSeed = [
      {
        'leccion_id': 1,
        'tipo': 'completar',
        'payload_json': jsonEncode({
          'titulo': 'Completa la historia',
          'pregunta': '¿Quién ayudó al hombre herido?',
          'opciones': ['Un sacerdote', 'Un levita', 'Un samaritano', 'Un soldado'],
          'respuestaCorrecta': 2,
        }),
        'updated_at': now,
        'sync_status': 'local',
      },
      {
        'leccion_id': 1,
        'tipo': 'ordenar',
        'payload_json': jsonEncode({
          'titulo': 'Ordena la historia',
          'instruccion': 'Arrastra los eventos en el orden correcto',
          'elementos': [
            'El hombre es herido en el camino',
            'Pasa un sacerdote sin ayudar',
            'Un samaritano lo auxilia',
            'Lo lleva a un hospedaje',
          ],
          'ordenCorrecto': [0, 1, 2, 3],
        }),
        'updated_at': now,
        'sync_status': 'local',
      },
      {
        'leccion_id': 1,
        'tipo': 'identificar',
        'payload_json': jsonEncode({
          'titulo': 'Identifica al personaje',
          'instruccion': 'Selecciona quién mostró compasión',
          'opciones': [
            {'id': 'sacerdote', 'nombre': 'Sacerdote'},
            {'id': 'samaritano', 'nombre': 'Samaritano'},
            {'id': 'levita', 'nombre': 'Levita'},
          ],
          'respuestaCorrecta': 'samaritano',
        }),
        'updated_at': now,
        'sync_status': 'local',
      },
    ];

    for (final actividad in actividadesSeed) {
      await db.insert('actividades', actividad);
    }
  }

  Future<void> _seedTramiteData(Database db) async {
    final existente = await db.query(
      'lecciones',
      where: 'categoria = ?',
      whereArgs: [LeccionCategoria.tramite],
      limit: 1,
    );
    if (existente.isNotEmpty) {
      return;
    }

    final now = DateTime.now().toIso8601String();
    const tramitePath = 'assets/lessons/certificado_residencia/fragments.json';

    final leccionId = await db.insert('lecciones', {
      'titulo': 'Certificado de residencia',
      'referencia_biblica': 'Trámite municipal demo',
      'contenido_multimedia_path': tramitePath,
      'categoria': LeccionCategoria.tramite,
      'orden': 1,
      'updated_at': now,
      'sync_status': 'local',
    });

    await db.insert('actividades', {
      'leccion_id': leccionId,
      'tipo': 'checklist',
      'payload_json': jsonEncode({
        'titulo': '¿Qué documentos necesito?',
        'instruccion': 'Marca los documentos requeridos',
        'elementos': [
          'Cédula de identidad',
          'Planilla de servicios básicos',
          'Comprobante de pago',
        ],
        'requeridos': [0, 1, 2],
      }),
      'updated_at': now,
      'sync_status': 'local',
    });
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
