gallery_simple_table <- function() {
  cars_data <- gt::gtcars[order(gt::gtcars$msrp, decreasing = TRUE), ]
  cars_data <- cars_data[
    seq_len(4),
    c("model", "hp", "trq", "mpg_c", "mpg_h")
  ]

  cars_data |>
    gt::gt(rowname_col = "model", id = "gallery-simple") |>
    gt::tab_header(title = "High-performance cars") |>
    gt::tab_stubhead(label = "Model") |>
    gt::tab_spanner(label = "Performance", columns = c(hp, trq)) |>
    gt::tab_spanner(label = "Fuel economy (mpg)", columns = c(mpg_c, mpg_h)) |>
    gt::cols_label(
      hp = "HP",
      trq = "Torque (lb-ft)",
      mpg_c = "City",
      mpg_h = "Highway"
    ) |>
    gt::fmt_integer(columns = c(hp, trq, mpg_c, mpg_h))
}

gallery_complete_table <- function() {
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
  pizza_data$size <- factor(
    pizza_data$size,
    levels = c("S", "M", "L", "XL", "XXL")
  )
  pizza_data <- pizza_data[order(pizza_data$category, pizza_data$size), ]

  pizza_data |>
    gt::gt(
      rowname_col = "size",
      groupname_col = "category",
      id = "gallery-complete"
    ) |>
    gt::tab_header(
      title = "Pizza sales by category and size",
      subtitle = "Full-year sales, 2015"
    ) |>
    gt::tab_stubhead(label = "Category / size") |>
    gt::tab_spanner(label = "Sales", columns = c(pizzas, revenue)) |>
    gt::cols_label(
      pizzas = "Pizzas sold",
      revenue = "Revenue",
      average_price = "Average price"
    ) |>
    gt::fmt_integer(columns = pizzas) |>
    gt::fmt_currency(columns = c(revenue, average_price), currency = "USD") |>
    gt::summary_rows(
      groups = tidyselect::everything(),
      columns = pizzas,
      fns = list(Total = ~ sum(.)),
      fmt = ~ gt::fmt_integer(.)
    ) |>
    gt::summary_rows(
      groups = tidyselect::everything(),
      columns = revenue,
      fns = list(Total = ~ sum(.)),
      fmt = ~ gt::fmt_currency(., currency = "USD")
    ) |>
    gt::grand_summary_rows(
      columns = pizzas,
      fns = list("Grand total" = ~ sum(.)),
      fmt = ~ gt::fmt_integer(.)
    ) |>
    gt::grand_summary_rows(
      columns = revenue,
      fns = list("Grand total" = ~ sum(.)),
      fmt = ~ gt::fmt_currency(., currency = "USD")
    ) |>
    gt::tab_footnote(
      footnote = "Counts pizzas sold, not distinct orders.",
      locations = gt::cells_column_labels(columns = pizzas)
    ) |>
    gt::tab_source_note(
      source_note = gt::md("Source: **gt::pizzaplace**, pizza sales in 2015.")
    )
}

test_that("gallery tables render stable HTML", {
  local_font_options()

  expect_snapshot(
    as.character(
      gt::as_raw_html(
        gallery_simple_table() |> gt_theme_ekio(),
        inline_css = FALSE
      )
    )
  )
  expect_snapshot(
    as.character(
      gt::as_raw_html(
        gallery_complete_table() |> gt_theme_ekio(),
        inline_css = FALSE
      )
    )
  )
  expect_snapshot(
    as.character(
      gt::as_raw_html(
        gallery_simple_table() |>
          gt_theme_hokusai(palette = "mountain", stripe = TRUE),
        inline_css = FALSE
      )
    )
  )
  expect_snapshot(
    as.character(
      gt::as_raw_html(
        gallery_complete_table() |>
          gt_theme_hokusai(palette = "mountain", stripe = TRUE),
        inline_css = FALSE
      )
    )
  )
})
