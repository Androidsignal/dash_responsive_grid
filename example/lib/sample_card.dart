import 'package:flutter/material.dart';

/// A small colored card used across the example pages to visualize grid
/// tiles without pulling in network images.
class SampleCard extends StatelessWidget {
  const SampleCard({super.key, required this.index});

  final int index;

  static const _palette = [
    Colors.indigo,
    Colors.teal,
    Colors.orange,
    Colors.pink,
    Colors.blueGrey,
    Colors.deepPurple,
  ];

  @override
  Widget build(BuildContext context) {
    final color = _palette[index % _palette.length];
    return Card(
      color: color.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.4)),
      ),
      child: Center(
        child: Text(
          '#$index',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
