test_that("gt_theme_ekio() returns a gt table and rejects other input", {
  local_font_options()
  expect_s3_class(gt_theme_ekio(small_tbl()), "gt_tbl")
  expect_snapshot(gt_theme_ekio(mtcars), error = TRUE)
})

test_that("gt_theme_ekio() validates its arguments", {
  local_font_options()
  expect_snapshot(gt_theme_ekio(small_tbl(), font_size = "14"), error = TRUE)
  expect_snapshot(
    gt_theme_ekio(small_tbl(), font_size = c(12, 14)),
    error = TRUE
  )
  expect_snapshot(gt_theme_ekio(small_tbl(), font_size = -1), error = TRUE)
  expect_snapshot(gt_theme_ekio(small_tbl(), table_width = 100), error = TRUE)
  expect_snapshot(gt_theme_ekio(small_tbl(), stripe = "yes"), error = TRUE)
  expect_snapshot(gt_theme_ekio(small_tbl(), add_footer = NA), error = TRUE)
  expect_snapshot(gt_theme_ekio(small_tbl(), font_title = 1), error = TRUE)
})


test_that("arguments reach the gt options", {
  local_font_options()
  out <- gt_theme_ekio(small_tbl(), font_size = 12, table_width = "80%")
  expect_equal(gt_option(out, "table_font_size"), "12px")
  expect_equal(gt_option(out, "table_width"), "80%")
})

test_that("stripe toggles body striping", {
  local_font_options()
  on <- gt_theme_ekio(small_tbl(), stripe = TRUE)
  off <- gt_theme_ekio(small_tbl(), stripe = FALSE)
  expect_equal(gt_option(on, "row_striping_include_table_body"), TRUE)
  expect_equal(gt_option(off, "row_striping_include_table_body"), FALSE)
})

test_that("add_footer controls the EKIO source note", {
  local_font_options()
  with_note <- gt_theme_ekio(small_tbl(), add_footer = TRUE)
  without <- gt_theme_ekio(small_tbl(), add_footer = FALSE)
  expect_length(with_note[["_source_notes"]], 1)
  expect_length(without[["_source_notes"]], 0)
})


test_that("the body font heads the gt font stack", {
  local_font_options()
  out <- gt_theme_ekio(small_tbl())
  expect_equal(unlist(gt_option(out, "table_font_names"))[[1]], "Lato")
})

test_that("the title carries the title font", {
  local_font_options()
  out <- gt_theme_ekio(small_tbl() |> gt::tab_header("T"))
  fonts <- vapply(
    gt_styles_at(out, "title"),
    function(s) {
      font <- s$cell_text$font
      return(if (is.null(font)) NA_character_ else font)
    },
    character(1)
  )
  expect_equal("Lora" %in% fonts, TRUE)
})

test_that("every registry font can drive a table", {
  local_font_options()
  for (font in .ekio_font_stacks) {
    out <- gt_theme_ekio(small_tbl(), font_body = font)
    expect_equal(unlist(gt_option(out, "table_font_names"))[[1]], font)
  }
})

test_that("a registry key works as an argument", {
  local_font_options()
  out <- gt_theme_ekio(small_tbl(), font_body = "fira_code")
  expect_equal(unlist(gt_option(out, "table_font_names"))[[1]], "Fira Code")
})


test_that("the theme takes its colors from the token helper", {
  local_font_options()
  out <- gt_theme_ekio(small_tbl())
  expect_equal(
    gt_option(out, "column_labels_background_color"),
    unname(ekioplot::ekio_pal("blue")["700"])
  )
  expect_equal(
    gt_option(out, "table_font_color"),
    unname(ekioplot::ekio_pal("gray")["900"])
  )
  expect_equal(
    gt_option(out, "row_striping_background_color"),
    unname(ekioplot::ekio_pal("gray")["200"])
  )
  expect_equal(as_hex(gt_option(out, "heading_background_color")), "#FFFFFF")
})

test_that("hex codes appear only in palette and token files", {
  local_font_options()
  r_dir <- test_path("..", "..", "R")
  skip_if_not(dir.exists(r_dir), "package source not available")
  files <- setdiff(
    list.files(r_dir, full.names = TRUE),
    file.path(r_dir, c("tokens.R", "utils.R"))
  )
  code <- unlist(lapply(files, readLines))
  expect_equal(any(grepl("#[0-9A-Fa-f]{6}\\b", code)), FALSE)
})


test_that("text on colored fills clears WCAG AA", {
  local_font_options()
  out <- gt_theme_ekio(grouped_tbl())
  ratios <- vapply(
    out[["_styles"]]$styles,
    function(s) {
      if (is.null(s$cell_text$color) || is.null(s$cell_fill$color)) {
        return(NA_real_)
      }
      return(ekioplot::ekio_contrast(s$cell_text$color, s$cell_fill$color))
    },
    numeric(1)
  )
  ratios <- ratios[!is.na(ratios)]
  expect_gt(length(ratios), 0)
  expect_equal(all(ratios >= 4.5), TRUE)
})

test_that("body text clears WCAG AA on every surface it lands on", {
  local_font_options()
  out <- gt_theme_ekio(small_tbl())
  body <- gt_option(out, "table_font_color")
  surfaces <- c(
    gt_option(out, "table_background_color"),
    gt_option(out, "row_striping_background_color"),
    gt_option(out, "summary_row_background_color")
  )
  expect_equal(all(ekioplot::ekio_contrast(body, surfaces) >= 4.5), TRUE)
})


test_that("a grouped table gets its row-group styles", {
  local_font_options()
  out <- gt_theme_ekio(grouped_tbl())
  expect_equal("row_groups" %in% out[["_styles"]]$locname, TRUE)
})

test_that("a table with no summary rows still gets every other style", {
  local_font_options()
  out <- gt_theme_ekio(small_tbl())
  expect_equal(
    all(
      c("columns_columns", "title", "stub", "source_notes") %in%
        out[["_styles"]]$locname
    ),
    TRUE
  )
})

test_that("a table with summary rows gets the summary styles", {
  local_font_options()
  tbl <- grouped_tbl() |>
    gt::summary_rows(groups = "a", columns = "x", fns = list(avg = ~ mean(.)))
  out <- gt_theme_ekio(tbl)
  expect_equal(any(grepl("summary", out[["_styles"]]$locname)), TRUE)
})


test_that("the resolved theme options are stable", {
  local_font_options()
  out <- gt_theme_ekio(small_tbl())
  opts <- out[["_options"]]
  themed <- opts[!is.na(opts$value) & opts$category != "table_body", ]
  expect_snapshot(print(as.data.frame(themed[, c("parameter", "value")])))
})

test_that("numeric and label fonts inherit the body and respect overrides", {
  local_font_options()
  tbl <- gt::gt(data.frame(label = c("a", "b"), number = 1:2))
  out <- gt_theme_ekio(tbl, font_body = "Georgia")
  expect_equal(
    tail(gt_styles_at(out, "data"), 1)[[1]]$cell_text$font,
    "Georgia"
  )
  expect_equal(
    gt_styles_at(out, "columns_columns")[[1]]$cell_text$font,
    "Georgia"
  )
  withr::local_options(
    ekiotable.font_numeric = "fira_code",
    ekiotable.font_labels = "host_grotesk"
  )
  out <- gt_theme_ekio(tbl, font_body = "Georgia")
  styles <- out[["_styles"]]
  numeric <- styles[
    vapply(
      styles$styles,
      function(s) identical(s$cell_text$font, "'Fira Code'"),
      logical(1)
    ),
  ]
  expect_equal(unique(numeric$colname), "number")
  expect_equal(
    gt_styles_at(out, "columns_columns")[[1]]$cell_text$font,
    "'Host Grotesk'"
  )
  out <- gt_theme_ekio(tbl, font_numeric = "Georgia", font_labels = "Lora")
  expect_equal(
    tail(gt_styles_at(out, "data"), 1)[[1]]$cell_text$font,
    "Georgia"
  )
  expect_equal(gt_styles_at(out, "columns_columns")[[1]]$cell_text$font, "Lora")
})

test_that("grand summaries and partial group summaries render with styles", {
  local_font_options()
  tbl <- grouped_tbl() |>
    gt::summary_rows(
      groups = "a",
      columns = "x",
      fns = list(avg = ~ mean(.))
    ) |>
    gt::grand_summary_rows(columns = "x", fns = list(total = ~ sum(.)))
  out <- gt_theme_ekio(tbl)
  expect_equal(length(gt_styles_at(out, "summary_cells")), 1L)
  expect_equal(length(gt_styles_at(out, "grand_summary_cells")), 1L)
  expect_equal(
    gt_styles_at(out, "grand_summary_cells")[[1]]$cell_text$color,
    as_hex(ekioplot::ekio_text_on(.ekio("blue", 800)))
  )
  expect_match(gt::as_raw_html(out), "summary")
})

test_that("text-only and empty tables support numeric font selection", {
  local_font_options()
  for (d in list(data.frame(x = "a"), data.frame(x = numeric()))) {
    expect_s3_class(
      gt_theme_ekio(gt::gt(d), font_numeric = "fira_code"),
      "gt_tbl"
    )
  }
})

test_that("invalid scalar values produce actionable errors", {
  local_font_options()
  expect_snapshot(gt_theme_ekio(small_tbl(), font_size = Inf), error = TRUE)
  expect_snapshot(gt_theme_ekio(small_tbl(), table_width = ""), error = TRUE)
  expect_snapshot(
    gt_theme_ekio(small_tbl(), font_body = NA_character_),
    error = TRUE
  )
  expect_snapshot(gt_theme_ekio(small_tbl(), font_labels = " "), error = TRUE)
  expect_snapshot(gt_theme_ekio(small_tbl(), stripe = logical()), error = TRUE)
})
