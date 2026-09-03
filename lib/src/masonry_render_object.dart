// Fields below need custom setters (they call markNeedsLayout), so plain
// initializing formals aren't used here.
// ignore_for_file: prefer_initializing_formals

import 'package:flutter/rendering.dart';

/// Parent data used by [RenderMasonryGrid] children — a plain box offset,
/// nothing more.
class MasonryParentData extends ContainerBoxParentData<RenderBox> {}

/// Lays out children into [columnCount] columns, placing each child in
/// whichever column is currently shortest — the classic Pinterest-style
/// "waterfall" arrangement.
///
/// Unlike [SliverGridDelegate]-based grids, tile height is *not* uniform:
/// each child is measured at its natural height for a fixed column width,
/// so children of different heights pack without leaving gaps. This is
/// an eager (non-lazy) layout — every child is laid out on every pass —
/// so it suits moderate item counts, not infinite lists.
class RenderMasonryGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MasonryParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MasonryParentData> {
  /// Creates a masonry render object.
  RenderMasonryGrid({
    required int columnCount,
    required double itemSpacing,
    required double rowSpacing,
  }) : _columnCount = columnCount,
       _itemSpacing = itemSpacing,
       _rowSpacing = rowSpacing;

  int _columnCount;

  /// Number of columns children are distributed across.
  int get columnCount => _columnCount;
  set columnCount(int value) {
    if (_columnCount == value) return;
    _columnCount = value;
    markNeedsLayout();
  }

  double _itemSpacing;

  /// Horizontal gap between columns, in logical pixels.
  double get itemSpacing => _itemSpacing;
  set itemSpacing(double value) {
    if (_itemSpacing == value) return;
    _itemSpacing = value;
    markNeedsLayout();
  }

  double _rowSpacing;

  /// Vertical gap left below each child, in logical pixels.
  double get rowSpacing => _rowSpacing;
  set rowSpacing(double value) {
    if (_rowSpacing == value) return;
    _rowSpacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MasonryParentData) {
      child.parentData = MasonryParentData();
    }
  }

  @override
  void performLayout() {
    final columns = columnCount;
    final width = constraints.maxWidth;
    final totalSpacing = itemSpacing * (columns - 1);
    final columnWidth = ((width - totalSpacing) / columns).clamp(
      0.0,
      double.infinity,
    );
    final columnHeights = List<double>.filled(columns, 0);
    final childConstraints = BoxConstraints.tightFor(width: columnWidth);

    var child = firstChild;
    while (child != null) {
      final parentData = child.parentData! as MasonryParentData;

      var shortest = 0;
      for (var i = 1; i < columns; i++) {
        if (columnHeights[i] < columnHeights[shortest]) shortest = i;
      }

      child.layout(childConstraints, parentUsesSize: true);
      final dy = columnHeights[shortest];
      parentData.offset = Offset(shortest * (columnWidth + itemSpacing), dy);
      columnHeights[shortest] = dy + child.size.height + rowSpacing;

      child = parentData.nextSibling;
    }

    final tallest = columnHeights.isEmpty
        ? 0.0
        : columnHeights.reduce((a, b) => a > b ? a : b);
    // Each column height carries one trailing rowSpacing too many.
    final contentHeight = tallest > 0 ? tallest - rowSpacing : 0.0;
    size = constraints.constrain(Size(width, contentHeight));
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
