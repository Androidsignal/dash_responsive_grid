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
