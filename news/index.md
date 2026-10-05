# Changelog

## ekiotable 0.2.0

### Breaking changes

- Promoted
  [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  to the recommended theme for reports and articles, and removed its
  experimental badge.
  [`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md)
  stays available.

- Changed
  [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  defaults to `reversed = TRUE`, `stripe = TRUE`, and `font_size = 14`.
  Pass `reversed = FALSE, stripe = FALSE, font_size = 12` for the
  previous look.

- [`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md)
  now draws the table, heading, source notes, and footnotes on the warm
  offwhite surface `#FBFBF6`, matching the
  [`ekioplot::theme_ekio()`](https://viniciusoike.github.io/ekioplot/reference/theme_ekio.html)
  default. Pass `background = "white"` for the previous surface.

- Replaced the two identity-palette colors in
  [`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md)
  with rungs of the generated blue scale. Rules moved from Baltic Blue
  to `blue.600`, and the summary row band moved from Soft Linen 2 to
  `blue.100`.

### New features

- Added
  [`gt_theme_ekio_dashboard()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio_dashboard.md),
  an experimental theme for dashboards. It uses the Hokusai palettes,
  plain column labels over a blue rule, thin gray row rules instead of
  stripes, and IBM Plex Mono for numeric cells. `density = "compact"` or
  `"dense"` sets row padding and the base size.

- Added the `background` argument to
  [`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md),
  which takes the same surfaces as
  [`ekioplot::theme_ekio()`](https://viniciusoike.github.io/ekioplot/reference/theme_ekio.html):
  `"offwhite"`, `"white"`, `"card"`, `"cold"`, `"transparent"`, or a hex
  code. `"card"` (`#FFFFFC`) suits tables placed on cards in sites and
  dashboards.

- Added `ibm_plex_mono` to the font registry.

- Added the `card`, `nav`, `sunk`, and `sunk_text` surface tokens from
  ekioplot, and refreshed `offwhite` (`#FBFBF6`, previously `#FEFEFE`)
  and `cold` (`#F6F7F8`) against ekioplot 1.1.2. `ekio_brand` now
  resolves through
  [`ekioplot::ekio_pal()`](https://viniciusoike.github.io/ekioplot/reference/ekio_pal.html)
  instead of a local copy.

### Minor improvements

- Replaced the summary fills in
  [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  with rules. A thin gray rule opens each group summary and a double
  blue rule opens the grand summary; the blue rule of the next row group
  now survives below a summary.

- Tightened the
  [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  header band: column labels use 8px padding, and spanners use the same
  semibold weight as labels.

- Changed row group headings in
  [`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md)
  and
  [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  to the body text color. The blue rule above each group stays, and blue
  now marks only summary rows, so a group heading no longer reads as a
  total.

- The pkgdown site now uses the shared ekiopkgdown template, and GitHub
  Actions run `R CMD check` on macOS, Windows, and Linux and deploy the
  site.

### Bug fixes

- Fixed tabular figures leaking to other tables. Both themes set
  `font-variant-numeric` on their own body, stub, and summary cells
  instead of adding an unscoped `.gt_row` rule, which in knitr and
  Quarto output reached every gt table on the page.

- Fixed stub labels centering when the stub column is a factor. Both
  themes now left-align the stub and, in grouped tables, indent row
  labels under their group heading.

- Fixed the stubhead ignoring the column label style. It now takes the
  same color, weight, and fill as the other column labels.

- Fixed hairline seams between filled column label cells, visible in
  [`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md)
  and in `gt_theme_hokusai(reversed = TRUE)`.

## ekiotable 0.1.0

- Color tokens now resolve by name, including named shades and local
  basic and brand colors, with informative errors for unknown colors.

- [`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md)
  now uses Lora for titles and supports configurable title, body,
  numeric, and label fonts through arguments and options.

- [`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md)
  validates its arguments and preserves styles across tables with
  missing or partially populated summary groups. Text on blue fills
  follows the palette contrast choice.

- [`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md)
  now uses the former alternative styling, with unfilled group headings,
  Baltic Blue rules, tabular numerals, and no automatic footer. The
  experimental `gt_theme_ekio_alt()` name has been removed.

- [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  adds a minimal blue theme with four palettes extracted from Hokusai
  reproductions: mountain, wind, blossom, and lake. A shared neutral
  gray scale supplies gridline, divider, and zebra stripe colors.

- [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  supports optional light-gray cell gridlines with `gridlines = TRUE`
  and uses dark-gray body text, column labels, subtitles, and notes,
  reserving blue for emphasis. Zebra stripes now extend across stub
  labels.

- [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  gains a `reversed` argument for blue column-label and spanner
  backgrounds with paper-colored text and rules.

- Changed the
  [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  default `font_size` to 12 and set column labels 2px above the body
  instead of 1px below. The title, subtitle, source notes, and footnotes
  keep their previous sizes.

- Fixed the column-label weight for families that ship semibold under a
  separate family name.
  [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  now names `Host Grotesk SemiBold` ahead of `Host Grotesk` in the label
  font stack, so weight 600 no longer falls through to the bold face.

- [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  gains a `font_stub` argument for the font of stub (row label) cells.
  It defaults to the resolved body font, and it accepts the
  `ekiotable.font_stub` option. Stub cells now name their family
  explicitly, so their semibold weight resolves the same way column
  labels do.

- Cell-level fonts in
  [`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
  now carry the same system fallbacks that
  [`gt::opt_table_font()`](https://gt.rstudio.com/reference/opt_table_font.html)
  appends. Titles, subtitles, column labels, spanners, numerals, and
  stub cells previously named a bare family, so a missing font dropped
  those cells to the browser default while the rest of the table dropped
  to `system-ui`.
