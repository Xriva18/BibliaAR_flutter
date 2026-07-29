import 'package:biblia_ar_flutter/data/models/certificado_conadis.dart';
import 'package:biblia_ar_flutter/features/egov/conadis/modo_consulta_conadis.dart';

// kguanoluisa, Argumentos de navegacion para pantalla de resultado CONADIS, variables certificado y modo, 2026-07-29
class ConadisResultadoArgs {
  const ConadisResultadoArgs({
    required this.certificado,
    required this.modo,
  });

  final CertificadoConadis certificado;
  final ModoConsultaConadis modo;
}
