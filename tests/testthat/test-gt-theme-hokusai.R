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
    # Value and stub cells, each with the summary style and the closing rule.
    expect_equal(nrow(summary_entries(out, "summary_cells")), 4L)
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
    reversed = FALSE,
    font_body = "Georgia",
    font_numeric = "Lato"
  )
  expect_equal(gt_option(out, "table_background_color"), "#FFFFFF")
  expect_equal(gt_option(out, "column_labels_background_color"), "#FFFFFF")
  expect_equal(gt_option(out, "table_width"), "80%")
  expect_equal(gt_option(out, "table_font_size"), "12px")
  expect_equal(gt_option(out, "row_striping_include_table_body"), TRUE)
  expect_equal(
    font_stack(body_font(out)),
    c("Lato", gt::default_fonts())
  )
  expect_equal(
    gt_option(
      gt_theme_hokusai(small_tbl(), stripe = FALSE),
      "row_striping_include_table_body"
    ),
    FALSE
  )
})

test_that("Hokusai defaults to a filled header band and striped rows", {
  local_font_options()
  out <- gt_theme_hokusai(small_tbl())

  expect_equal(gt_option(out, "row_striping_include_table_body"), TRUE)
  expect_equal(gt_option(out, "column_labels_background_color"), "#204D6D")
  expect_equal(
    gt_styles_at(out, "columns_columns")[[1]]$cell_text$color,
    "#EFEADE"
  )
})

test_that("the header band stays light: tight padding, one label weight", {
  local_font_options()
  out <- small_tbl() |>
    gt::tab_spanner(label = "Values", columns = gt::everything()) |>
    gt_theme_hokusai()

  expect_equal(gt_option(out, "column_labels_padding"), "8px")
  expect_equal(
    gt_styles_at(out, "columns_groups")[[1]]$cell_text$weight,
    "600"
  )
})

test_that("summary rows are marked by rules and ink, not fills", {
  local_font_options()
  out <- gt_theme_hokusai(summarized_tbl())

  for (row in c("summary_row", "grand_summary_row")) {
    expect_equal(gt_option(out, paste0(row, "_background_color")), "#FFFFFF")
  }
  expect_equal(gt_option(out, "summary_row_border_style"), "solid")
  expect_equal(gt_option(out, "summary_row_border_width"), "1px")
  expect_equal(gt_option(out, "summary_row_border_color"), "#D4D4D4")
  expect_equal(gt_option(out, "grand_summary_row_border_style"), "double")
  expect_equal(gt_option(out, "grand_summary_row_border_width"), "3px")
  expect_equal(gt_option(out, "grand_summary_row_border_color"), "#204D6D")
})

test_that("column labels sit above the body and carry a semibold face", {
  local_font_options()
  out <- gt_theme_hokusai(small_tbl())

  expect_equal(gt_option(out, "table_font_size"), "14px")
  expect_equal(gt_option(out, "column_labels_font_size"), "16px")
  expect_equal(gt_option(out, "heading_subtitle_font_size"), "16px")
  expect_equal(gt_option(out, "heading_title_font_size"), "22px")
  expect_equal(gt_option(out, "source_notes_font_size"), "13px")
  expect_equal(gt_option(out, "footnotes_font_size"), "13px")
  expect_equal(gt_option(out, "column_labels_font_weight"), "600")

  scaled <- gt_theme_hokusai(small_tbl(), font_size = 16)
  expect_equal(gt_option(scaled, "table_font_size"), "16px")
  expect_equal(gt_option(scaled, "column_labels_font_size"), "18px")
  expect_equal(gt_option(scaled, "source_notes_font_size"), "15px")

  # Host Grotesk ships semibold as its own family, so weight 600 against the
  # base family alone would match the 700 face.
  labelled <- small_tbl() |>
    gt::tab_spanner(label = "Values", columns = gt::everything()) |>
    gt_theme_hokusai(font_body = "host_grotesk")
  for (location in c("columns_columns", "columns_groups")) {
    stack <- font_stack(gt_styles_at(labelled, location)[[1]]$cell_text$font)
    expect_equal(stack[1:2], c("Host Grotesk SemiBold", "Host Grotesk"))
    expect_equal(stack[-(1:2)], gt::default_fonts())
  }
  expect_equal(
    font_stack(gt_styles_at(out, "columns_columns")[[1]]$cell_text$font),
    c("Lato", gt::default_fonts())
  )
})

test_that("font_stub defaults to the body font and carries its semibold face", {
  local_font_options()
  stub_tbl <- function() {
    return(gt::gt(head(mtcars, 3), rownames_to_stub = TRUE))
  }
  stub_family <- function(tbl) {
    return(font_stack(gt_styles_at(tbl, "stub")[[1]]$cell_text$font)[1])
  }

  # The default must not move row labels off the body font.
  expect_equal(stub_family(gt_theme_hokusai(stub_tbl())), "Lato")
  expect_equal(
    stub_family(gt_theme_hokusai(stub_tbl(), font_body = "Georgia")),
    "Georgia"
  )
  expect_equal(
    font_stack(
      gt_styles_at(
        gt_theme_hokusai(stub_tbl(), font_body = "host_grotesk"),
        "stub"
      )[[1]]$cell_text$font
    ),
    c("Host Grotesk SemiBold", "Host Grotesk", gt::default_fonts())
  )

  # An explicit stub font outranks the body font, and the option sits between
  # the two.
  expect_equal(
    stub_family(
      gt_theme_hokusai(stub_tbl(), font_body = "Lato", font_stub = "lora")
    ),
    "Lora"
  )
  withr::local_options(ekiotable.font_stub = "georgia")
  expect_equal(stub_family(gt_theme_hokusai(stub_tbl())), "Georgia")
  expect_equal(
    stub_family(gt_theme_hokusai(stub_tbl(), font_stub = "lora")),
    "Lora"
  )
})

test_that("reversed styles column labels and spanners with palette colors", {
  out <- small_tbl() |>
    gt::tab_spanner(label = "Values", columns = gt::everything()) |>
    gt_theme_hokusai(palette = "lake", reversed = TRUE)

  expect_equal(gt_option(out, "column_labels_background_color"), "#416880")
  expect_equal(gt_option(out, "column_labels_border_bottom_color"), "#FCE8C6")
  expect_equal(gt_option(out, "column_labels_vlines_color"), "#FCE8C6")

  for (location in c("columns_columns", "columns_groups")) {
    style <- gt_styles_at(out, location)[[1]]
    expect_equal(style$cell_text$color, "#FCE8C6")
    expect_equal(style$cell_fill$color, "#416880")
  }
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
      "#262626"
    )
    expect_equal(
      gt_styles_at(out, "source_notes")[[1]]$cell_text$color,
      "#525252"
    )
    expect_match(gt::as_raw_html(out), "#E5E5E5", ignore.case = TRUE)
  }
  expect_snapshot(gt_theme_hokusai(tbl, gridlines = NA), error = TRUE)
  expect_snapshot(gt_theme_hokusai(tbl, reversed = NA), error = TRUE)
})

test_that("Hokusai gives every row cell tabular lining figures, scoped", {
  local_font_options()
  out <- gt_theme_hokusai(
    summarized_tbl(),
    reversed = TRUE,
    stripe = TRUE,
    font_body = "host_grotesk"
  )
  html <- html_block_css(out)
  tags <- gt_row_tags(html)

  expect_gt(length(tags), 0)
  expect_true(all(grepl("tabular-nums lining-nums", tags, fixed = TRUE)))
  expect_false(grepl("(^|\\n)\\s*\\.gt_row\\s*\\{", html))
})

test_that("the group rule survives a summary row above it", {
  local_font_options()
  d <- data.frame(g = c("a", "a", "b"), label = c("x", "y", "z"), n = 1:3)
  tbl <- gt::gt(d, groupname_col = "g", rowname_col = "label") |>
    gt::summary_rows(
      groups = "a",
      columns = "n",
      fns = list(Total = ~ sum(.), Mean = ~ mean(.))
    )
  tags <- grep(
    "gt_summary_row",
    gt_row_tags(html_block_css(gt_theme_hokusai(tbl))),
    value = TRUE
  )
  blue_rule <- "border-bottom-color: #204D6D"
  last <- grepl("gt_last_summary_row", tags, fixed = TRUE)

  # gt draws the summary rule under the last summary row too, and in a
  # collapsed table that gray edge would win over the blue group rule.
  expect_true(any(last))
  expect_true(all(grepl(blue_rule, tags[last], fixed = TRUE)))
  expect_false(any(grepl(blue_rule, tags[!last], fixed = TRUE)))
})
