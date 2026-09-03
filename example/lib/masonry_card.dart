import 'package:flutter/material.dart';

/// A colored, fixed-height card with a centered icon — used to visualize
/// [ResponsiveMasonryGridView] tiles of varying heights.
class MasonryCard extends StatelessWidget {
  const MasonryCard({
    super.key,
    required this.color,
    required this.icon,
    required this.height,
  });

  final Color color;
  final IconData icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
