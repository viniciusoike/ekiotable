# Apply a Dense Dashboard Theme to GT Tables

**\[experimental\]**

A tight theme for tables in dashboards and other dense screens. Rows are
separated by thin gray rules instead of stripes, column labels are plain
semibold text over a blue rule, and numeric cells use a monospace font
with tabular figures. Stub, group, and summary styling follow
[`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md),
and so do the palettes.

## Usage

``` r
gt_theme_ekio_dashboard(
  data,
  density = c("compact", "dense"),
  palette = c("mountain", "wind", "blossom", "lake"),
  table_width = "100%",
  font_size = NULL,
  font_title = NULL,
  font_body = NULL,
  font_numeric = NULL,
  font_labels = NULL,
  font_stub = NULL
)
```

## Arguments

- data:

  A gt table object.

- density:

  One of `"compact"` (default) or `"dense"`. Compact uses 4px row
  padding and a 13px base size; dense uses 2px and 12px.

- palette:

  One of `"mountain"` (default), `"wind"`, `"blossom"`, or `"lake"`.
  Each uses blues and paper tones extracted from a different print.

- table_width:

  Character. Width of the table (default: `"100%"`).

- font_size:

  Numeric. Body font size in pixels. `NULL` (default) uses the size set
  by `density`. Column labels match the body; the title is 4px larger
  and notes 1px smaller.

- font_title, font_body, font_labels:

  A font family or registry key. `NULL` resolves as in
  [`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md).

- font_numeric:

  A font family or registry key for numeric body cells and summary
  values. `NULL` uses the `ekiotable.font_numeric` option and then IBM
  Plex Mono. The font must be available to the renderer; this function
  does not load it.

- font_stub:

  A font family or registry key for stub (row label) cells. `NULL` uses
  the `ekiotable.font_stub` option and then the resolved body font, so
  row labels stay with the body typography unless you move them.

## Value

A styled gt table object.

## Details

Apply the theme before any cell-specific highlighting. Other font
arguments and options follow
[`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md).
Dashboards usually need less than the full width; set `table_width` or
use
[`gt::cols_width()`](https://gt.rstudio.com/reference/cols_width.html)
when a narrow table leaves a gap after the stub.

## Examples

``` r
head(mtcars) |>
  gt::gt() |>
  gt_theme_ekio_dashboard()


  

mpg
```
