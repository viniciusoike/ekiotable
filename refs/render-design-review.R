# Render the gallery templates for visual review -----------------------------
# Run from the package root: Rscript refs/render-design-review.R
# Requires the development packages pkgload, knitr, webshot2 and Chrome.

pkgload::load_all()
output_dir <- file.path("refs", "design-review")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

gallery_code <- tempfile(fileext = ".R")
invisible(knitr::purl(
  "vignettes/articles/theme-gallery.Rmd",
  output = gallery_code,
  quiet = TRUE
))
gallery <- new.env()
source(gallery_code, local = gallery)
unlink(gallery_code)

templates <- list(
  compact = gallery$simple_table,
  complete = gallery$complete_table
)
for (palette in c("mountain", "wind", "blossom", "lake")) {
  for (kind in names(templates)) {
    tab <- gt_theme_hokusai(
      templates[[kind]],
      palette = palette,
      table_width = "680px"
    )
    stem <- file.path(output_dir, paste(palette, kind, sep = "-"))
    gt::gtsave(tab, paste0(stem, ".html"))
    gt::gtsave(
      tab,
      paste0(stem, ".png"),
      vwidth = 900,
      zoom = 1,
      expand = 20
    )
  }
}
cli::cli_inform("Review renders saved in {.path {output_dir}}.")
