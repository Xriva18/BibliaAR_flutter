enum TipoActividad {
  completar('completar'),
  ordenar('ordenar'),
  identificar('identificar');

  const TipoActividad(this.value);
  final String value;

  static TipoActividad fromValue(String value) {
    return TipoActividad.values.firstWhere(
      (tipo) => tipo.value == value,
      orElse: () => TipoActividad.completar,
    );
  }
}
