# Brand tokens come from ekioplot, which is the single source of truth for
# EKIO color and type. Never hardcode hex codes or font names here.

# ---- Brand Token Access ----

# Single brand color by scale and shade, e.g. .ekio("blue", 700).
.ekio <- function(scale, shade) {
  pal <- ekioplot::ekio_pal(scale)
  # Single-bracket: [[ errors on a missing name instead of returning NA
  hex <- pal[as.character(shade)]
  if (is.na(hex)) {
    cli::cli_abort(
      "No shade {.val {as.character(shade)}} in scale {.val {scale}}."
    )
  }
  unname(hex)
}
