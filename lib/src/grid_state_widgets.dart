import 'package:flutter/material.dart';

/// Default widget shown while `ResponsiveGridView.isLoading` is `true`
/// and no `loadingBuilder` was supplied.
class DefaultGridLoadingWidget extends StatelessWidget {
  /// Creates the default loading widget.
  const DefaultGridLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// Default widget shown when `itemCount == 0` and not loading, and no
/// `emptyBuilder` was supplied.
class DefaultGridEmptyWidget extends StatelessWidget {
  /// Creates the default empty-state widget.
  const DefaultGridEmptyWidget({super.key, this.message = 'No items'});

  /// Message displayed in the empty state. Defaults to `'No items'`.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

/// Default widget shown when `hasError == true` and no `errorBuilder`
/// was supplied.
class DefaultGridErrorWidget extends StatelessWidget {
  /// Creates the default error-state widget.
  const DefaultGridErrorWidget({super.key, this.error});

  /// Optional error object/details to describe.
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error != null ? 'Something went wrong: $error' : 'Something went wrong',
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
