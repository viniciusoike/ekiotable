
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ekiotable

ekiotable applies the EKIO visual identity to
[gt](https://gt.rstudio.com) tables, with the Lora and Lato type pairing
used across EKIO charts and reports.

## Installation

ekiotable and its only non-CRAN dependency,
[ekioplot](https://github.com/viniciusoike/ekioplot), ship from the
[viniciusoike r-universe](https://viniciusoike.r-universe.dev). Neither
package is on CRAN. The command below installs both;
`install.packages()` resolves `ekioplot` from the same universe
automatically.

``` r
install.packages(
  "ekiotable",
  repos = c("https://viniciusoike.r-universe.dev", "https://cloud.r-project.org")
)
```

## Themes

ekiotable ships two themes for gt tables:

- `gt_theme_ekio()` — the default EKIO theme: filled blue column labels,
  unfilled group headings with Baltic Blue rules, and tabular numerals.
  No footer is added.
- `gt_theme_hokusai()` — a minimal blue-and-paper theme with four
  palettes (`mountain`, `wind`, `blossom`, `lake`), optional gridlines,
  and no footer.
