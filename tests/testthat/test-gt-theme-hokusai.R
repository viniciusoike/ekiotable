test_that("Hokusai palettes render plain and grouped analytical tables", {
  local_font_options()
  tbl <- grouped_tbl() |>
    gt::summary_rows(
      groups = "a",
      columns = "x",
      fns = list(avg = ~ mean(.))
    ) |>
    gt::grand_summary_rows(columns = "x", fns = list(total = ~ sum(.)))

  for (palette in names(.hokusai_palettes)) {
    out <- gt_theme_hokusai(tbl, palette = palette)
    expect_s3_class(out, "gt_tbl")
    expect_equal(out[["_data"]], tbl[["_data"]])
    expect_equal(nrow(summary_entries(out, "summary_cells")), 2L)
    expect_equal(nrow(summary_entries(out, "grand_summary_cells")), 2L)
    expect_match(gt::as_raw_html(out), "tabular-nums", fixed = TRUE)
    expect_match(
      gt::as_raw_html(gt_theme_hokusai(small_tbl(), palette)),
      "<table"
    )
  }
})

test_that("Hokusai uses a white canvas and respects layout and font arguments", {
  out <- gt_theme_hokusai(
    small_tbl(),
    palette = "blossom",
    table_width = "80%",
    font_size = 12,
    stripe = TRUE,
    font_body = "Georgia",
    font_numeric = "Lato"
  )
  expect_equal(gt_option(out, "table_background_color"), "#FFFFFF")
  expect_equal(gt_option(out, "column_labels_background_color"), "#FFFFFF")
  expect_equal(gt_option(out, "table_width"), "80%")
  expect_equal(gt_option(out, "table_font_size"), "12px")
  expect_equal(gt_option(out, "row_striping_include_table_body"), TRUE)
  expect_equal(tail(gt_styles_at(out, "data"), 1)[[1]]$cell_text$font, "Lato")
  expect_equal(
    gt_option(gt_theme_hokusai(small_tbl()), "row_striping_include_table_body"),
    FALSE
  )
})

test_that("Hokusai validates data and palette choices", {
  expect_snapshot(gt_theme_hokusai(mtcars), error = TRUE)
  expect_snapshot(
    gt_theme_hokusai(small_tbl(), palette = "unknown"),
    error = TRUE
  )
})

test_that("gridlines can be enabled without changing data or emphasis", {
  tbl <- gt::gt(
    data.frame(group = c("A", "A"), age = c("5", "10"), n = 1:2),
    groupname_col = "group",
    rowname_col = "age"
  ) |>
    gt::tab_header(title = "Population", subtitle = "Selected ages") |>
    gt::tab_source_note("Source: example") |>
    gt::tab_footnote("Example note")
  for (enabled in c(FALSE, TRUE)) {
    out <- gt_theme_hokusai(tbl, gridlines = enabled, stripe = TRUE)
    expect_equal(out[["_data"]], tbl[["_data"]])
    for (option in c(
      "table_body_hlines_style",
      "table_body_vlines_style",
      "stub_border_style",
      "column_labels_vlines_style"
    )) {
      expect_equal(gt_option(out, option), if (enabled) "solid" else "none")
    }
    expect_equal(gt_option(out, "table_font_color"), "#262626")
    expect_equal(
      gt_styles_at(out, "row_groups")[[1]]$cell_text$color,
      "#204D6D"
    )
    expect_equal(
      gt_styles_at(out, "source_notes")[[1]]$cell_text$color,
      "#525252"
    )
    expect_match(gt::as_raw_html(out), "#E5E5E5", ignore.case = TRUE)
  }
  expect_snapshot(gt_theme_hokusai(tbl, gridlines = NA), error = TRUE)
})
