# Table theme gallery

Compare the themes on two reusable tables: a compact example with four
rows and two spanners, and a complete example with row groups,
subtotals, a grand total, footnotes, and a source note. The examples
adapt the cars and pizza sales prototypes and use datasets bundled with
**gt**.

Build the table first, including summaries and notes, then apply the
theme. The Hokusai examples use the theme defaults, a blue header band
and striped rows, and change only the palette. Compare the title, the
header band, and the rules that open each group and summary.

## Build the examples

``` r

library(ekiotable)
library(gt)
```

### Compact table

Four cars, a simple title, row labels, and spanners for performance and
fuel economy keep the structure small enough to compare at a glance.

``` r

cars_data <- gtcars[order(gtcars$msrp, decreasing = TRUE), ]
cars_data <- cars_data[
  seq_len(4),
  c("model", "hp", "trq", "mpg_c", "mpg_h")
]

simple_table <- cars_data |>
  gt(rowname_col = "model") |>
  tab_header(title = "High-performance cars") |>
  tab_stubhead(label = "Model") |>
  tab_spanner(label = "Performance", columns = c(hp, trq)) |>
  tab_spanner(label = "Fuel economy (mpg)", columns = c(mpg_c, mpg_h)) |>
  cols_label(
    hp = "HP",
    trq = "Torque (lb-ft)",
    mpg_c = "City",
    mpg_h = "Highway"
  ) |>
  fmt_integer(columns = c(hp, trq, mpg_c, mpg_h))
```

### Complete table

Aggregate pizza sales by category and size. Each dataset row represents
one pizza sold, so the count below measures pizzas rather than distinct
orders. All sizes are retained, including XL and XXL, so the grand total
covers the entire dataset.

``` r

pizza_source <- data.frame(
  category = gt::pizzaplace$type,
  size = gt::pizzaplace$size,
  pizzas = 1L,
  revenue = gt::pizzaplace$price
)
pizza_data <- aggregate(
  cbind(pizzas, revenue) ~ category + size,
  data = pizza_source,
  FUN = sum
)
pizza_data$average_price <- pizza_data$revenue / pizza_data$pizzas
pizza_data$category <- paste0(
  toupper(substr(pizza_data$category, 1, 1)),
  substring(pizza_data$category, 2)
)
pizza_data$size <- factor(
  pizza_data$size,
  levels = c("S", "M", "L", "XL", "XXL")
)
pizza_data <- pizza_data[order(pizza_data$category, pizza_data$size), ]
```

The category column defines row groups (`groupname_col`), and size
supplies the stub labels (`rowname_col`). Only additive quantities
receive totals; average prices are left blank in summary rows.

``` r

complete_table <- pizza_data |>
  gt(rowname_col = "size", groupname_col = "category") |>
  tab_header(
    title = "Pizza sales by category and size",
    subtitle = "Full-year sales, 2015"
  ) |>
  tab_stubhead(label = "Category / size") |>
  tab_spanner(label = "Sales", columns = c(pizzas, revenue)) |>
  cols_label(
    pizzas = "Pizzas sold",
    revenue = "Revenue",
    average_price = "Average price"
  ) |>
  fmt_integer(columns = pizzas) |>
  fmt_currency(columns = revenue, currency = "USD", decimals = 0) |>
    fmt_currency(columns = average_price, currency = "USD") |>
  summary_rows(
    groups = everything(),
    columns = pizzas,
    fns = list(Total = ~ sum(.)),
    missing_text = "",
    fmt = ~ fmt_integer(.)
  ) |>
  summary_rows(
    groups = everything(),
    columns = revenue,
    fns = list(Total = ~ sum(.)),
    missing_text = "",
    fmt = ~ fmt_currency(., currency = "USD", decimals = 0)
  ) |>
  grand_summary_rows(
    columns = pizzas,
    fns = list("Grand total" = ~ sum(.)),
    missing_text = "",
    fmt = ~ fmt_integer(.)
  ) |>
  grand_summary_rows(
    columns = revenue,
    fns = list("Grand total" = ~ sum(.)),
    missing_text = "",
    fmt = ~ fmt_currency(., currency = "USD", decimals = 0)
  ) |>
  tab_footnote(
    footnote = "Counts pizzas sold, not distinct orders; an order can contain several pizzas.",
    locations = cells_column_labels(columns = pizzas)
  ) |>
  tab_footnote(
    footnote = "Revenue divided by pizzas sold within each category and size.",
    locations = cells_column_labels(columns = average_price)
  ) |>
  tab_source_note(
    source_note = md("Source: **gt::pizzaplace**, pizza sales in 2015.")
  )
```

## Hokusai

[`gt_theme_hokusai()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_hokusai.md)
is the recommended theme for reports and articles. Column labels sit on
a blue band, body rows are striped, and fine rules mark the structure: a
blue rule opens each row group, a gray rule opens each group summary,
and a double blue rule opens the grand total. Summary rows carry no
fill. Pass `reversed = FALSE` for dark labels on white, `stripe = FALSE`
to drop the stripes, or `gridlines = TRUE` to add light cell rules.
These are theme colors, not a scale encoding the values in the table.

### Mountain

Deep blue band and rules with warm cream labels. The darkest of the four
palettes and the default.

``` r

simple_table |> gt_theme_hokusai(palette = "mountain")
```

[TABLE]

``` r

complete_table |> gt_theme_hokusai(palette = "mountain")
```

[TABLE]

### Wind

Muted slate blue with warm gray labels. The quietest band of the four.

``` r

simple_table |> gt_theme_hokusai(palette = "wind")
```

[TABLE]

``` r

complete_table |> gt_theme_hokusai(palette = "wind")
```

[TABLE]

### Blossom

Dark blue titles with a separate, brighter blue band and beige labels.

``` r

simple_table |> gt_theme_hokusai(palette = "blossom")
```

[TABLE]

``` r

complete_table |> gt_theme_hokusai(palette = "blossom")
```

[TABLE]

### Lake

Slate-blue titles with a lighter blue band and pale cream labels.

``` r

simple_table |> gt_theme_hokusai(palette = "lake")
```

[TABLE]

``` r

complete_table |> gt_theme_hokusai(palette = "lake")
```

[TABLE]

## Dashboard

[`gt_theme_ekio_dashboard()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio_dashboard.md)
is an experimental theme for dashboards and other dense screens. It
reuses the Hokusai palettes and summary rules but drops the header band
and the stripes: column labels are plain semibold text over a blue rule,
rows are split by thin gray rules, and numeric cells use IBM Plex Mono.
`density = "compact"` (the default) uses 4px row padding and a 13px base
size; `density = "dense"` uses 2px and 12px. The page must load IBM Plex
Mono; the theme does not.

``` r

complete_table |> gt_theme_ekio_dashboard()
```

[TABLE]

``` r

complete_table |> gt_theme_ekio_dashboard(density = "dense", palette = "lake")
```

[TABLE]

## EKIO

[`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md)
uses filled blue column headers and spanners, unfilled group headings
with blue rules, tinted subtotals, and a dark grand total. The table
sits on the warm offwhite surface
[`ekioplot::theme_ekio()`](https://viniciusoike.github.io/ekioplot/reference/theme_ekio.html)
draws on, so a chart and a table in one document share a background.
Pass `background = "white"`, `"cold"`, or `"transparent"` to change it.
It does not add a footer.

``` r

simple_table |> gt_theme_ekio(stripe = TRUE)
```

[TABLE]

``` r

complete_table |> gt_theme_ekio(stripe = TRUE)
```

[TABLE]
