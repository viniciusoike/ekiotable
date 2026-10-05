# Hex codes live in two places. `basic` here is a pinned copy of the
# ekioplot token group of the same name: ekio_pal() does not expose it, so
# the themes cannot reach these surfaces upstream. The Hokusai palettes live
# in `R/utils.R` as explicit hex values. Every other token resolves live
# through ekioplot::ekio_pal(), so palette revisions arrive without an edit
# here.
# tests/testthat/test-tokens.R checks the copy against theme_ekio().

.ekio_local <- list(
  basic = c(
    white = "#FFFFFF",
    offwhite = "#FBFBF6",
    cold = "#F6F7F8",
    card = "#FFFFFC",
    nav = "#F7F5EE",
    sunk = "#F3EFE4",
    sunk_text = "#63676C",
    pivot = "#F5F3EF",
    black = "#000000"
  )
)
