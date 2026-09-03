import 'package:flutter/widgets.dart';

import 'grid_breakpoints.dart';
import 'grid_item_builder.dart';
import 'grid_state_widgets.dart';
import 'masonry_render_object.dart';
import 'responsive_grid_delegate.dart';

/// A staggered ("masonry" / Pinterest-style) grid that picks its column
/// count from the available width, the same way [ResponsiveGridView]
/// does, but lets each item keep its own natural height instead of
/// forcing a uniform tile size.
///
/// Column count is resolved exactly like [ResponsiveGridView]:
/// [minColumnWidth] for auto mode, or [breakpoints] for breakpoint mode
/// (falling back to [GridBreakpoints.defaultBreakpoints] if neither is
/// supplied), clamped by [minColumns]/[maxColumns].
///
/// Unlike [ResponsiveGridView], this widget lays out every item eagerly
/// in a plain [SingleChildScrollView] (there is no lazy builder
/// underneath) so each item's height can be measured and packed into
/// the shortest column. That makes it a good fit for moderate item
/// counts — a feed, a gallery section, a dashboard of unevenly sized
/// cards — not for very long or infinite lists.
///
/// ```dart
/// ResponsiveMasonryGridView.builder(
///   itemCount: items.length,
///   itemBuilder: (context, index) => MyCard(items[index]),
///   minColumnWidth: 160,
///   itemSpacing: 12,
///   rowSpacing: 12,
///   padding: const EdgeInsets.all(16),
/// )
/// ```
class ResponsiveMasonryGridView extends StatelessWidget {
  /// Creates a masonry-style responsive grid.
  ///
  /// [minColumnWidth] and [breakpoints] are both optional — see the
  /// class docs for how the fallback is resolved.
  const ResponsiveMasonryGridView.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minColumnWidth,
    this.breakpoints,
    this.minColumns = 1,
    this.maxColumns = 12,
    this.itemSpacing = 0,
    this.rowSpacing = 0,
    this.padding,
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
  }) : assert(itemCount >= 0);

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

  /// Lower clamp applied to the resolved column count. Default `1`.
  final int minColumns;

  /// Upper clamp applied to the resolved column count. Default `12`.
  final int maxColumns;

  /// Horizontal gap between columns, in logical pixels.
  final double itemSpacing;

  /// Vertical gap left below each item, in logical pixels.
  final double rowSpacing;

  /// Padding around the grid.
  final EdgeInsetsGeometry? padding;

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

  /// Scroll controller for the built-in scroll view. Ignored when
  /// [shrinkWrap] is `true`, since no scroll view is created then.
  final ScrollController? controller;

  /// Whether the built-in scroll view is the primary scroll view
  /// associated with the parent [PrimaryScrollController]. Ignored when
  /// [shrinkWrap] is `true`.
  final bool? primary;

  /// When `true`, the grid sizes itself to its content and does not
  /// create its own scroll view — use this to nest it inside another
  /// scrollable (e.g. a [CustomScrollView] or [ListView]).
  final bool shrinkWrap;

  /// Scroll physics for the built-in scroll view. Ignored when
  /// [shrinkWrap] is `true`.
  final ScrollPhysics? physics;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = ResponsiveSliverGridDelegate(
          minColumnWidth: minColumnWidth,
          breakpoints: breakpoints,
          minColumns: minColumns,
          maxColumns: maxColumns,
        ).getColumnCount(constraints.maxWidth);

        Widget grid = _MasonryLayout(
          columnCount: columnCount,
          itemSpacing: itemSpacing,
          rowSpacing: rowSpacing,
          children: [
            for (var i = 0; i < itemCount; i++) itemBuilder(context, i),
          ],
        );

        if (padding != null) {
          grid = Padding(padding: padding!, child: grid);
        }

        if (shrinkWrap) {
          return grid;
        }

        return SingleChildScrollView(
          controller: controller,
          primary: primary,
          physics: physics,
          child: grid,
        );
      },
    );
  }
}

/// [MultiChildRenderObjectWidget] wiring for [RenderMasonryGrid].
class _MasonryLayout extends MultiChildRenderObjectWidget {
  const _MasonryLayout({
    required this.columnCount,
    required this.itemSpacing,
    required this.rowSpacing,
    required super.children,
  });

  final int columnCount;
  final double itemSpacing;
  final double rowSpacing;

  @override
  RenderMasonryGrid createRenderObject(BuildContext context) {
    return RenderMasonryGrid(
      columnCount: columnCount,
      itemSpacing: itemSpacing,
      rowSpacing: rowSpacing,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMasonryGrid renderObject) {
    renderObject
      ..columnCount = columnCount
      ..itemSpacing = itemSpacing
      ..rowSpacing = rowSpacing;
  }
}
