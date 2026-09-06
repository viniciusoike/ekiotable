# Keep font resolution independent of the developer's session options.
local_font_options <- function(.local_envir = parent.frame()) {
  withr::local_options(
    stats::setNames(
      rep(list(NULL), 6),
      c(
        "ekiotable.font_title",
        "ekiotable.font_body",
        "ekiotable.font_numeric",
        "ekiotable.font_labels",
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
