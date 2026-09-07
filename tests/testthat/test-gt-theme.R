test_that("gt_theme_ekio() is the exported gt theme", {
  out <- gt_theme_ekio(small_tbl())
  exports <- getNamespaceExports("ekiotable")

  expect_s3_class(out, "gt_tbl")
  expect_length(out[["_source_notes"]], 0L)
  expect_equal("add_footer" %in% names(formals(gt_theme_ekio)), FALSE)
  expect_equal("gt_theme_ekio" %in% exports, TRUE)
  expect_equal("gt_theme_ekio_alt" %in% exports, FALSE)
})

test_that("gt_theme_ekio() validates its inputs", {
  expect_snapshot(gt_theme_ekio(mtcars), error = TRUE)
  expect_snapshot(
    gt_theme_ekio(small_tbl(), table_width = 100),
    error = TRUE
  )
  expect_snapshot(gt_theme_ekio(small_tbl(), font_size = 0), error = TRUE)
  expect_snapshot(gt_theme_ekio(small_tbl(), stripe = "yes"), error = TRUE)
})

test_that("gt_theme_ekio() uses ekioplot palettes", {
  out <- gt_theme_ekio(
    small_tbl(),
    table_width = "80%",
    font_size = 12,
    stripe = FALSE
  )

  expect_equal(gt_option(out, "table_width"), "80%")
  expect_equal(gt_option(out, "table_font_size"), "12px")
  expect_equal(gt_option(out, "row_striping_include_table_body"), FALSE)
  expect_equal(
    gt_option(out, "column_labels_background_color"),
    unname(ekioplot::ekio_pal("blue")["700"])
  )
  expect_equal(
    gt_option(out, "table_font_color"),
    unname(ekioplot::ekio_pal("gray")["900"])
  )
  expect_equal(
    is.na(gt_option(out, "source_notes_background_color")),
    TRUE
  )
})

test_that("gt_theme_ekio() rejects a non-string font family", {
  local_font_options()
  expect_snapshot(
    gt_theme_ekio(small_tbl(), font_title = 1),
    error = TRUE
  )
})

test_that("the three body levels get distinct styles", {
  local_font_options()
  out <- gt_theme_ekio(grouped_tbl())
  locnames <- out[["_styles"]]$locname

  expect_equal(all(c("row_groups", "stub") %in% locnames), TRUE)
  expect_equal(
    gt_option(out, "row_group_border_top_color"),
    .ekio("ekio_brand", "Baltic Blue")
  )
  expect_equal(gt_option(out, "row_group_border_bottom_style"), "none")
  expect_equal(
    gt_styles_at(out, "row_groups")[[1]]$cell_text$color,
    .ekio("ekio_brand", "Baltic Blue")
  )
  expect_equal(
    gt_styles_at(out, "stub")[[1]]$cell_text$color,
    .ekio("gray", 700)
  )
})

test_that("row groups carry no background fill", {
  local_font_options()
  out <- gt_theme_ekio(grouped_tbl())

  expect_equal(is.na(gt_option(out, "row_group_background_color")), TRUE)
  expect_equal(is.na(gt_option(out, "stub_background_color")), TRUE)
})

test_that("summary rows are tinted and their stub labels match", {
  local_font_options()
  tbl <- grouped_tbl() |>
    gt::summary_rows(groups = "a", columns = "x", fns = list(avg = ~ mean(.)))
  out <- gt_theme_ekio(tbl)

  expect_equal(
    gt_option(out, "summary_row_background_color"),
    .ekio("ekio_brand", "Soft Linen 2")
  )
  # gt files the value cell and its stub label under one locname; the stub
  # label is the entry with no column.
  cells <- summary_entries(out, "summary_cells")
  expect_equal(nrow(cells), 2L)
  expect_equal(sum(is.na(cells$colname)), 1L)
  expect_equal(
    unique(vapply(cells$styles, function(s) s$cell_text$color, character(1))),
    .ekio("blue", 700)
  )
})

test_that("the grand summary gets a dark slab with contrasting text", {
  local_font_options()
  tbl <- grouped_tbl() |>
    gt::grand_summary_rows(columns = "x", fns = list(total = ~ sum(.)))
  out <- gt_theme_ekio(tbl)
  dark <- .ekio("blue", 800)

  expect_equal(gt_option(out, "grand_summary_row_background_color"), dark)

  cells <- summary_entries(out, "grand_summary_cells")
  expect_equal(nrow(cells), 2L)
  expect_equal(sum(is.na(cells$colname)), 1L)
  expect_equal(
    unique(vapply(
      cells$styles,
      function(s) as_hex(s$cell_text$color),
      character(1)
    )),
    as_hex(ekioplot::ekio_text_on(dark))
  )
})

test_that("a table with no summaries still gets every other style", {
  local_font_options()
  out <- gt_theme_ekio(grouped_tbl())

  expect_equal(
    all(
      c("columns_columns", "title", "stub", "row_groups") %in%
        out[["_styles"]]$locname
    ),
    TRUE
  )
})

test_that("spanners get the column label treatment", {
  local_font_options()
  tbl <- gt::gt(data.frame(a = 1, b = 2)) |>
    gt::tab_spanner(label = "Both", columns = c("a", "b"))
  out <- gt_theme_ekio(tbl)
  style <- gt_styles_at(out, "columns_groups")[[1]]

  expect_equal(style$cell_fill$color, .ekio("blue", 700))
  expect_equal(style$cell_text$weight, "700")
})

test_that("numeric cells get tabular figures", {
  local_font_options()
  html <- as.character(gt::as_raw_html(gt_theme_ekio(small_tbl())))

  expect_equal(grepl("tabular-nums", html, fixed = TRUE), TRUE)
})

test_that("the fonts resolve for the theme", {
  local_font_options()
  out <- gt_theme_ekio(small_tbl())
  expect_equal(unlist(gt_option(out, "table_font_names"))[[1]], "Lato")

  titles <- vapply(
    gt_styles_at(out, "title"),
    function(s) s$cell_text$font %||% NA_character_,
    character(1)
  )
  expect_equal("Lora" %in% titles, TRUE)

  slab <- gt_theme_ekio(small_tbl(), font_body = "roboto_slab")
  expect_equal(
    unlist(gt_option(slab, "table_font_names"))[[1]],
    "Roboto Slab"
  )
})

test_that("the numeric font inherits the body font and respects overrides", {
  local_font_options()
  tbl <- gt::gt(data.frame(x = 1, y = "a"))

  out <- gt_theme_ekio(tbl, font_body = "Georgia")
  expect_equal(
    tail(gt_styles_at(out, "data"), 1)[[1]]$cell_text$font,
    "Georgia"
  )

  out <- gt_theme_ekio(tbl, font_body = "Georgia", font_numeric = "Lato")
  expect_equal(tail(gt_styles_at(out, "data"), 1)[[1]]$cell_text$font, "Lato")
})

test_that("the body neutrals are warm, matching the note bands", {
  local_font_options()
  out <- gt_theme_ekio(small_tbl())

  expect_equal(
    gt_option(out, "row_striping_background_color"),
    .ekio("stone", 100)
  )
  expect_equal(
    gt_option(out, "column_labels_border_bottom_color"),
    .ekio("stone", 300)
  )
})
