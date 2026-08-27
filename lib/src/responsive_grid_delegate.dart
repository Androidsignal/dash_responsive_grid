import 'package:flutter/rendering.dart';

import 'grid_breakpoints.dart';

/// A [SliverGridDelegate] that recomputes its column count from the
/// available cross-axis extent on every layout pass, instead of taking
/// a fixed column count up front.
///
/// Column count is resolved one of two ways:
///
/// * **Auto mode** — supply [minColumnWidth]. Column count is
///   `(crossAxisExtent / minColumnWidth).floor()`, clamped to
///   [minColumns]/[maxColumns].
/// * **Breakpoint mode** — supply [breakpoints]. Column count is looked
///   up from [GridBreakpoints.columnsForWidth], then clamped to
///   [minColumns]/[maxColumns].
///
/// If both are supplied, [minColumnWidth] wins. If neither is supplied,
/// [GridBreakpoints.defaultBreakpoints] is used — this delegate never
/// throws over which mode is active.
class ResponsiveSliverGridDelegate extends SliverGridDelegate {
  /// Creates a responsive sliver grid delegate.
  ///
  /// [minColumnWidth] and [breakpoints] are both optional — see the
  /// class docs for how the fallback is resolved.
  const ResponsiveSliverGridDelegate({
    this.minColumnWidth,
    this.breakpoints,
    this.minColumns = 1,
    this.maxColumns = 12,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.childAspectRatio = 1,
  }) : assert(minColumnWidth == null || minColumnWidth > 0),
       assert(minColumns > 0),
       assert(maxColumns >= minColumns),
       assert(crossAxisSpacing >= 0),
       assert(mainAxisSpacing >= 0),
       assert(childAspectRatio > 0);

  /// Minimum width (logical pixels) each column must have, used to
  /// derive column count in auto mode. Takes priority over
  /// [breakpoints] when both are supplied.
  final double? minColumnWidth;

  /// Explicit width-threshold column map, used in breakpoint mode.
  /// Ignored if [minColumnWidth] is also supplied. Falls back to
  /// [GridBreakpoints.defaultBreakpoints] if neither is supplied.
  final GridBreakpoints? breakpoints;

  /// Lower clamp applied to the resolved column count. Default `1`.
  final int minColumns;

  /// Upper clamp applied to the resolved column count. Default `12`.
  final int maxColumns;

  /// Horizontal gap between columns, in logical pixels.
  final double crossAxisSpacing;

  /// Vertical gap between rows, in logical pixels.
  final double mainAxisSpacing;

  /// Width / height ratio applied to every tile.
  final double childAspectRatio;

  /// Resolves the clamped column count for the given [crossAxisExtent].
  int getColumnCount(double crossAxisExtent) {
    final width = minColumnWidth;
    final raw = width != null
        ? (crossAxisExtent / width).floor()
        : (breakpoints ?? GridBreakpoints.defaultBreakpoints).columnsForWidth(
            crossAxisExtent,
          );
    return raw.clamp(minColumns, maxColumns);
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final crossAxisCount = getColumnCount(constraints.crossAxisExtent);
    final usableCrossAxisExtent =
        constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1);
    final childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final childMainAxisExtent = childCrossAxisExtent / childAspectRatio;
    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(covariant ResponsiveSliverGridDelegate oldDelegate) {
    return oldDelegate.minColumnWidth != minColumnWidth ||
        oldDelegate.breakpoints != breakpoints ||
        oldDelegate.minColumns != minColumns ||
        oldDelegate.maxColumns != maxColumns ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.childAspectRatio != childAspectRatio;
  }
}
