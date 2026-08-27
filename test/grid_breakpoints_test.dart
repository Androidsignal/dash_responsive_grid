import 'package:dash_responsive_grid/dash_responsive_grid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GridBreakpoints', () {
    const bp = GridBreakpoints.defaultBreakpoints;

    test('defaults are mobile:2 tablet:4 desktop:6 web:8', () {
      expect(bp.mobileColumns, 2);
      expect(bp.tabletColumns, 4);
      expect(bp.desktopColumns, 6);
      expect(bp.webColumns, 8);
    });

    test('resolves mobile below mobileMaxWidth', () {
      expect(bp.columnsForWidth(320), 2);
      expect(bp.columnsForWidth(599.99), 2);
    });

    test('resolves tablet between mobile and tablet thresholds', () {
      expect(bp.columnsForWidth(600), 4);
      expect(bp.columnsForWidth(800), 4);
      expect(bp.columnsForWidth(1023.99), 4);
    });

    test('resolves desktop between tablet and desktop thresholds', () {
      expect(bp.columnsForWidth(1024), 6);
      expect(bp.columnsForWidth(1200), 6);
      expect(bp.columnsForWidth(1439.99), 6);
    });

    test('resolves web at or above desktopMaxWidth', () {
      expect(bp.columnsForWidth(1440), 8);
      expect(bp.columnsForWidth(2560), 8);
    });

    test('copyWith overrides only given fields', () {
      final custom = bp.copyWith(mobileColumns: 3);
      expect(custom.mobileColumns, 3);
      expect(custom.tabletColumns, bp.tabletColumns);
      expect(custom.mobileMaxWidth, bp.mobileMaxWidth);
    });

    test('custom thresholds resolve correctly', () {
      const custom = GridBreakpoints(
        mobileMaxWidth: 400,
        tabletMaxWidth: 800,
        desktopMaxWidth: 1200,
        mobileColumns: 1,
        tabletColumns: 2,
        desktopColumns: 3,
        webColumns: 5,
      );
      expect(custom.columnsForWidth(300), 1);
      expect(custom.columnsForWidth(500), 2);
      expect(custom.columnsForWidth(900), 3);
      expect(custom.columnsForWidth(1300), 5);
    });

    test('equality and hashCode', () {
      const a = GridBreakpoints();
      const b = GridBreakpoints();
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('asserts thresholds strictly increasing', () {
      expect(
        () => GridBreakpoints(mobileMaxWidth: 800, tabletMaxWidth: 600),
        throwsAssertionError,
      );
    });
  });
}
