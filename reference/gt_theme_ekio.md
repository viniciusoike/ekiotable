# Apply the EKIO Theme to GT Tables

EKIO styling for gt table objects. It uses a blue column-label band,
blue rules above unfilled group headings, and tabular figures for body
numerals. The table sits on the same warm offwhite surface as
[`ekioplot::theme_ekio()`](https://viniciusoike.github.io/ekioplot/reference/theme_ekio.html),
so a chart and a table in one document share a background. No footer is
added.

## Usage

``` r
gt_theme_ekio(
  data,
  table_width = "100%",
  font_size = 14,
  stripe = TRUE,
  font_title = NULL,
  font_body = NULL,
  font_numeric = NULL,
  font_labels = NULL,
  background = "offwhite"
)
```

## Arguments

- data:

  A gt table object.

- table_width:

  Character. Width of the table (default: `"100%"`).

- font_size:

  Numeric. Base font size in pixels (default: 14).

- stripe:

  Logical. Apply alternating row striping (default: `TRUE`).

- font_title, font_body, font_numeric, font_labels:

  A font family or registry key (`lora`, `lato`, `georgia`,
  `roboto_slab`, `fira_code`, `host_grotesk`). `NULL` uses the
  corresponding `ekiotable.font_<role>` option. Title and body then use
  `ekioplot.font_title` and `ekioplot.font_text`, respectively, before
  falling back to Lora and Lato. Numeric and label fonts inherit the
  resolved body font unless explicitly set or configured through their
  role option. Fonts must be available to the renderer; this function
  does not install them.

- background:

  Character. Table surface, using the same vocabulary as
  [`ekioplot::theme_ekio()`](https://viniciusoike.github.io/ekioplot/reference/theme_ekio.html):
  `"offwhite"` (default, `#FBFBF6`, a warm white), `"white"`, `"cold"`
  (`#F6F7F8`, a cool white), or `"transparent"` to let the page show
  through. A hex code is also accepted, though only the named surfaces
  are checked for contrast against the brand scales.

## Value

A styled gt table object.

## Examples

``` r
library(gt)
head(mtcars, 10) |>
  gt() |>
  gt_theme_ekio()


  

mpg
```
