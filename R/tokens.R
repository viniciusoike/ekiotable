# The only file in this package that carries hex codes. `basic` is a pinned
# copy of the ekioplot token group of the same name: ekio_pal() does not
# expose it, so the themes cannot reach these surfaces upstream. Every other
# token resolves live through ekioplot::ekio_pal(), so palette revisions
# arrive without an edit here.
# tests/testthat/test-tokens.R checks the copy against theme_ekio().

.ekio_local <- list(
  basic = c(
    white = "#FFFFFF",
    offwhite = "#FBFBF6",
    cold = "#F6F7F8",
    pivot = "#F5F3EF",
    black = "#000000"
  )
)
