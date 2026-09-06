test_that("the font defaults are EKIO's", {
  local_font_options()
  expect_equal(.ekio_font("title"), "Lora")
  expect_equal(.ekio_font("body"), "Lato")
})

test_that("the defaults agree with ekioplot's theme", {
  local_font_options()
  expect_equal(.ekio_font("body"), formals(ekioplot::theme_ekio)$font_text)
  expect_equal(.ekio_font("title"), formals(ekioplot::theme_ekio)$font_title)
})

test_that("the registry offers the test alternatives", {
  local_font_options()
  expect_setequal(
    unname(.ekio_font_stacks),
    c("Lora", "Lato", "Georgia", "Roboto Slab", "Fira Code", "Host Grotesk")
  )
})

test_that("a registry key resolves to its family name", {
  local_font_options()
  expect_equal(.ekio_font("title", "roboto_slab"), "Roboto Slab")
  expect_equal(.ekio_font("body", "host_grotesk"), "Host Grotesk")
  expect_equal(.ekio_font("numeric", "fira_code"), "Fira Code")
})

test_that("an unknown family passes through unchanged", {
  local_font_options()
  expect_equal(.ekio_font("title", "Comic Sans MS"), "Comic Sans MS")
})

test_that("ekiotable options outrank ekioplot options", {
  local_font_options()
  withr::local_options(
    ekioplot.font_title = "Georgia",
    ekiotable.font_title = "Roboto Slab"
  )
  expect_equal(.ekio_font("title"), "Roboto Slab")
})

test_that("ekioplot options apply when ekiotable sets none", {
  local_font_options()
  withr::local_options(ekioplot.font_text = "Georgia")
  expect_equal(.ekio_font("body"), "Georgia")
})

test_that("an explicit argument outranks every option", {
  local_font_options()
  withr::local_options(ekiotable.font_body = "Georgia")
  expect_equal(.ekio_font("body", "Fira Code"), "Fira Code")
})

test_that(".ekio_font() rejects a non-string family", {
  local_font_options()
  expect_snapshot(.ekio_font("title", 12), error = TRUE)
  expect_snapshot(.ekio_font("title", c("Lora", "Lato")), error = TRUE)
})
