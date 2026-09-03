import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dash_responsive_grid/dash_responsive_grid.dart';

import 'masonry_card.dart';
import 'sample_card.dart';

/// Tabbed demo: a vertical responsive grid, a horizontal responsive
/// grid, and a staggered masonry grid, each on its own tab.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('dash_responsive_grid example'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.grid_view), text: 'Vertical'),
              Tab(icon: Icon(Icons.swap_horiz), text: 'Horizontal'),
              Tab(icon: Icon(Icons.dashboard_customize), text: 'Masonry'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ResponsiveGridView.builder(
              itemCount: 30,
              maxColumns: 3,
              minColumnWidth: 80,
              itemSpacing: 8,
              rowSpacing: 8,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) => SampleCard(index: index),
            ),
            ResponsiveGridView.builder(
              itemCount: 20,
              minColumnWidth: 30,
              scrollDirection: Axis.horizontal,
              maxRows: 3,
              itemSpacing: 8,
              rowSpacing: 8,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              childAspectRatio: 1,
              itemBuilder: (context, index) => SampleCard(index: index),
            ),
            const _MasonryTab(),
          ],
        ),
      ),
    );
  }
}

/// Staggered grid of unevenly sized cards, packed into whichever column
/// is currently shortest.
class _MasonryTab extends StatelessWidget {
  const _MasonryTab();

  static const _itemCount = 20;

  static const _palette = [
    (color: Color(0xFFE8503A), icon: Icons.home),
    (color: Color(0xFFF0932B), icon: Icons.ac_unit),
    (color: Color(0xFFDA3465), icon: Icons.change_history),
    (color: Color(0xFF4CAF50), icon: Icons.badge),
    (color: Color(0xFF3F51B5), icon: Icons.favorite),
    (color: Color(0xFF00897B), icon: Icons.star),
  ];

  static const _minTileHeight = 100.0;
  static const _maxTileHeight = 300.0;

  /// Deterministic per-index height, so tile sizes vary like real data
  /// would without changing on every rebuild. Clamped to
  /// [_minTileHeight]/[_maxTileHeight].
  static double _heightForIndex(int index) {
    final random = Random(index);
    return _minTileHeight +
        random.nextDouble() * (_maxTileHeight - _minTileHeight);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveMasonryGridView.builder(
      itemCount: _itemCount,
      minColumnWidth: 100,
      maxColumns: 3,
      itemSpacing: 12,
      rowSpacing: 12,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final tile = _palette[index % _palette.length];
        return MasonryCard(
          color: tile.color,
          icon: tile.icon,
          height: _heightForIndex(index),
        );
      },
    );
  }
}
