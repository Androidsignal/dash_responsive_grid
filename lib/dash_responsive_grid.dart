/// Lightweight, dependency-free responsive grid widget for Flutter.
///
/// Auto-picks a column count from screen width — via `minColumnWidth`
/// (auto mode) or a [GridBreakpoints] map (breakpoint mode) — with
/// built-in loading/empty/error states.
library;

export 'src/grid_breakpoints.dart';
export 'src/grid_item_builder.dart';
export 'src/grid_state_widgets.dart'
    show
        DefaultGridEmptyWidget,
        DefaultGridErrorWidget,
        DefaultGridLoadingWidget;
export 'src/responsive_grid_view.dart';
export 'src/responsive_masonry_grid_view.dart';
