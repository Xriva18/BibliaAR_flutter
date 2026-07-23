import 'package:biblia_ar_flutter/shared/widgets/biar_button.dart';
import 'package:flutter/material.dart';

// kguanoluisa, Widget de actividad tipo ordenar secuencia con reordenamiento manual, variable v_elementos, 2026-07-23
class OrdenarActividadWidget extends StatefulWidget {
  const OrdenarActividadWidget({
    super.key,
    required this.payload,
    required this.onResultado,
  });

  final Map<String, dynamic> payload;
  final ValueChanged<bool> onResultado;

  @override
  State<OrdenarActividadWidget> createState() => _OrdenarActividadWidgetState();
}

class _OrdenarActividadWidgetState extends State<OrdenarActividadWidget> {
  late List<String> vElementos;

  @override
  void initState() {
    super.initState();
    vElementos = (widget.payload['elementos'] as List).cast<String>();
  }

  void _mover(int index, int delta) {
    final nuevoIndex = index + delta;
    if (nuevoIndex < 0 || nuevoIndex >= vElementos.length) {
      return;
    }
    setState(() {
      final item = vElementos.removeAt(index);
      vElementos.insert(nuevoIndex, item);
    });
  }

  void _comprobar() {
    final ordenCorrecto = (widget.payload['ordenCorrecto'] as List).cast<int>();
    final actual = <int>[];
    final originales = (widget.payload['elementos'] as List).cast<String>();
    for (final elemento in vElementos) {
      actual.add(originales.indexOf(elemento));
    }
    widget.onResultado(_listasIguales(actual, ordenCorrecto));
  }

  bool _listasIguales(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.payload['titulo'] as String,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(widget.payload['instruccion'] as String),
        const SizedBox(height: 12),
        ...List.generate(vElementos.length, (index) {
          return Card(
            child: ListTile(
              title: Text('${index + 1}. ${vElementos[index]}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () => _mover(index, -1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () => _mover(index, 1),
                  ),
                ],
              ),
            ),
          );
        }),
        BiarButton(label: 'Comprobar orden', onPressed: _comprobar),
      ],
    );
  }
}
