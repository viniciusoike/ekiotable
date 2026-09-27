# ekiotable (development version)

* Added `gt_theme_ekio_dashboard()`, an experimental theme for dashboards.
  It uses the Hokusai palettes, plain column labels over a blue rule, thin
  gray row rules instead of stripes, and IBM Plex Mono for numeric cells.
  `density = "compact"` or `"dense"` sets row padding and the base size.

* Added `ibm_plex_mono` to the font registry.

* Promoted `gt_theme_hokusai()` to the recommended theme for reports and
  articles, and removed its experimental badge. `gt_theme_ekio()` stays
  available with its current look.

* Changed `gt_theme_hokusai()` defaults to `reversed = TRUE`, `stripe = TRUE`,
  and `font_size = 14`. Pass `reversed = FALSE, stripe = FALSE, font_size = 12`
  for the previous look.

* Replaced the summary fills in `gt_theme_hokusai()` with rules. A thin gray
  rule opens each group summary and a double blue rule opens the grand
  summary; the blue rule of the next row group now survives below a summary.

* Tightened the `gt_theme_hokusai()` header band: column labels use 8px
  padding, and spanners use the same semibold weight as labels.

* Changed row group headings in `gt_theme_ekio()` and `gt_theme_hokusai()` to
  the body text color. The blue rule above each group stays, and blue now marks
  only summary rows, so a group heading no longer reads as a total.

* Fixed stub labels centering when the stub column is a factor. Both themes
  now left-align the stub and, in grouped tables, indent row labels under
  their group heading.

* Fixed the stubhead ignoring the column label style. It now takes the same
  color, weight, and fill as the other column labels.

* Fixed hairline seams between filled column label cells, visible in
  `gt_theme_ekio()` and in `gt_theme_hokusai(reversed = TRUE)`.

* Fixed tabular figures leaking to other tables. Both themes set
  `font-variant-numeric` on their own body, stub, and summary cells instead
  of adding an unscoped `.gt_row` rule, which in knitr and Quarto output
  reached every gt table on the page.

* Added GitHub Actions workflows for `R CMD check` and pkgdown. The checks run
  on macOS, Windows, and Linux across R release, devel, and the four previous
  releases. pkgdown builds the package site and deploys it to GitHub Pages on
  every push to `master` and on release.

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
