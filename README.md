# dash_responsive_grid

Lightweight, dependency-free responsive grid widget for Flutter. Picks its
own column count from the available width — no `LayoutBuilder` or
breakpoint math required in your code — and ships with loading/empty/error
states out of the box.

* Zero external dependencies (Flutter SDK only).
* Built on `GridView.builder` under the hood — lazy, so large lists stay cheap.
* Two ways to control columns: `minColumnWidth` (auto) or `GridBreakpoints` (explicit).
* Vertical and horizontal scroll direction.
* Overridable loading / empty / error builders.

## Getting started

```yaml
dependencies:
  dash_responsive_grid: ^0.0.1
```

```dart
import 'package:dash_responsive_grid/dash_responsive_grid.dart';
```

## Usage

### Auto mode — `minColumnWidth`

Simplest API: give a minimum column width, the grid works out how many
columns fit.

```dart
ResponsiveGridView.builder(
  itemCount: items.length,
  minColumnWidth: 160,
  minColumns: 2,
  maxColumns: 6,
  itemSpacing: 12,
  rowSpacing: 12,
  padding: const EdgeInsets.all(16),
  childAspectRatio: 1,
  itemBuilder: (context, index) => MyCard(items[index]),
)
```

### Breakpoint mode — `GridBreakpoints`

Explicit column counts per device class.

```dart
ResponsiveGridView.builder(
  itemCount: items.length,
  breakpoints: const GridBreakpoints(
    mobileMaxWidth: 600,
    tabletMaxWidth: 1024,
    desktopMaxWidth: 1440,
    mobileColumns: 2,
    tabletColumns: 4,
    desktopColumns: 6,
    webColumns: 8,
  ),
  itemBuilder: (context, index) => MyCard(items[index]),
)
```

`GridBreakpoints.defaultBreakpoints` gives you the table below for free.

| Class   | Width range     | Default columns |
|---------|------------------|------------------|
| Mobile  | < 600            | 2                |
| Tablet  | 600 – 1024       | 4                |
| Desktop | 1024 – 1440      | 6                |
| Web/XL  | ≥ 1440           | 8                |

> `minColumnWidth` and `breakpoints` are both optional. If you pass both,
> `minColumnWidth` wins. If you pass neither, `GridBreakpoints.defaultBreakpoints`
> is used automatically — no crash either way.

### Loading / empty / error states

```dart
ResponsiveGridView.builder(
  itemCount: items.length,
  minColumnWidth: 160,
  isLoading: isLoading,
  hasError: hasError,
  loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
  emptyBuilder: (context) => const Center(child: Text('No items')),
  errorBuilder: (context, error) => Center(child: Text('Failed: $error')),
  itemBuilder: (context, index) => MyCard(items[index]),
)
```

`isLoading` and `hasError` are checked before `itemCount`, so you don't
need to guard the item list yourself. Leave any builder unset to fall
back to the library's default (a spinner, a "No items" message, or a
generic error message, respectively).

### Horizontal scrolling

```dart
SizedBox(
  height: 260,
  child: ResponsiveGridView.builder(
    itemCount: items.length,
    scrollDirection: Axis.horizontal,
    minColumnWidth: 120,
    itemBuilder: (context, index) => MyCard(items[index]),
  ),
)
```

In horizontal mode the cross axis is vertical, so `minColumnWidth` clamps
row height instead of column width — the grid still needs a bounded
cross-axis extent (a `SizedBox`, `Expanded`, etc.) same as any other
horizontally scrolling sliver.

Use `minRows`/`maxRows` instead of `minColumns`/`maxColumns` in this mode
for a clearer call site — they clamp the same underlying count but read
naturally when that axis is rows:

```dart
ResponsiveGridView.builder(
  itemCount: items.length,
  scrollDirection: Axis.horizontal,
  minRows: 2,
  maxRows: 2,
  itemBuilder: (context, index) => MyCard(items[index]),
)
```

`minRows`/`maxRows` are ignored when `scrollDirection` is vertical (the
default) — use `minColumns`/`maxColumns` there.

## API

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `itemCount` | `int` | required | |
| `itemBuilder` | `GridItemBuilder` | required | |
| `minColumnWidth` | `double?` | — | wins over `breakpoints` if both are set |
| `breakpoints` | `GridBreakpoints?` | — | falls back to `GridBreakpoints.defaultBreakpoints` if neither is set |
| `minColumns` / `maxColumns` | `int` | `1` / `12` | clamps resolved cross-axis count |
| `minRows` / `maxRows` | `int?` | — | horizontal-mode aliases for `minColumns`/`maxColumns`; ignored when vertical |
| `itemSpacing` / `rowSpacing` | `double` | `0` | cross/main axis gaps |
| `childAspectRatio` | `double` | `1.0` | width / height per tile |
| `padding` | `EdgeInsetsGeometry?` | — | |
| `scrollDirection` | `Axis` | `Axis.vertical` | |
| `isLoading` / `hasError` / `error` | `bool` / `bool` / `Object?` | `false` / `false` / — | checked before `itemCount` |
| `loadingBuilder` / `emptyBuilder` / `errorBuilder` | builders | — | override the default state widgets |
| `controller`, `physics`, `shrinkWrap`, `cacheExtent`, … | — | — | passed straight through to `GridView.builder` |

See the dartdoc comments on `ResponsiveGridView` for the full parameter list.

## FAQ

**Can I use a different aspect ratio per item?**
Not in v1 — all tiles in a `ResponsiveGridView` share one `childAspectRatio`,
same constraint `GridView`/`SliverGrid` have. Per-item (staggered/masonry)
layout is deliberately out of scope; see [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view) if you need that.

**Will this handle thousands of items?**
Yes — it's `GridView.builder`/`SliverGrid.builder` under the hood, so items
build lazily as they scroll into view. Tune `cacheExtent`,
`addAutomaticKeepAlives`, and `addRepaintBoundaries` for extreme cases.

**How do I pick custom breakpoints?**
Construct your own `GridBreakpoints(...)` — every threshold and column
count is overridable, or use `GridBreakpoints.defaultBreakpoints.copyWith(...)`.

## Example

See `example/` for a runnable tabbed app: a vertical responsive grid and
a horizontal responsive grid, each on its own tab.

## Additional information

Contributions and issues welcome. MIT licensed — see `LICENSE`.
