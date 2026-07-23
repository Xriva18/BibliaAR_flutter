class Leccion {
  const Leccion({
    this.id,
    required this.titulo,
    required this.referenciaBiblica,
    required this.contenidoMultimediaPath,
    this.orden = 0,
    this.updatedAt,
    this.syncStatus = 'local',
  });

  final int? id;
  final String titulo;
  final String referenciaBiblica;
  final String contenidoMultimediaPath;
  final int orden;
  final DateTime? updatedAt;
  final String syncStatus;

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'referencia_biblica': referenciaBiblica,
      'contenido_multimedia_path': contenidoMultimediaPath,
      'orden': orden,
      'updated_at': (updatedAt ?? DateTime.now()).toIso8601String(),
      'sync_status': syncStatus,
    };
  }

  factory Leccion.fromMap(Map<String, dynamic> map) {
    return Leccion(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      referenciaBiblica: map['referencia_biblica'] as String,
      contenidoMultimediaPath: map['contenido_multimedia_path'] as String,
      orden: map['orden'] as int? ?? 0,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      syncStatus: map['sync_status'] as String? ?? 'local',
    );
  }
}
