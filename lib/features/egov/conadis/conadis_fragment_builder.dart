import 'package:biblia_ar_flutter/data/models/certificado_conadis.dart';
import 'package:biblia_ar_flutter/data/models/fragmento_narrativo.dart';
import 'package:biblia_ar_flutter/features/egov/conadis/modo_consulta_conadis.dart';

// kguanoluisa, Constructor de fragmentos narrativos para resultado CONADIS segun modo padres o infantil, sin nuevas variables, 2026-07-29
class ConadisFragmentBuilder {
  static List<FragmentoNarrativo> construirFragmentosResultado({
    required CertificadoConadis certificado,
    required ModoConsultaConadis modo,
  }) {
    final pictogramaTipo = certificado.tipoDiscapacidad;
    final esAuditiva = certificado.esDiscapacidadAuditiva;

    if (modo == ModoConsultaConadis.infantil) {
      return [
        FragmentoNarrativo(
          id: 1,
          titulo: 'Resultado encontrado',
          descripcion: esAuditiva
              ? 'Tu hijo tiene apoyo especial para escuchar y comunicarse.'
              : 'Tu hijo tiene un certificado de apoyo registrado.',
          ilustracionAsset: '',
          videoLseAsset: '',
          audioAsset: '',
          duracionMs: 5000,
          pictogramas: ['certificado', pictogramaTipo],
          textoSubtitulo: esAuditiva
              ? 'El certificado indica apoyo para la audición. Puedes pedir ayuda a un adulto.'
              : 'El certificado está registrado. Pide ayuda a un adulto para más detalles.',
        ),
        FragmentoNarrativo(
          id: 2,
          titulo: 'Recuerda',
          descripcion: 'Esta consulta es una simulación educativa, no es el trámite oficial.',
          ilustracionAsset: '',
          videoLseAsset: '',
          audioAsset: '',
          duracionMs: 4000,
          pictogramas: ['conadis'],
          textoSubtitulo: 'Esta es una simulación para aprender. No reemplaza al CONADIS oficial.',
        ),
      ];
    }

    return [
      FragmentoNarrativo(
        id: 1,
        titulo: 'Certificado encontrado',
        descripcion:
            '${certificado.etiquetaTipoDiscapacidad}: ${certificado.porcentaje}% certificado.',
        ilustracionAsset: '',
        videoLseAsset: '',
        audioAsset: '',
        duracionMs: 5000,
        pictogramas: ['certificado', pictogramaTipo],
        textoSubtitulo:
            'Tipo: ${certificado.etiquetaTipoDiscapacidad}. Porcentaje certificado: ${certificado.porcentaje}%.',
      ),
      FragmentoNarrativo(
        id: 2,
        titulo: esAuditiva ? 'Discapacidad auditiva registrada' : 'Condición registrada',
        descripcion: esAuditiva
            ? 'El certificado indica discapacidad auditiva con un ${certificado.porcentaje}% de certificación.'
            : 'El certificado registra ${certificado.etiquetaTipoDiscapacidad.toLowerCase()} con ${certificado.porcentaje}%.',
        ilustracionAsset: '',
        videoLseAsset: '',
        audioAsset: '',
        duracionMs: 5000,
        pictogramas: [pictogramaTipo, 'conadis'],
        textoSubtitulo: esAuditiva
            ? 'Discapacidad auditiva confirmada en el registro simulado.'
            : 'Condición de discapacidad confirmada en el registro simulado.',
      ),
      FragmentoNarrativo(
        id: 3,
        titulo: 'Simulación educativa',
        descripcion: 'Esta consulta es una simulación educativa, no es el trámite oficial de CONADIS.',
        ilustracionAsset: '',
        videoLseAsset: '',
        audioAsset: '',
        duracionMs: 4000,
        pictogramas: ['conadis', 'tramite'],
        textoSubtitulo: 'Recuerda: esto es una simulación para aprender, no el sistema real.',
      ),
    ];
  }
}
