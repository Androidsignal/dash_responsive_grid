import 'package:flutter/widgets.dart';

/// Builds the widget for the item at [index].
///
/// Used by `ResponsiveGridView.builder` the same way
/// [IndexedWidgetBuilder] is used by [GridView.builder] / [ListView.builder].
typedef GridItemBuilder = Widget Function(BuildContext context, int index);

/// Builds the widget shown while `ResponsiveGridView.isLoading` is `true`.
///
/// Falls back to a centered [CircularProgressIndicator] when not supplied.
typedef GridLoadingBuilder = Widget Function(BuildContext context);

/// Builds the widget shown when `itemCount == 0` and not loading.
///
/// Falls back to a centered "No items" message when not supplied.
typedef GridEmptyBuilder = Widget Function(BuildContext context);

/// Builds the widget shown when `hasError == true`.
///
/// [error] carries the optional error object/details passed through by the
/// caller. Falls back to a centered error message when not supplied.
typedef GridErrorBuilder = Widget Function(BuildContext context, Object? error);
