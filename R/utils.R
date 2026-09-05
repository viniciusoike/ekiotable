# Brand tokens come from ekioplot, which is the single source of truth for
# EKIO color and type. Never hardcode hex codes or font names here.

# ---- Brand Token Access ----

# Single brand color by scale and shade, e.g. .ekio("blue", 700).
.ekio <- function(scale, shade) {
  shade <- floor(shade / 100)
  palette <- as.character(ekioplot::ekio_pal(scale))

  hex <- palette[[shade]]

  if (length(hex) != 1) {
    cli::cli_abort(
      "No shade {.val {as.character(shade)}} in scale {.val {scale}}."
    )
  }
  return(unname(hex))
}

.font_serif <- "Lora"
.font_cond <- "Host Grotesk"
.font_main <- "Lato"
.font_number <- "Fira Code"
