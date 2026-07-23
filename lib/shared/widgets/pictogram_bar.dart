import 'package:flutter/material.dart';

// kguanoluisa, Barra de pictogramas contextuales sincronizados con el fragmento narrativo, variable v_pictogramas, 2026-07-23
class PictogramBar extends StatelessWidget {
  const PictogramBar({super.key, required this.vPictogramas});

  final List<String> vPictogramas;

  IconData _iconoParaPictograma(String pictograma) {
    switch (pictograma) {
      case 'herido':
        return Icons.healing;
      case 'samaritano':
        return Icons.favorite;
      case 'ayudar':
        return Icons.volunteer_activism;
      case 'camino':
        return Icons.route;
      default:
        return Icons.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (vPictogramas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: vPictogramas.map((pictograma) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _iconoParaPictograma(pictograma),
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  pictograma,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
