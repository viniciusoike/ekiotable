# ekiotable (development version)

* `gt_theme_ekio()` now draws the table, heading, source notes, and footnotes
  on the warm offwhite surface `#FBFBF6`, matching the `ekioplot::theme_ekio()`
  default. A chart and a table in one document no longer disagree about the
  background.

* Added the `background` argument to `gt_theme_ekio()`, which takes the same
  surfaces as `ekioplot::theme_ekio()`: `"offwhite"`, `"white"`, `"cold"`,
  `"transparent"`, or a hex code.

* Replaced the two identity-palette colors in `gt_theme_ekio()` with rungs of
  the generated blue scale. Rules and row group headings moved from Baltic Blue
  to `blue.600`, and the summary row band moved from Soft Linen 2 to
  `blue.100`. The theme now sources every color from the scales, and
  `ekio_brand` is reserved for identity work.

* Refreshed the pinned surface tokens against ekioplot 1.1.2: `offwhite` is
  `#FBFBF6` rather than the near-white `#FEFEFE`, and `cold` (`#F6F7F8`) was
  added. `ekio_brand` is no longer copied into the package and resolves through
  `ekioplot::ekio_pal()` instead.

# ekiotable 0.1.0

* Color tokens now resolve by name, including named shades and local basic and brand colors, with informative errors for unknown colors.
* `gt_theme_ekio()` now uses Lora for titles and supports configurable title, body, numeric, and label fonts through arguments and options.
* `gt_theme_ekio()` validates its arguments and preserves styles across tables with missing or partially populated summary groups. Text on blue fills follows the palette contrast choice.

* `gt_theme_ekio()` now uses the former alternative styling, with unfilled group headings, Baltic Blue rules, tabular numerals, and no automatic footer. The experimental `gt_theme_ekio_alt()` name has been removed.

* `gt_theme_hokusai()` adds a minimal blue theme with four palettes extracted from Hokusai reproductions: mountain, wind, blossom, and lake. A shared neutral gray scale supplies gridline, divider, and zebra stripe colors.

* `gt_theme_hokusai()` supports optional light-gray cell gridlines with `gridlines = TRUE` and uses dark-gray body text, column labels, subtitles, and notes, reserving blue for emphasis. Zebra stripes now extend across stub labels.

* `gt_theme_hokusai()` gains a `reversed` argument for blue column-label and spanner backgrounds with paper-colored text and rules.

* Changed the `gt_theme_hokusai()` default `font_size` to 12 and set column labels 2px above the body instead of 1px below. The title, subtitle, source notes, and footnotes keep their previous sizes.

* Fixed the column-label weight for families that ship semibold under a separate family name. `gt_theme_hokusai()` now names `Host Grotesk SemiBold` ahead of `Host Grotesk` in the label font stack, so weight 600 no longer falls through to the bold face.

* `gt_theme_hokusai()` gains a `font_stub` argument for the font of stub (row label) cells. It defaults to the resolved body font, and it accepts the `ekiotable.font_stub` option. Stub cells now name their family explicitly, so their semibold weight resolves the same way column labels do.

* Cell-level fonts in `gt_theme_hokusai()` now carry the same system fallbacks that `gt::opt_table_font()` appends. Titles, subtitles, column labels, spanners, numerals, and stub cells previously named a bare family, so a missing font dropped those cells to the browser default while the rest of the table dropped to `system-ui`.
