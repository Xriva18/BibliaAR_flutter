import 'package:biblia_ar_flutter/core/accessibility/biar_design_tokens.dart';
import 'package:biblia_ar_flutter/shared/widgets/biar_button.dart';
import 'package:flutter/material.dart';

// kguanoluisa, Widget de actividad tipo checklist para tramites eGovernment, variable v_seleccionados, 2026-07-23
class ChecklistActividadWidget extends StatefulWidget {
  const ChecklistActividadWidget({
    super.key,
    required this.payload,
    required this.onResultado,
  });

  final Map<String, dynamic> payload;
  final ValueChanged<bool> onResultado;

  @override
  State<ChecklistActividadWidget> createState() => _ChecklistActividadWidgetState();
}

class _ChecklistActividadWidgetState extends State<ChecklistActividadWidget> {
  final Set<int> vSeleccionados = {};

  void _comprobar() {
    final requeridos =
        (widget.payload['requeridos'] as List<dynamic>).cast<int>().toSet();
    widget.onResultado(vSeleccionados.containsAll(requeridos));
  }

  @override
  Widget build(BuildContext context) {
    final elementos = (widget.payload['elementos'] as List).cast<String>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.payload['titulo'] as String, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: BiarSpacing.sm),
        Text(widget.payload['instruccion'] as String),
        const SizedBox(height: BiarSpacing.md),
        ...List.generate(elementos.length, (index) {
          return CheckboxListTile(
            value: vSeleccionados.contains(index),
            onChanged: (checked) {
              setState(() {
                if (checked == true) {
                  vSeleccionados.add(index);
                } else {
                  vSeleccionados.remove(index);
                }
              });
            },
            title: Text(elementos[index]),
          );
        }),
        BiarButton(label: 'Comprobar documentos', onPressed: _comprobar),
      ],
    );
  }
}
