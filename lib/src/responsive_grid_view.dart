import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/widgets.dart';

import 'grid_breakpoints.dart';
import 'grid_item_builder.dart';
import 'grid_state_widgets.dart';
import 'responsive_grid_delegate.dart';

/// A [GridView] that picks its column count from the available width,
/// with no layout math required from the caller.
///
/// Two ways to control column count:
///
/// * **Auto mode** — pass [minColumnWidth]. Column count is derived as
///   `(availableWidth / minColumnWidth).floor()`, clamped by
///   [minColumns]/[maxColumns].
/// * **Breakpoint mode** — pass [breakpoints] (e.g.
///   [GridBreakpoints.defaultBreakpoints]). Column count is looked up by
///   width range (mobile/tablet/desktop/web).
///
/// If both are supplied, [minColumnWidth] wins. If neither is supplied,
/// [GridBreakpoints.defaultBreakpoints] is used automatically.
///
/// The resolved count is clamped by [minColumns]/[maxColumns]. When
/// [scrollDirection] is [Axis.horizontal] that same count reads as rows,
/// not columns — use [minRows]/[maxRows] instead for clearer call sites;
/// they override [minColumns]/[maxColumns] in that case.
///
/// Built on [GridView.builder] under the hood, so items are built lazily
/// and large lists stay cheap.
///
/// ```dart
/// ResponsiveGridView.builder(
///   itemCount: items.length,
///   itemBuilder: (context, index) => MyCard(items[index]),
///   minColumnWidth: 160,
///   itemSpacing: 12,
///   rowSpacing: 12,
///   padding: const EdgeInsets.all(16),
/// )
/// ```
class ResponsiveGridView extends StatelessWidget {
  /// Creates a lazily-built responsive grid.
  ///
  /// [minColumnWidth] and [breakpoints] are both optional — see the
  /// class docs for how the fallback is resolved.
  const ResponsiveGridView.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minColumnWidth,
    this.breakpoints,
    this.minColumns = 1,
    this.maxColumns = 12,
    this.minRows,
    this.maxRows,
    this.itemSpacing = 0,
    this.rowSpacing = 0,
    this.padding,
    this.childAspectRatio = 1,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.isLoading = false,
    this.hasError = false,
    this.error,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.controller,
    this.primary,
    this.shrinkWrap = false,
    this.physics,
    this.cacheExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : assert(itemCount >= 0),
       assert(minRows == null || minRows > 0),
       assert(maxRows == null || maxRows > 0),
       assert(
         minRows == null || maxRows == null || maxRows >= minRows,
         'maxRows must be >= minRows',
       );

  /// Number of items to build. Ignored while [isLoading] or [hasError]
  /// is `true`, or when it is `0` (the empty state is shown instead).
  final int itemCount;

  /// Builds the widget for the item at a given index.
  final GridItemBuilder itemBuilder;

  /// Minimum column width driving auto column-count mode. Takes
  /// priority over [breakpoints] when both are supplied.
  final double? minColumnWidth;

  /// Explicit breakpoint map driving breakpoint mode. Ignored if
  /// [minColumnWidth] is also supplied. Falls back to
  /// [GridBreakpoints.defaultBreakpoints] if neither is supplied.
  final GridBreakpoints? breakpoints;

  /// Lower clamp applied to the resolved cross-axis count. Default `1`.
  /// Ignored when [scrollDirection] is [Axis.horizontal] and [minRows]
  /// is supplied.
  final int minColumns;

  /// Upper clamp applied to the resolved cross-axis count. Default `12`.
  /// Ignored when [scrollDirection] is [Axis.horizontal] and [maxRows]
  /// is supplied.
  final int maxColumns;

  /// Lower clamp applied to the resolved cross-axis count, for
  /// horizontally scrolling grids where that axis reads as rows rather
  /// than columns. Only used when [scrollDirection] is
  /// [Axis.horizontal]; overrides [minColumns] when set. `null` (the
  /// default) falls back to [minColumns].
  final int? minRows;

  /// Upper clamp applied to the resolved cross-axis count, for
  /// horizontally scrolling grids where that axis reads as rows rather
  /// than columns. Only used when [scrollDirection] is
  /// [Axis.horizontal]; overrides [maxColumns] when set. `null` (the
  /// default) falls back to [maxColumns].
  final int? maxRows;

  /// Horizontal gap between items, in logical pixels.
  final double itemSpacing;

  /// Vertical gap between rows, in logical pixels.
  final double rowSpacing;

  /// Padding around the grid.
  final EdgeInsetsGeometry? padding;

  /// Width / height ratio applied to every tile. Default `1.0`.
  final double childAspectRatio;

  /// Scroll axis. Default [Axis.vertical].
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction reversed.
  final bool reverse;

  /// When `true`, shows [loadingBuilder] (or the default spinner)
  /// instead of the grid.
  final bool isLoading;

  /// When `true`, shows [errorBuilder] (or the default error message)
  /// instead of the grid.
  final bool hasError;

  /// Optional error object/details forwarded to [errorBuilder].
  final Object? error;

  /// Builds the loading state. Defaults to a centered spinner.
  final GridLoadingBuilder? loadingBuilder;

  /// Builds the empty state, shown when [itemCount] is `0` and not
  /// loading. Defaults to a centered "No items" message.
  final GridEmptyBuilder? emptyBuilder;

  /// Builds the error state, shown when [hasError] is `true`. Defaults
  /// to a centered error message.
  final GridErrorBuilder? errorBuilder;

  /// Scroll controller passed through to the underlying [GridView].
  final ScrollController? controller;

  /// Whether this is the primary scroll view associated with the
  /// parent [PrimaryScrollController].
  final bool? primary;

  /// Whether the extent of the scroll view should be determined by the
  /// contents being viewed.
  final bool shrinkWrap;

  /// Scroll physics passed through to the underlying [GridView].
  final ScrollPhysics? physics;

  /// Cache extent passed through to the underlying [GridView.builder]
  /// for perf tuning of large lists.
  final double? cacheExtent;

  /// Passed through to [SliverChildBuilderDelegate.addAutomaticKeepAlives].
  final bool addAutomaticKeepAlives;

  /// Passed through to [SliverChildBuilderDelegate.addRepaintBoundaries].
  final bool addRepaintBoundaries;

  /// Passed through to [SliverChildBuilderDelegate.addSemanticIndexes].
  final bool addSemanticIndexes;

  /// Passed through to the underlying [GridView.builder].
  final DragStartBehavior dragStartBehavior;

  /// Passed through to the underlying [GridView.builder].
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Passed through to the underlying [GridView.builder].
  final String? restorationId;

  /// Passed through to the underlying [GridView.builder].
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingBuilder?.call(context) ?? const DefaultGridLoadingWidget();
    }
    if (hasError) {
      return errorBuilder?.call(context, error) ??
          DefaultGridErrorWidget(error: error);
    }
    if (itemCount == 0) {
      return emptyBuilder?.call(context) ?? const DefaultGridEmptyWidget();
    }

    final isHorizontal = scrollDirection == Axis.horizontal;
    final delegate = ResponsiveSliverGridDelegate(
      minColumnWidth: minColumnWidth,
      breakpoints: breakpoints,
      minColumns: (isHorizontal ? minRows : null) ?? minColumns,
      maxColumns: (isHorizontal ? maxRows : null) ?? maxColumns,
      crossAxisSpacing: itemSpacing,
      mainAxisSpacing: rowSpacing,
      childAspectRatio: childAspectRatio,
    );

    return GridView.builder(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      gridDelegate: delegate,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      // ignore: deprecated_member_use
      cacheExtent: cacheExtent,
    );
  }
}
