# Keep font resolution independent of the developer's session options.
local_font_options <- function(.local_envir = parent.frame()) {
  withr::local_options(
    stats::setNames(
      rep(list(NULL), 7),
      c(
        "ekiotable.font_title",
        "ekiotable.font_body",
        "ekiotable.font_numeric",
        "ekiotable.font_labels",
        "ekiotable.font_stub",
        "ekioplot.font_title",
        "ekioplot.font_text"
      )
    ),
    .local_envir = .local_envir
  )
}

# Read one resolved option from a gt object. tab_options() stores raw
# strings; tab_style() normalizes colors to upper-case hex.
gt_option <- function(tbl, parameter) {
  opts <- tbl[["_options"]]
  return(opts$value[[match(parameter, opts$parameter)]])
}

gt_styles_at <- function(tbl, locname) {
  styles <- tbl[["_styles"]]
  return(styles$styles[styles$locname == locname])
}

as_hex <- function(color) {
  rgb <- grDevices::col2rgb(color)
  return(toupper(grDevices::rgb(rgb[1], rgb[2], rgb[3], maxColorValue = 255)))
}

small_tbl <- function() {
  return(gt::gt(head(mtcars, 5)))
}

grouped_tbl <- function() {
  d <- data.frame(g = c("a", "a", "b"), x = 1:3)
  return(gt::gt(d, groupname_col = "g"))
}

# Summary value cells and their stub labels share one locname. The stub
# label is the entry with no column.
summary_entries <- function(tbl, locname) {
  styles <- tbl[["_styles"]]
  return(styles[styles$locname == locname, c("colname", "styles")])
}

# tab_style() stores a font stack as one collapsed CSS string. The leading
# families are what the theme chose; the tail is the system fallback.
font_stack <- function(css) {
  return(gsub("^'|'$", "", trimws(strsplit(css, ",")[[1]])))
}

# A table that exercises every cell class that carries figures: body cells
# of both types, stub labels, group summaries, and the grand summary.
summarized_tbl <- function() {
  d <- data.frame(
    g = c("a", "a", "b"),
    label = c("x", "y", "z"),
    code = c("01", "02", "03"),
    n = 1:3
  )
  gt::gt(d, groupname_col = "g", rowname_col = "label") |>
    gt::summary_rows(
      groups = "a",
      columns = "n",
      fns = list(total = ~ sum(.))
    ) |>
    gt::grand_summary_rows(columns = "n", fns = list(total = ~ sum(.)))
}

# Render with a <style> block, as knitr and Quarto do, rather than inlining.
html_block_css <- function(tbl) {
  return(as.character(gt::as_raw_html(tbl, inline_css = FALSE)))
}

# The opening tags of every row cell, stub and summary cells included.
gt_row_tags <- function(html) {
  pattern <- "<t[dh][^>]*class=\"gt_row[^\"]*\"[^>]*>"
  return(regmatches(html, gregexpr(pattern, html))[[1]])
}

# The font of the last body style that names one. Body cells also carry
# border and figure styles, so position alone does not identify it.
body_font <- function(tbl) {
  fonts <- lapply(gt_styles_at(tbl, "data"), function(style) {
    if (is.list(style)) style$cell_text$font else NULL
  })
  fonts <- Filter(Negate(is.null), fonts)
  return(fonts[[length(fonts)]])
}
