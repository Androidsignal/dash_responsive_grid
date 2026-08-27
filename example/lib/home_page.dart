import 'package:flutter/material.dart';
import 'package:dash_responsive_grid/dash_responsive_grid.dart';

import 'sample_card.dart';

/// Tabbed demo: a vertical responsive grid and a horizontal responsive
/// grid, each on its own tab.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('dash_responsive_grid example'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.grid_view), text: 'Vertical'),
              Tab(icon: Icon(Icons.swap_horiz), text: 'Horizontal'),
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
          ],
        ),
      ),
    );
  }
}
