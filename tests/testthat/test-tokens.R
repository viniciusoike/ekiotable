test_that(".ekio() resolves numeric shades from ekioplot scales", {
  expect_equal(.ekio("blue", 700), unname(ekioplot::ekio_pal("blue")["700"]))
  expect_equal(.ekio("gray", 100), unname(ekioplot::ekio_pal("gray")["100"]))
})

test_that(".ekio() resolves the local basic tokens", {
  expect_equal(.ekio("basic", "white"), "#FFFFFF")
  expect_equal(.ekio("basic", "offwhite"), "#FBFBF6")
  expect_equal(.ekio("basic", "cold"), "#F6F7F8")
  expect_equal(.ekio("basic", "pivot"), "#F5F3EF")
  expect_equal(.ekio("basic", "black"), "#000000")
})

test_that(".ekio() resolves brand tokens from ekioplot", {
  skip_if_not_installed("ekioplot")
  upstream <- ekioplot::ekio_pal("ekio_brand")

  expect_equal(
    .ekio("ekio_brand", "Baltic Blue"),
    unname(upstream["Baltic Blue"])
  )
  expect_equal(
    .ekio("ekio_brand", "Soft Linen"),
    unname(upstream["Soft Linen"])
  )
})

test_that("basic is the only group the package pins", {
  expect_equal(names(.ekio_local), "basic")
})

test_that(".ekio() resolves named tokens from ekioplot, not only shades", {
  expect_equal(.ekio("gold", "mid"), unname(ekioplot::ekio_pal("gold")["mid"]))
})

test_that(".ekio() returns a bare hex string", {
  for (tok in list(c("blue", "700"), c("basic", "white"))) {
    hex <- .ekio(tok[1], tok[2])
    expect_type(hex, "character")
    expect_length(hex, 1)
    expect_null(names(hex))
    expect_s3_class(hex, NA)
    expect_match(hex, "^#[0-9A-F]{6}$", ignore.case = TRUE)
  }
})

test_that(".ekio() rejects an unknown shade or group", {
  expect_snapshot(.ekio("blue", 750), error = TRUE)
  expect_snapshot(.ekio("basic", "beige"), error = TRUE)
  expect_snapshot(.ekio("chartreuse", 500), error = TRUE)
})

test_that("the local basic tokens are pinned", {
  expect_snapshot(print(.ekio_local[["basic"]]))
})

test_that("the pinned surfaces match the ekioplot theme surfaces", {
  skip_if_not_installed("ekioplot")
  # ekio_pal() does not expose `basic`, so the copy cannot be checked against
  # a palette. theme_ekio() writes the surface into the panel fill, which is
  # the one place upstream exposes it.
  surface_fill <- function(background) {
    theme <- ekioplot::theme_ekio(background = background)
    return(toupper(theme$panel.background$fill))
  }

  for (surface in c("offwhite", "white", "cold")) {
    expect_equal(.ekio("basic", surface), surface_fill(surface))
  }
})
