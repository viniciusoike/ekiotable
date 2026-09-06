# The only file in this package that carries hex codes. `basic` and
# `ekio_brand` are pinned copies of the ekioplot token groups; ekio_pal()
# does not expose `basic`, so the theme cannot reach it upstream.
# tests/testthat/test-tokens.R checks the brand copy against ekioplot.

.ekio_local <- list(
  basic = c(
    white = "#FFFFFF",
    offwhite = "#FEFEFE",
    pivot = "#F5F3EF",
    black = "#000000"
  ),
  ekio_brand = c(
    "Baltic Blue" = "#225A7E",
    "Alabaster Grey" = "#D4DED9",
    "Soft Linen" = "#EFE8DC",
    "Air Force Blue" = "#517A90",
    "Soft Linen 2" = "#F2EDE2",
    white = "#FFFFFF",
    black = "#000000"
  )
)
