/// Width thresholds and column counts used to resolve a column count
/// for a given available width when [ResponsiveGridView] is used in
/// breakpoint mode (i.e. no `minColumnWidth` is supplied).
///
/// Four device classes are recognised, each with its own upper width
/// bound and column count:
///
/// | Class   | Width range           | Default columns |
/// |---------|------------------------|------------------|
/// | Mobile  | < [mobileMaxWidth]     | [mobileColumns]  |
/// | Tablet  | < [tabletMaxWidth]     | [tabletColumns]  |
/// | Desktop | < [desktopMaxWidth]    | [desktopColumns] |
/// | Web/XL  | >= [desktopMaxWidth]   | [webColumns]     |
class GridBreakpoints {
  /// Creates a set of responsive breakpoints.
  ///
  /// All thresholds must be positive and strictly increasing
  /// (`mobileMaxWidth < tabletMaxWidth < desktopMaxWidth`), and all
  /// column counts must be at least 1.
  const GridBreakpoints({
    this.mobileMaxWidth = 600,
    this.tabletMaxWidth = 1024,
    this.desktopMaxWidth = 1440,
    this.mobileColumns = 2,
    this.tabletColumns = 4,
    this.desktopColumns = 6,
    this.webColumns = 8,
  }) : assert(mobileMaxWidth > 0, 'mobileMaxWidth must be positive'),
       assert(
         tabletMaxWidth > mobileMaxWidth,
         'tabletMaxWidth must be greater than mobileMaxWidth',
       ),
       assert(
         desktopMaxWidth > tabletMaxWidth,
         'desktopMaxWidth must be greater than tabletMaxWidth',
       ),
       assert(mobileColumns > 0, 'mobileColumns must be at least 1'),
       assert(tabletColumns > 0, 'tabletColumns must be at least 1'),
       assert(desktopColumns > 0, 'desktopColumns must be at least 1'),
       assert(webColumns > 0, 'webColumns must be at least 1');

  /// Upper width bound (exclusive) for the mobile class. Default `600`.
  final double mobileMaxWidth;

  /// Upper width bound (exclusive) for the tablet class. Default `1024`.
  final double tabletMaxWidth;

  /// Upper width bound (exclusive) for the desktop class. Default `1440`.
  /// Widths at or above this value are treated as web/XL.
  final double desktopMaxWidth;

  /// Column count used below [mobileMaxWidth]. Default `2`.
  final int mobileColumns;

  /// Column count used below [tabletMaxWidth]. Default `4`.
  final int tabletColumns;

  /// Column count used below [desktopMaxWidth]. Default `6`.
  final int desktopColumns;

  /// Column count used at or above [desktopMaxWidth]. Default `8`.
  final int webColumns;

  /// The library default breakpoint set (mobile: 2, tablet: 4,
  /// desktop: 6, web: 8).
  static const GridBreakpoints defaultBreakpoints = GridBreakpoints();

  /// Resolves the column count for the given [width].
  ///
  /// Boundaries are inclusive on the lower end of each range: a width
  /// exactly equal to a threshold falls into the *next* (wider) class.
  int columnsForWidth(double width) {
    if (width < mobileMaxWidth) return mobileColumns;
    if (width < tabletMaxWidth) return tabletColumns;
    if (width < desktopMaxWidth) return desktopColumns;
    return webColumns;
  }

  /// Returns a copy of this [GridBreakpoints] with the given fields
  /// replaced.
  GridBreakpoints copyWith({
    double? mobileMaxWidth,
    double? tabletMaxWidth,
    double? desktopMaxWidth,
    int? mobileColumns,
    int? tabletColumns,
    int? desktopColumns,
    int? webColumns,
  }) {
    return GridBreakpoints(
      mobileMaxWidth: mobileMaxWidth ?? this.mobileMaxWidth,
      tabletMaxWidth: tabletMaxWidth ?? this.tabletMaxWidth,
      desktopMaxWidth: desktopMaxWidth ?? this.desktopMaxWidth,
      mobileColumns: mobileColumns ?? this.mobileColumns,
      tabletColumns: tabletColumns ?? this.tabletColumns,
      desktopColumns: desktopColumns ?? this.desktopColumns,
      webColumns: webColumns ?? this.webColumns,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GridBreakpoints &&
        other.mobileMaxWidth == mobileMaxWidth &&
        other.tabletMaxWidth == tabletMaxWidth &&
        other.desktopMaxWidth == desktopMaxWidth &&
        other.mobileColumns == mobileColumns &&
        other.tabletColumns == tabletColumns &&
        other.desktopColumns == desktopColumns &&
        other.webColumns == webColumns;
  }

  @override
  int get hashCode => Object.hash(
    mobileMaxWidth,
    tabletMaxWidth,
    desktopMaxWidth,
    mobileColumns,
    tabletColumns,
    desktopColumns,
    webColumns,
  );

  @override
  String toString() {
    return 'GridBreakpoints(mobile: <$mobileMaxWidth → $mobileColumns cols, '
        'tablet: <$tabletMaxWidth → $tabletColumns cols, '
        'desktop: <$desktopMaxWidth → $desktopColumns cols, '
        'web: >=$desktopMaxWidth → $webColumns cols)';
  }
}
