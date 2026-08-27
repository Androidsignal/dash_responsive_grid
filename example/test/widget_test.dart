import 'package:dash_responsive_grid_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('example app opens on the Vertical tab', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    expect(find.text('dash_responsive_grid example'), findsOneWidget);
    expect(find.text('Vertical'), findsOneWidget);
    expect(find.text('Horizontal'), findsOneWidget);
    expect(find.text('#0'), findsOneWidget);
  });

  testWidgets('Horizontal tab shows the horizontal grid', (tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Horizontal'));
    await tester.pumpAndSettle();

    final grid = tester.widget<GridView>(find.byType(GridView));
    expect(grid.scrollDirection, Axis.horizontal);
    expect(find.text('#0'), findsOneWidget);
  });
}
