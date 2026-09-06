
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![](https://www.r-pkg.org/badges/version/ekiotable)](https://cran.r-project.org/package=ekiotable)
[![CRAN
checks](https://badges.cranchecks.info/worst/ekiotable.svg)](https://cran.r-project.org/web/checks/check_results_ekiotable.html)

# ekiotable

ekiotable applies the EKIO visual identity to
[gt](https://gt.rstudio.com) tables, with the Lora and Lato type pairing
used across EKIO charts and reports.

## Installation

ekiotable is not on CRAN. Install it from GitHub with remotes. Its only
non-CRAN dependency,
[ekioplot](https://github.com/viniciusoike/ekioplot), must be installed
first, because remotes resolves dependencies from CRAN only.

``` r
# install.packages("remotes")
remotes::install_github("viniciusoike/ekioplot")
remotes::install_github("viniciusoike/ekiotable")
```

Alternatively, install both packages from the [viniciusoike
r-universe](https://viniciusoike.r-universe.dev) in a single call:

``` r
install.packages(
  "ekiotable",
  repos = c("https://viniciusoike.r-universe.dev", "https://cloud.r-project.org")
)
```

## Themes

ekiotable ships three themes for gt tables:

- `gt_theme_ekio()` — the default EKIO theme: filled blue column labels,
  banded row groups, and an automatic EKIO source note.
- `gt_theme_ekio_alt()` — experimental alternative: keeps the blue
  header band, replaces filled group bands with Baltic Blue rules, and
  uses tabular numerals. No footer is added.
- `gt_theme_hokusai()` — a minimal blue-and-paper theme with four
  palettes (`mountain`, `wind`, `blossom`, `lake`), optional gridlines,
  and no footer.

## Usage

``` r
library(gt)
library(ekiotable)

head(mtcars, 10) |>
  gt() |>
  gt_theme_ekio()
```

`gt_theme_ekio()` styles headers, column labels, row groups, summary
rows, stubs, source notes, and footnotes, and adds an EKIO source note
by default:

``` r
gt_theme_ekio(
  data,
  table_width = "100%",
  font_size = 14,
  stripe = TRUE,
  add_footer = TRUE
)
```

<img src="man/figures/README-example-table.png" alt="EKIO table with a serif title, blue column labels, and alternating gray rows." width="100%" />
