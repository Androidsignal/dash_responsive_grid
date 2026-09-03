## 0.0.2

* `ResponsiveMasonryGridView.builder` — staggered ("masonry" / Pinterest-style)
  grid. Each item keeps its own natural height and is packed into whichever
  column is currently shortest, instead of a uniform tile size.
* Column count for the masonry grid resolves the same way as
  `ResponsiveGridView`: `minColumnWidth` (auto mode) or `breakpoints`
  (breakpoint mode), clamped by `minColumns`/`maxColumns`.
* Same built-in loading / empty / error states, `itemSpacing`/`rowSpacing`,
  `padding`, and `shrinkWrap` support as `ResponsiveGridView`.
* Layout is eager (not lazy) — every item is measured to compute its
  placement — so it suits moderate item counts (a feed, a gallery section),
  not very long or infinite lists. Use `ResponsiveGridView` for those.

## 0.0.1

Initial release.

* `ResponsiveGridView.builder` — lazy, `GridView.builder`-backed responsive grid.
* Auto column mode via `minColumnWidth`, clamped by `minColumns`/`maxColumns`.
* Breakpoint mode via `GridBreakpoints` (mobile/tablet/desktop/web).
* `minColumnWidth`/`breakpoints` are both optional — `minColumnWidth` wins if
  both are set, `GridBreakpoints.defaultBreakpoints` is used if neither is.
* `minRows`/`maxRows` — row-semantic aliases for `minColumns`/`maxColumns`,
  used when `scrollDirection` is `Axis.horizontal`.
* Built-in loading / empty / error states with overridable builders.
* Vertical and horizontal scroll direction support.
* Zero external dependencies (Flutter SDK only).
