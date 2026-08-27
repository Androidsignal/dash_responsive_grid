import 'package:dash_responsive_grid/dash_responsive_grid.dart';
import 'package:dash_responsive_grid/src/responsive_grid_delegate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveSliverGridDelegate — auto mode (minColumnWidth)', () {
    test('column count is floor(width / minColumnWidth)', () {
      const delegate = ResponsiveSliverGridDelegate(
        minColumnWidth: 160,
        maxColumns: 100,
      );
      expect(delegate.getColumnCount(320), 2);
      expect(delegate.getColumnCount(480), 3);
      expect(delegate.getColumnCount(500), 3);
      expect(delegate.getColumnCount(159), 1); // floors to 0, clamped up to 1
    });

    test('clamps to minColumns', () {
      const delegate = ResponsiveSliverGridDelegate(
        minColumnWidth: 500,
        minColumns: 2,
        maxColumns: 6,
      );
      // width / 500 floors to 0, clamp raises to minColumns.
      expect(delegate.getColumnCount(100), 2);
    });

    test('clamps to maxColumns', () {
      const delegate = ResponsiveSliverGridDelegate(
        minColumnWidth: 50,
        minColumns: 1,
        maxColumns: 4,
      );
      // width / 50 = 40, clamp caps at maxColumns.
      expect(delegate.getColumnCount(2000), 4);
    });
  });

  group('ResponsiveSliverGridDelegate — breakpoint mode', () {
    const delegate = ResponsiveSliverGridDelegate(
      breakpoints: GridBreakpoints.defaultBreakpoints,
      maxColumns: 100,
    );

    test('resolves mobile/tablet/desktop/web columns', () {
      expect(delegate.getColumnCount(320), 2); // mobile
      expect(delegate.getColumnCount(700), 4); // tablet
      expect(delegate.getColumnCount(1200), 6); // desktop
      expect(delegate.getColumnCount(1600), 8); // web
    });

    test('clamps breakpoint result to minColumns/maxColumns', () {
      const clamped = ResponsiveSliverGridDelegate(
        breakpoints: GridBreakpoints.defaultBreakpoints,
        minColumns: 3,
        maxColumns: 5,
      );
      expect(clamped.getColumnCount(320), 3); // mobile(2) clamped up
      expect(clamped.getColumnCount(1600), 5); // web(8) clamped down
    });
  });

  test(
    'falls back to GridBreakpoints.defaultBreakpoints when neither is given',
    () {
      const delegate = ResponsiveSliverGridDelegate(maxColumns: 100);
      expect(delegate.getColumnCount(320), 2); // mobile
      expect(delegate.getColumnCount(1600), 8); // web
    },
  );

  test('minColumnWidth wins when both are given', () {
    const delegate = ResponsiveSliverGridDelegate(
      minColumnWidth: 100,
      breakpoints: GridBreakpoints.defaultBreakpoints,
      maxColumns: 100,
    );
    // breakpoint mode would say 2 (mobile); auto mode wins instead.
    expect(delegate.getColumnCount(320), 3);
  });

  test('shouldRelayout is true only when relevant fields differ', () {
    const a = ResponsiveSliverGridDelegate(minColumnWidth: 100);
    const b = ResponsiveSliverGridDelegate(minColumnWidth: 100);
    const c = ResponsiveSliverGridDelegate(minColumnWidth: 200);
    expect(a.shouldRelayout(b), isFalse);
    expect(a.shouldRelayout(c), isTrue);
  });
}
