import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:dash_responsive_grid/dash_responsive_grid.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {Size size = const Size(800, 600)}) {
  return MediaQuery(
    data: MediaQueryData(size: size),
    child: Directionality(textDirection: TextDirection.ltr, child: child),
  );
}

void main() {
  testWidgets('renders itemCount items via builder', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ResponsiveGridView.builder(
          itemCount: 5,
          minColumnWidth: 160,
          itemBuilder: (context, index) => Text('item-$index'),
        ),
      ),
    );

    for (var i = 0; i < 5; i++) {
      expect(find.text('item-$i'), findsOneWidget);
    }
  });

  testWidgets('shows default loading widget when isLoading is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        ResponsiveGridView.builder(
          itemCount: 5,
          minColumnWidth: 160,
          isLoading: true,
          itemBuilder: (context, index) => Text('item-$index'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('item-0'), findsNothing);
  });

  testWidgets('shows custom loading builder when supplied', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ResponsiveGridView.builder(
          itemCount: 5,
          minColumnWidth: 160,
          isLoading: true,
          loadingBuilder: (context) => const Text('loading...'),
          itemBuilder: (context, index) => Text('item-$index'),
        ),
      ),
    );

    expect(find.text('loading...'), findsOneWidget);
  });

  testWidgets('shows default empty widget when itemCount is 0', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ResponsiveGridView.builder(
          itemCount: 0,
          minColumnWidth: 160,
          itemBuilder: (context, index) => Text('item-$index'),
        ),
      ),
    );

    expect(find.text('No items'), findsOneWidget);
  });

  testWidgets('shows custom empty builder when supplied', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ResponsiveGridView.builder(
          itemCount: 0,
          minColumnWidth: 160,
          emptyBuilder: (context) => const Text('nothing here'),
          itemBuilder: (context, index) => Text('item-$index'),
        ),
      ),
    );

    expect(find.text('nothing here'), findsOneWidget);
  });

  testWidgets('shows error widget when hasError is true', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ResponsiveGridView.builder(
          itemCount: 5,
          minColumnWidth: 160,
          hasError: true,
          itemBuilder: (context, index) => Text('item-$index'),
        ),
      ),
    );

    expect(find.textContaining('Something went wrong'), findsOneWidget);
    expect(find.text('item-0'), findsNothing);
  });

  testWidgets('renders correct column count for width in breakpoint mode', (
    tester,
  ) async {
    // Mobile width (< 600) -> 2 columns.
    await tester.pumpWidget(
      _wrap(
        ResponsiveGridView.builder(
          itemCount: 4,
          breakpoints: GridBreakpoints.defaultBreakpoints,
          itemBuilder: (context, index) => Text('item-$index'),
        ),
        size: const Size(400, 800),
      ),
    );
    await tester.pumpAndSettle();

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate = grid.gridDelegate;
    final layout = delegate.getLayout(
      const SliverConstraints(
        axisDirection: AxisDirection.down,
        growthDirection: GrowthDirection.forward,
        userScrollDirection: ScrollDirection.idle,
        scrollOffset: 0,
        precedingScrollExtent: 0,
        overlap: 0,
        remainingPaintExtent: 800,
        crossAxisExtent: 400,
        crossAxisDirection: AxisDirection.right,
        viewportMainAxisExtent: 800,
        remainingCacheExtent: 800,
        cacheOrigin: 0,
      ),
    ) as SliverGridRegularTileLayout;
    expect(layout.crossAxisCount, 2);
  });

  testWidgets('rebuilds column count on screen resize', (tester) async {
    addTearDown(() => tester.view.resetPhysicalSize());

    Future<void> pumpAtWidth(double width) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        _wrap(
          ResponsiveGridView.builder(
            itemCount: 4,
            minColumnWidth: 200,
            itemBuilder: (context, index) => Text('item-$index'),
          ),
          size: Size(width, 800),
        ),
      );
      await tester.pumpAndSettle();
    }

    // 800px / 200 = 4 columns -> item-0 and item-1 share a row.
    await pumpAtWidth(800);
    expect(
      tester.getTopLeft(find.text('item-0')).dy,
      tester.getTopLeft(find.text('item-1')).dy,
    );

    // 250px / 200 = 1 column -> item-1 wraps to the next row.
    await pumpAtWidth(250);
    expect(
      tester.getTopLeft(find.text('item-0')).dy,
      lessThan(tester.getTopLeft(find.text('item-1')).dy),
    );
  });

  testWidgets('horizontal scroll direction renders items', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ResponsiveGridView.builder(
          itemCount: 3,
          minColumnWidth: 100,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Text('item-$index'),
        ),
      ),
    );

    final grid = tester.widget<GridView>(find.byType(GridView));
    expect(grid.scrollDirection, Axis.horizontal);
    expect(find.text('item-0'), findsOneWidget);
  });

  testWidgets('minRows/maxRows clamp the cross-axis count in horizontal mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        ResponsiveGridView.builder(
          itemCount: 20,
          minColumnWidth: 10, // would resolve way above 3 without clamping
          minRows: 3,
          maxRows: 3,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Text('item-$index'),
        ),
        size: const Size(800, 600),
      ),
    );
    await tester.pumpAndSettle();

    final grid = tester.widget<GridView>(find.byType(GridView));
    final layout = grid.gridDelegate.getLayout(
      const SliverConstraints(
        axisDirection: AxisDirection.right,
        growthDirection: GrowthDirection.forward,
        userScrollDirection: ScrollDirection.idle,
        scrollOffset: 0,
        precedingScrollExtent: 0,
        overlap: 0,
        remainingPaintExtent: 800,
        crossAxisExtent: 600,
        crossAxisDirection: AxisDirection.down,
        viewportMainAxisExtent: 800,
        remainingCacheExtent: 800,
        cacheOrigin: 0,
      ),
    ) as SliverGridRegularTileLayout;
    expect(layout.crossAxisCount, 3);
  });

  testWidgets('minRows/maxRows are ignored in vertical mode', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ResponsiveGridView.builder(
          itemCount: 20,
          minColumnWidth: 100,
          minRows: 3,
          maxRows: 3,
          maxColumns: 8,
          itemBuilder: (context, index) => Text('item-$index'),
        ),
        size: const Size(800, 600),
      ),
    );
    await tester.pumpAndSettle();

    final grid = tester.widget<GridView>(find.byType(GridView));
    final layout = grid.gridDelegate.getLayout(
      const SliverConstraints(
        axisDirection: AxisDirection.down,
        growthDirection: GrowthDirection.forward,
        userScrollDirection: ScrollDirection.idle,
        scrollOffset: 0,
        precedingScrollExtent: 0,
        overlap: 0,
        remainingPaintExtent: 800,
        crossAxisExtent: 800,
        crossAxisDirection: AxisDirection.right,
        viewportMainAxisExtent: 800,
        remainingCacheExtent: 800,
        cacheOrigin: 0,
      ),
    ) as SliverGridRegularTileLayout;
    // 800 / 100 = 8, unclamped by minRows/maxRows since this is vertical.
    expect(layout.crossAxisCount, 8);
  });

  testWidgets('falls back to GridBreakpoints.defaultBreakpoints when neither '
      'minColumnWidth nor breakpoints is given', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ResponsiveGridView.builder(
          itemCount: 3,
          itemBuilder: (context, index) => Text('item-$index'),
        ),
        size: const Size(400, 800), // mobile width
      ),
    );

    for (var i = 0; i < 3; i++) {
      expect(find.text('item-$i'), findsOneWidget);
    }
  });

  test('asserts maxRows >= minRows', () {
    expect(
      () => ResponsiveGridView.builder(
        itemCount: 1,
        minRows: 4,
        maxRows: 2,
        itemBuilder: (context, index) => const SizedBox(),
      ),
      throwsAssertionError,
    );
  });
}
