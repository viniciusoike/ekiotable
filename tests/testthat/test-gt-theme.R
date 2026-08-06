# ---- Tests for GT Theme ----

test_that("gt_theme_ekio returns styled gt table", {
  tbl <- gt::gt(head(mtcars, 5))
  expect_s3_class(gt_theme_ekio(tbl), "gt_tbl")
})

test_that("gt_theme_ekio rejects non-gt input", {
  expect_error(gt_theme_ekio(mtcars), "gt table object")
})

test_that("gt_theme_ekio without footer works", {
  tbl <- gt::gt(head(mtcars, 5))
  expect_s3_class(gt_theme_ekio(tbl, add_footer = FALSE), "gt_tbl")
})

test_that("gt_theme_ekio without striping works", {
  tbl <- gt::gt(head(mtcars, 5))
  expect_s3_class(gt_theme_ekio(tbl, stripe = FALSE), "gt_tbl")
})

test_that("gt_theme_ekio custom sizing works", {
  tbl <- gt::gt(head(mtcars, 5))
  expect_s3_class(
    gt_theme_ekio(tbl, table_width = "80%", font_size = 12),
    "gt_tbl"
  )
})

# ---- Brand token wiring ----

test_that("tokens resolve through ekioplot rather than local hex", {
  expect_identical(.ekio("blue", 700), unname(ekioplot::ekio_pal("blue")["700"]))
  expect_identical(.ekio("gray", 900), unname(ekioplot::ekio_pal("gray")["900"]))
})

test_that("unknown tokens error rather than silently returning NA", {
  expect_error(.ekio("blue", 50), "No shade")
  expect_error(.ekio("chartreuse", 500))
})

test_that("no hex codes are hardcoded in package source", {
  r_files <- list.files(
    test_path("..", ".."), pattern = "[.]R$", recursive = TRUE,
    full.names = TRUE
  )
  r_files <- r_files[grepl("/R/", r_files)]
  skip_if(length(r_files) == 0, "package source not available")

  for (f in r_files) {
    lines <- readLines(f, warn = FALSE)
    lines <- lines[!grepl("^\\s*#", lines)]
    expect_false(
      any(grepl("#[0-9A-Fa-f]{6}\\b", lines)),
      label = paste("hardcoded hex in", basename(f))
    )
  }
})
