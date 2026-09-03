import 'package:dash_responsive_grid/dash_responsive_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(400, 800),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(home: child));
  }

  testWidgets('renders itemCount items of varying heights', (tester) async {
    const heights = [100.0, 60.0, 140.0, 80.0];
    await pump(
      tester,
      ResponsiveMasonryGridView.builder(
        itemCount: heights.length,
        maxColumns: 2,
        itemSpacing: 8,
        rowSpacing: 8,
        itemBuilder: (context, index) =>
            SizedBox(key: ValueKey(index), height: heights[index]),
      ),
    );

    for (var i = 0; i < heights.length; i++) {
      expect(find.byKey(ValueKey(i)), findsOneWidget);
    }
  });

  testWidgets('packs items into the shortest column', (tester) async {
    await pump(
      tester,
      ResponsiveMasonryGridView.builder(
        itemCount: 3,
        maxColumns: 2,
        itemBuilder: (context, index) {
          final height = index == 0 ? 200.0 : 50.0;
          return SizedBox(key: ValueKey(index), height: height);
        },
      ),
    );

    final tallOffset = tester.getTopLeft(find.byKey(const ValueKey(0)));
    final secondOffset = tester.getTopLeft(find.byKey(const ValueKey(1)));
    final thirdOffset = tester.getTopLeft(find.byKey(const ValueKey(2)));

    // Item 0 is tall and occupies column 0; items 1 and 2 should both
    // land in column 1 (the shorter column), stacked one above the
    // other.
    expect(secondOffset.dx, thirdOffset.dx);
    expect(secondOffset.dx, greaterThan(tallOffset.dx));
    expect(thirdOffset.dy, greaterThan(secondOffset.dy));
  });

  testWidgets('shows default empty widget when itemCount is 0', (
    tester,
  ) async {
    await pump(
      tester,
      ResponsiveMasonryGridView.builder(
        itemCount: 0,
        itemBuilder: (context, index) => const SizedBox(),
      ),
    );

    expect(find.text('No items'), findsOneWidget);
  });

  testWidgets('shows loading widget when isLoading is true', (tester) async {
    await pump(
      tester,
      ResponsiveMasonryGridView.builder(
        itemCount: 3,
        isLoading: true,
        itemBuilder: (context, index) => const SizedBox(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shrinkWrap renders without its own scroll view', (
    tester,
  ) async {
    await pump(
      tester,
      SingleChildScrollView(
        child: ResponsiveMasonryGridView.builder(
          itemCount: 4,
          maxColumns: 2,
          shrinkWrap: true,
          itemBuilder: (context, index) =>
              SizedBox(key: ValueKey(index), height: 60),
        ),
      ),
    );

    expect(find.byKey(const ValueKey(0)), findsOneWidget);
    // Only the outer SingleChildScrollView should exist.
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
