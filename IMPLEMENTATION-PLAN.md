# ekiotable: token and font rewrite

Implementation plan for `R/utils.R` and `R/gt_theme.R`, written against
ekioplot 1.1.2 and gt 1.3.0. Every API claim below was checked in R before
being written down.

## Why this change

`ekio_pal()` changed in ekioplot 1.1.2. Subsetting a palette now drops both
the names and the `ekio_palette` class, so `ekio_pal("blue")["700"]` returns
a bare `"#1E3A5F"`. Shades also resolve by name, and a palette member can be
any named token rather than a numeric shade. The helper in `R/utils.R` still
indexes by position through `floor(shade / 100)`, which predates all of this.

Two defects follow from the positional index. `.ekio("gold", "mid")` fails
with `non-numeric argument to binary operator`, because `"mid"` never
survives the arithmetic. An out-of-range shade fails with `subscript out of
bounds` from `[[`, not the `cli_abort()` the function was written to
produce, so its `length(hex) != 1` guard is dead code.

`R/gt_theme.R` wraps five location styles in one `tryCatch` that discards
the error and returns the unstyled table. Only two of those five need it. I
tested each location against a table that lacks the relevant element, and
`cells_summary()` and `cells_grand_summary()` are the only ones that error;
`cells_row_groups()`, `cells_source_notes()` and `cells_footnotes()` all
apply cleanly. The blanket guard therefore hides real failures for no gain.

## Two decisions taken

**Tokens live here.** `basic` and `ekio_brand` are copied into ekiotable
rather than reached through ekioplot. `ekio_pal()` refuses `basic` by
design, so the theme could not otherwise name its own surfaces. Both groups
land in one new file, `R/tokens.R`, which becomes the only place in the
package where a hex code appears.

**Fonts gain alternatives.** Lora and Lato stay as the EKIO defaults, and
Georgia, Roboto Slab, Fira Code and Host Grotesk join them as named options
for testing.

## Phase 0 — Setup

Bump `ekioplot (>= 1.1.2)` in DESCRIPTION, since the rewrite depends on `[`
dropping names and class. Add `withr` to Suggests for the option-scoping
tests, and `tidyselect` to Imports if the numeric-font style ships (see
Phase 4, item 4). Create `NEWS.md` with a `# ekiotable 0.1.0` heading. Add
`^IMPLEMENTATION-PLAN\.md$` to `.Rbuildignore`.

## Phase 1 — Tests

Write all four test files, run `devtools::test()`, and confirm the expected
failures before touching `R/`. The token tests fail on `.ekio("gold",
"mid")` and on the error-message expectations. The font, validation and
`basic` tests fail because nothing implements them yet. The contrast and
options tests should pass on the current code and stand as a regression net.

### `tests/testthat/helper-gt.R`

```r
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
```

### `tests/testthat/test-tokens.R`

```r
test_that(".ekio() resolves numeric shades from ekioplot scales", {
  expect_equal(.ekio("blue", 700), unname(ekioplot::ekio_pal("blue")["700"]))
  expect_equal(.ekio("gray", 100), unname(ekioplot::ekio_pal("gray")["100"]))
})

test_that(".ekio() resolves the local basic tokens", {
  expect_equal(.ekio("basic", "white"), "#FFFFFF")
  expect_equal(.ekio("basic", "offwhite"), "#FEFEFE")
  expect_equal(.ekio("basic", "pivot"), "#F5F3EF")
  expect_equal(.ekio("basic", "black"), "#000000")
})

test_that(".ekio() resolves the local brand tokens", {
  expect_equal(.ekio("ekio_brand", "Baltic Blue"), "#225A7E")
  expect_equal(.ekio("ekio_brand", "Soft Linen"), "#EFE8DC")
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
  expect_error(.ekio("blue", 750), "750")
  expect_error(.ekio("basic", "beige"), "beige")
  expect_error(.ekio("chartreuse", 500))
  expect_snapshot(.ekio("blue", 750), error = TRUE)
  expect_snapshot(.ekio("basic", "beige"), error = TRUE)
})
```

Local tokens are pinned copies, so they can drift from ekioplot without
anything failing. `ekio_brand` is reachable through `ekio_pal()`, so that
half can be checked directly. `basic` is not, so a snapshot pins it instead.

```r
test_that("the local brand tokens match ekioplot", {
  skip_if_not_installed("ekioplot")
  upstream <- ekioplot::ekio_pal("ekio_brand")
  local <- .ekio_local[["ekio_brand"]]
  expect_equal(local[names(upstream)], unclass(upstream)[names(upstream)])
})

test_that("the local basic tokens are pinned", {
  expect_snapshot(print(.ekio_local[["basic"]]))
})
```

### `tests/testthat/test-fonts.R`

```r
test_that("the font defaults are EKIO's", {
  expect_equal(.ekio_font("title"), "Lora")
  expect_equal(.ekio_font("body"), "Lato")
})

test_that("the defaults agree with ekioplot's theme", {
  expect_equal(.ekio_font("body"), formals(ekioplot::theme_ekio)$font_text)
  expect_equal(.ekio_font("title"), formals(ekioplot::theme_ekio)$font_title)
})

test_that("the registry offers the test alternatives", {
  expect_setequal(
    unname(.ekio_font_stacks),
    c("Lora", "Lato", "Georgia", "Roboto Slab", "Fira Code", "Host Grotesk")
  )
})

test_that("a registry key resolves to its family name", {
  expect_equal(.ekio_font("title", "roboto_slab"), "Roboto Slab")
  expect_equal(.ekio_font("body", "host_grotesk"), "Host Grotesk")
  expect_equal(.ekio_font("numeric", "fira_code"), "Fira Code")
})

test_that("an unknown family passes through unchanged", {
  expect_equal(.ekio_font("title", "Comic Sans MS"), "Comic Sans MS")
})

test_that("ekiotable options outrank ekioplot options", {
  withr::local_options(
    ekioplot.font_title = "Georgia",
    ekiotable.font_title = "Roboto Slab"
  )
  expect_equal(.ekio_font("title"), "Roboto Slab")
})

test_that("ekioplot options apply when ekiotable sets none", {
  withr::local_options(ekioplot.font_text = "Georgia")
  expect_equal(.ekio_font("body"), "Georgia")
})

test_that("an explicit argument outranks every option", {
  withr::local_options(ekiotable.font_body = "Georgia")
  expect_equal(.ekio_font("body", "Fira Code"), "Fira Code")
})

test_that(".ekio_font() rejects a non-string family", {
  expect_error(.ekio_font("title", 12), "font")
  expect_error(.ekio_font("title", c("Lora", "Lato")), "font")
})
```

### `tests/testthat/test-gt-theme.R`

**Contract and validation.** The validation block fails until Phase 4.

```r
test_that("gt_theme_ekio() returns a gt table and rejects other input", {
  expect_s3_class(gt_theme_ekio(small_tbl()), "gt_tbl")
  expect_error(gt_theme_ekio(mtcars), "gt table")
})

test_that("gt_theme_ekio() validates its arguments", {
  expect_error(gt_theme_ekio(small_tbl(), font_size = "14"), "font_size")
  expect_error(gt_theme_ekio(small_tbl(), font_size = c(12, 14)), "font_size")
  expect_error(gt_theme_ekio(small_tbl(), font_size = -1), "font_size")
  expect_error(gt_theme_ekio(small_tbl(), table_width = 100), "table_width")
  expect_error(gt_theme_ekio(small_tbl(), stripe = "yes"), "stripe")
  expect_error(gt_theme_ekio(small_tbl(), add_footer = NA), "add_footer")
  expect_error(gt_theme_ekio(small_tbl(), font_title = 1), "font_title")
})
```

**Arguments reach the output.** Nothing today proves `font_size` or
`stripe` change anything.

```r
test_that("arguments reach the gt options", {
  out <- gt_theme_ekio(small_tbl(), font_size = 12, table_width = "80%")
  expect_equal(gt_option(out, "table_font_size"), "12px")
  expect_equal(gt_option(out, "table_width"), "80%")
})

test_that("stripe toggles body striping", {
  on <- gt_theme_ekio(small_tbl(), stripe = TRUE)
  off <- gt_theme_ekio(small_tbl(), stripe = FALSE)
  expect_true(gt_option(on, "row_striping_include_table_body"))
  expect_false(gt_option(off, "row_striping_include_table_body"))
})

test_that("add_footer controls the EKIO source note", {
  with_note <- gt_theme_ekio(small_tbl(), add_footer = TRUE)
  without <- gt_theme_ekio(small_tbl(), add_footer = FALSE)
  expect_length(with_note[["_source_notes"]], 1)
  expect_length(without[["_source_notes"]], 0)
})
```

**Fonts reach the output.** `opt_table_font()` prepends to the
`table_font_names` option; `cell_text(font = )` records under
`$cell_text$font` in the styles table.

```r
test_that("the body font heads the gt font stack", {
  out <- gt_theme_ekio(small_tbl())
  expect_equal(unlist(gt_option(out, "table_font_names"))[[1]], "Lato")
})

test_that("the title carries the title font", {
  out <- gt_theme_ekio(small_tbl() |> gt::tab_header("T"))
  fonts <- vapply(
    gt_styles_at(out, "title"),
    function(s) {
      font <- s$cell_text$font
      return(if (is.null(font)) NA_character_ else font)
    },
    character(1)
  )
  expect_true("Lora" %in% fonts)
})

test_that("every registry font can drive a table", {
  for (font in .ekio_font_stacks) {
    out <- gt_theme_ekio(small_tbl(), font_body = font)
    expect_equal(unlist(gt_option(out, "table_font_names"))[[1]], font)
  }
})

test_that("a registry key works as an argument", {
  out <- gt_theme_ekio(small_tbl(), font_body = "fira_code")
  expect_equal(unlist(gt_option(out, "table_font_names"))[[1]], "Fira Code")
})
```

**Brand sourcing.** These bind the theme to its tokens rather than to
frozen literals, so a token change propagates instead of silently diverging.

```r
test_that("the theme takes its colors from the token helper", {
  out <- gt_theme_ekio(small_tbl())
  expect_equal(
    gt_option(out, "column_labels_background_color"),
    unname(ekioplot::ekio_pal("blue")["700"])
  )
  expect_equal(
    gt_option(out, "table_font_color"),
    unname(ekioplot::ekio_pal("gray")["900"])
  )
  expect_equal(
    gt_option(out, "row_striping_background_color"),
    unname(ekioplot::ekio_pal("gray")["200"])
  )
  expect_equal(as_hex(gt_option(out, "heading_background_color")), "#FFFFFF")
})

test_that("hex codes appear only in the token file", {
  r_dir <- test_path("..", "..", "R")
  skip_if_not(dir.exists(r_dir), "package source not available")
  files <- setdiff(list.files(r_dir, full.names = TRUE), file.path(r_dir, "tokens.R"))
  code <- unlist(lapply(files, readLines))
  expect_false(any(grepl("#[0-9A-Fa-f]{6}\\b", code)))
})
```

**Output quality: WCAG contrast.** This is the test that checks the table
is readable. It walks every style gt recorded that pairs text with a fill,
scores it with `ekio_contrast()`, then checks the surface pairs that come
from `tab_options()` instead. I ran the numbers on the current theme. White
on blue.700 scores 11.5, blue.700 on blue.100 scores 10.4, gray.900 on
gray.200 scores 11.5, and the weakest pair, gray.600 on gray.100, scores
6.74. A 4.5 threshold therefore passes with room while still catching a
genuine regression.

```r
test_that("text on colored fills clears WCAG AA", {
  out <- gt_theme_ekio(grouped_tbl())
  ratios <- vapply(out[["_styles"]]$styles, function(s) {
    if (is.null(s$cell_text$color) || is.null(s$cell_fill$color)) {
      return(NA_real_)
    }
    return(ekioplot::ekio_contrast(s$cell_text$color, s$cell_fill$color))
  }, numeric(1))
  ratios <- ratios[!is.na(ratios)]
  expect_gt(length(ratios), 0)
  expect_true(all(ratios >= 4.5))
})

test_that("body text clears WCAG AA on every surface it lands on", {
  out <- gt_theme_ekio(small_tbl())
  body <- gt_option(out, "table_font_color")
  surfaces <- c(
    gt_option(out, "table_background_color"),
    gt_option(out, "row_striping_background_color"),
    gt_option(out, "summary_row_background_color")
  )
  expect_true(all(ekioplot::ekio_contrast(body, surfaces) >= 4.5))
})
```

**Robustness across table shapes.** This is what the blanket `tryCatch`
stood in for. A table with summary rows and one without must both come back
fully styled.

```r
test_that("a grouped table gets its row-group styles", {
  out <- gt_theme_ekio(grouped_tbl())
  expect_true("row_groups" %in% out[["_styles"]]$locname)
})

test_that("a table with no summary rows still gets every other style", {
  out <- gt_theme_ekio(small_tbl())
  expect_true(all(
    c("columns_columns", "title", "stub", "source_notes") %in%
      out[["_styles"]]$locname
  ))
})

test_that("a table with summary rows gets the summary styles", {
  tbl <- grouped_tbl() |>
    gt::summary_rows(groups = "a", columns = "x", fns = list(avg = ~ mean(.)))
  out <- gt_theme_ekio(tbl)
  expect_true(any(grepl("summary", out[["_styles"]]$locname)))
})
```

**Regression snapshot.** Snapshot the resolved options, not the rendered
HTML, which carries a random table id.

```r
test_that("the resolved theme options are stable", {
  out <- gt_theme_ekio(small_tbl())
  opts <- out[["_options"]]
  themed <- opts[!is.na(opts$value) & opts$category != "table_body", ]
  expect_snapshot(print(as.data.frame(themed[, c("parameter", "value")])))
})
```

## Phase 2 — `R/tokens.R` (new)

One file holds every literal in the package. Values below come from
ekioplot's `inst/ekio-palettes.yaml`.

```r
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
```

## Phase 3 — `R/utils.R`

**Token access.** `.ekio()` checks the local groups first, then falls back
to `ekio_pal()`, mirroring how ekioplot dispatches internally.

```r
.ekio <- function(group, n) {
  pal <- if (group %in% names(.ekio_local)) {
    .ekio_local[[group]]
  } else {
    ekioplot::ekio_pal(group)
  }

  hex <- pal[as.character(n)]

  if (is.na(hex)) {
    cli::cli_abort(c(
      "Unknown color {.val {as.character(n)}} in {.val {group}}.",
      "i" = "Available: {.val {names(pal)}}"
    ))
  }
  return(unname(hex))
}
```

Name lookup replaces `floor(shade / 100)`, which unlocks `gold`,
`ekio_brand` and every other named token. `unname()` stays, because base R
keeps the name when a plain character vector is subset; only ekioplot's `[`
method drops it. `as.character()` on the palette goes.

**Fonts.** Lora and Lato remain the defaults, matching `theme_ekio()`.
Georgia, Roboto Slab, Fira Code and Host Grotesk join as named options.

```r
.ekio_font_stacks <- c(
  lora = "Lora",
  lato = "Lato",
  georgia = "Georgia",
  roboto_slab = "Roboto Slab",
  fira_code = "Fira Code",
  host_grotesk = "Host Grotesk"
)

.font_defaults <- c(
  title = "Lora",
  body = "Lato",
  numeric = "Lato",
  labels = "Lato"
)

# Resolution order: explicit family, then the ekiotable option, then the
# ekioplot option so a user who themes their charts themes their tables,
# then the EKIO default. A registry key resolves to its family name;
# anything else passes through as a literal family.
.ekio_font <- function(role, family = NULL) {
  role <- match.arg(role, names(.font_defaults))

  if (is.null(family)) {
    family <- getOption(paste0("ekiotable.font_", role))
  }
  if (is.null(family)) {
    family <- switch(
      role,
      title = getOption("ekioplot.font_title"),
      body = getOption("ekioplot.font_text"),
      NULL
    )
  }
  if (is.null(family)) {
    family <- .font_defaults[[role]]
  }
  if (!is.character(family) || length(family) != 1L || is.na(family)) {
    cli::cli_abort("Each font must be a single family name.")
  }
  if (family %in% names(.ekio_font_stacks)) {
    family <- .ekio_font_stacks[[family]]
  }
  return(unname(family))
}
```

The old `.font_serif`, `.font_cond`, `.font_main` and `.font_number`
constants go. Host Grotesk and Fira Code survive as the `labels` and
`numeric` options rather than as unused constants. Fix the file header,
which forbids hardcoded font names directly above four hardcoded font
names.

## Phase 4 — `R/gt_theme.R`

1. Add `.validate_gt_theme_args()`, checking that `table_width` is a
   string, `font_size` a positive scalar number, and `stripe` and
   `add_footer` non-`NA` scalar logicals. Pass `call = caller_env()` so
   errors name `gt_theme_ekio()`.
2. Add `font_title`, `font_body`, `font_numeric` and `font_labels`
   arguments, each defaulting to `NULL` and resolved through
   `.ekio_font()`. Set the body font with `gt::opt_table_font()` and the
   title font with `gt::cell_text(font = )` on `cells_title(groups =
   "title")`, matching `theme_ekio()`, which puts Lora on titles and Lato
   on body text. Tables currently put Lato everywhere, so this changes
   rendered output.
3. Replace the literal `"white"` heading background with
   `.ekio("basic", "white")`, now that `basic` is local.
4. Apply `font_numeric` to numeric columns through
   `gt::cells_body(columns = tidyselect::where(is.numeric))`, and
   `font_labels` to `cells_column_labels()`. Both stay inert unless the
   user sets them, since both default to the body font. This step adds
   `tidyselect` to Imports; drop it if you would rather not take the
   dependency, and the two arguments with it.
5. Replace the four hardcoded `"white"` text colors on blue fills with
   `ekioplot::ekio_text_on(colors$primary)` and
   `ekio_text_on(colors$primary_dark)`. Both resolve to white today, so
   the visual output holds, but contrast now follows the token.
6. Move the row-group, source-note and footnote styles into the main
   pipeline. Keep a `tryCatch` around `cells_summary()` and
   `cells_grand_summary()` only, with a comment naming the gt behavior it
   works around.
7. Add the explicit `return(styled_table)` the style rules require.
8. Restyle the section headers to `# Section ----` padded to about 76
   characters.

## Phase 5 — Verify

Run `devtools::document()`, then `devtools::test()`, then
`devtools::check()`. Read the snapshot diff and confirm it shows only the
intended option and font changes before accepting the new `_snaps/` files.
Render the README to check the title font change in a real table.

## Open question

Item 4 is the only step that adds a dependency, and the only one whose
arguments do nothing by default. Say the word if you would rather ship the
font work as `font_title` and `font_body` alone.


## Implementation review — 2026-09-05

Implemented all phases, including numeric and label font options and the
`tidyselect` dependency. Review identified these adjustments:

- Numeric and label fonts inherit the resolved body font, including an explicit
  body argument, unless their own argument or option is set. The draft helper's
  fixed Lato defaults would not have honored this behavior.
- gt 1.3.0's default summary selectors also fail for populated summaries.
  Use `rows = TRUE` and style each row group separately: a group without summary
  rows must not discard the styles applied to another group's summaries.
- Validation also rejects empty strings and non-finite font sizes.
- The README now documents local token copies and font precedence, with a
  rendered table image so GitHub displays the styling.
- Existing local HTML, plotting, and reference artifacts are excluded from the
  package build.

Tests cover token lookup, option precedence, numeric-only font targeting,
partial group summaries, grand summaries, empty and text-only tables, contrast,
validation messages, and resolved theme options.
