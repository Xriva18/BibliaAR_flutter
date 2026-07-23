import 'package:biblia_ar_flutter/features/egov/widgets/checklist_actividad_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Checklist valida documentos requeridos', (WidgetTester tester) async {
    bool? resultado;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChecklistActividadWidget(
            payload: {
              'titulo': 'Documentos',
              'instruccion': 'Marca los requeridos',
              'elementos': [
                'Cédula de identidad',
                'Planilla de servicios básicos',
                'Comprobante de pago',
              ],
              'requeridos': [0, 1, 2],
            },
            onResultado: (correcto) => resultado = correcto,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Cédula de identidad'));
    await tester.pump();
    await tester.tap(find.text('Planilla de servicios básicos'));
    await tester.pump();
    await tester.tap(find.text('Comprobante de pago'));
    await tester.pump();

    await tester.tap(find.text('Comprobar documentos'));
    await tester.pump();

    expect(resultado, isTrue);
  });
}
