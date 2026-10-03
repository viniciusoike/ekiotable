test_that("the dashboard theme rejects bad input", {
  expect_error(gt_theme_ekio_dashboard(mtcars), "gt table")
  expect_error(gt_theme_ekio_dashboard(small_tbl(), density = "loose"))
  expect_error(gt_theme_ekio_dashboard(small_tbl(), palette = "sea"))
  expect_error(gt_theme_ekio_dashboard(small_tbl(), font_size = -1))
})

test_that("density sets row padding and the base size", {
  local_font_options()
  compact <- gt_theme_ekio_dashboard(small_tbl())
  dense <- gt_theme_ekio_dashboard(small_tbl(), density = "dense")

  expect_equal(gt_option(compact, "data_row_padding"), "4px")
  expect_equal(gt_option(compact, "table_font_size"), "13px")
  expect_equal(gt_option(dense, "data_row_padding"), "2px")
  expect_equal(gt_option(dense, "table_font_size"), "12px")

  sized <- gt_theme_ekio_dashboard(
    small_tbl(),
    density = "dense",
    font_size = 14
  )
  expect_equal(gt_option(sized, "table_font_size"), "14px")
  expect_equal(gt_option(sized, "data_row_padding"), "2px")
})

test_that("rows are separated by thin gray rules, not stripes", {
  local_font_options()
  out <- gt_theme_ekio_dashboard(small_tbl())

  expect_equal(gt_option(out, "row_striping_include_table_body"), FALSE)
  expect_equal(gt_option(out, "table_body_hlines_style"), "solid")
  expect_equal(gt_option(out, "table_body_hlines_width"), "1px")
  expect_equal(gt_option(out, "table_body_hlines_color"), "#E5E5E5")
  expect_equal(gt_option(out, "table_body_vlines_style"), "none")
})

test_that("numeric cells use IBM Plex Mono with tabular figures", {
  local_font_options()
  out <- gt_theme_ekio_dashboard(small_tbl())

  expect_equal(
    font_stack(body_font(out)),
    c("IBM Plex Mono", gt::default_fonts())
  )
  expect_match(gt::as_raw_html(out), "tabular-nums", fixed = TRUE)

  custom <- gt_theme_ekio_dashboard(small_tbl(), font_numeric = "fira_code")
  expect_equal(font_stack(body_font(custom))[1], "Fira Code")
})

test_that("column labels are plain text over a blue rule", {
  local_font_options()
  out <- small_tbl() |>
    gt::tab_spanner(label = "Values", columns = gt::everything()) |>
    gt_theme_ekio_dashboard(palette = "lake")

  expect_equal(gt_option(out, "column_labels_background_color"), "#FFFFFF")
  expect_equal(gt_option(out, "column_labels_border_bottom_style"), "solid")
  expect_equal(gt_option(out, "column_labels_border_bottom_width"), "2px")
  expect_equal(gt_option(out, "column_labels_border_bottom_color"), "#416880")
  expect_equal(gt_option(out, "column_labels_font_size"), "13px")

  for (location in c("columns_columns", "columns_groups")) {
    style <- gt_styles_at(out, location)[[1]]
    expect_equal(style$cell_text$color, "#262626")
    expect_equal(style$cell_text$weight, "600")
    expect_null(style$cell_fill)
  }
})

test_that("the dashboard reuses the Hokusai palettes", {
  local_font_options()
  for (palette in names(.hokusai_palettes)) {
    out <- gt_theme_ekio_dashboard(summarized_tbl(), palette = palette)
    expect_equal(
      gt_option(out, "grand_summary_row_border_color"),
      .hokusai_palettes[[palette]][["blue"]]
    )
  }
})

test_that("summaries follow the Hokusai rules", {
  local_font_options()
  out <- gt_theme_ekio_dashboard(summarized_tbl())

  expect_equal(gt_option(out, "summary_row_background_color"), "#FFFFFF")
  expect_equal(gt_option(out, "summary_row_border_color"), "#D4D4D4")
  expect_equal(gt_option(out, "grand_summary_row_border_style"), "double")

  # Summary values are figures and share the numeric font. Their stub
  # labels are words and stay in the body font.
  for (locname in c("summary_cells", "grand_summary_cells")) {
    entries <- summary_entries(out, locname)
    fonts <- lapply(entries$styles, function(style) style$cell_text$font)
    is_label <- is.na(entries$colname)
    value_font <- fonts[!is_label & !vapply(fonts, is.null, logical(1))]

    expect_equal(font_stack(value_font[[1]])[1], "IBM Plex Mono")
    expect_true(all(vapply(fonts[is_label], is.null, logical(1))))
  }
})
