# Behavior every theme shares. Each test runs once per theme.
themes <- list(
  ekio = gt_theme_ekio,
  hokusai = function(data) gt_theme_hokusai(data, reversed = TRUE),
  dashboard = gt_theme_ekio_dashboard
)

# Themes that fill the column-label band.
filled_themes <- themes[c("ekio", "hokusai")]

# A factor stub is the case gt centers by default.
factor_stub_tbl <- function() {
  d <- data.frame(
    g = c("a", "a", "b"),
    size = factor(c("S", "M", "L"), levels = c("S", "M", "L")),
    n = 1:3
  )
  gt::gt(d, groupname_col = "g", rowname_col = "size") |>
    gt::tab_stubhead(label = "Size") |>
    gt::summary_rows(groups = "a", columns = "n", fns = list(Total = ~ sum(.)))
}

test_that("stub labels are left-aligned, whatever the stub column type", {
  local_font_options()
  for (theme in themes) {
    html <- html_block_css(theme(factor_stub_tbl()))
    stub_tags <- grep("gt_stub", gt_row_tags(html), value = TRUE)

    # Summary stubs arrive left-aligned through gt's own class.
    left <- grepl("text-align: left", stub_tags, fixed = TRUE) |
      grepl("gt_left", stub_tags, fixed = TRUE)

    expect_gt(length(stub_tags), 0L)
    expect_true(all(left))
  }
})

test_that("row labels sit indented under group headings, and only there", {
  local_font_options()
  indent <- .stub_indent_css
  data_stub_tags <- function(tbl) {
    tags <- grep("gt_stub", gt_row_tags(html_block_css(tbl)), value = TRUE)
    return(grep("summary", tags, value = TRUE, invert = TRUE))
  }

  for (theme in themes) {
    grouped <- data_stub_tags(theme(factor_stub_tbl()))
    plain <- data_stub_tags(theme(gt::gt(
      head(mtcars, 3),
      rownames_to_stub = TRUE
    )))

    expect_true(all(grepl(indent, grouped, fixed = TRUE)))
    expect_false(any(grepl(indent, plain, fixed = TRUE)))
  }
})

test_that("group headings use body text color, not the summary color", {
  local_font_options()
  for (theme in themes) {
    out <- theme(factor_stub_tbl())
    group_color <- gt_styles_at(out, "row_groups")[[1]]$cell_text$color
    summary_color <- summary_entries(out, "summary_cells")$styles[[1]][[
      1
    ]]$cell_text$color

    expect_equal(group_color, as_hex(gt_option(out, "table_font_color")))
    expect_false(identical(group_color, summary_color))
  }
})

test_that("the stubhead matches the column labels", {
  local_font_options()
  for (theme in themes) {
    out <- theme(factor_stub_tbl())
    labels <- gt_styles_at(out, "columns_columns")[[1]]
    stubhead <- gt_styles_at(out, "stubhead")

    expect_length(stubhead, 1L)
    expect_equal(stubhead[[1]]$cell_text$color, labels$cell_text$color)
    expect_equal(stubhead[[1]]$cell_fill$color, labels$cell_fill$color)
  }
})

test_that("filled header cells cover the sub-pixel seams between them", {
  local_font_options()
  for (theme in filled_themes) {
    out <- theme(factor_stub_tbl())
    fill <- gt_styles_at(out, "columns_columns")[[1]]$cell_fill$color
    html <- html_block_css(out)
    header_tags <- regmatches(
      html,
      gregexpr("<th[^>]*class=\"gt_col_heading[^>]*>", html)
    )[[1]]

    expect_gt(length(header_tags), 0L)
    expect_true(all(grepl(
      paste0("box-shadow: 1px 0 0 0 ", fill),
      header_tags,
      fixed = TRUE
    )))
  }
})
