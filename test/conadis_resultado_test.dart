import 'package:biblia_ar_flutter/data/models/certificado_conadis.dart';
import 'package:biblia_ar_flutter/features/egov/conadis/conadis_fragment_builder.dart';
import 'package:biblia_ar_flutter/features/egov/conadis/modo_consulta_conadis.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const certificado = CertificadoConadis(
    numeroCertificado: 'CON-2024-000001',
    tipoDiscapacidad: 'auditiva',
    porcentaje: 85,
  );

  test('modo padres muestra porcentaje exacto', () {
    final fragmentos = ConadisFragmentBuilder.construirFragmentosResultado(
      certificado: certificado,
      modo: ModoConsultaConadis.padres,
    );

    expect(fragmentos.first.descripcion, contains('85%'));
    expect(fragmentos.first.textoSubtitulo, contains('85%'));
  });

  test('modo infantil oculta porcentaje exacto', () {
    final fragmentos = ConadisFragmentBuilder.construirFragmentosResultado(
      certificado: certificado,
      modo: ModoConsultaConadis.infantil,
    );

    for (final fragmento in fragmentos) {
      expect(fragmento.descripcion, isNot(contains('85%')));
      expect(fragmento.textoSubtitulo, isNot(contains('85%')));
    }
    expect(fragmentos.first.descripcion, contains('escuchar'));
  });
}
