# Hokusai design review, 11 November 2026

Sol and Fable 5.2 independently inspected eight freshly rendered tables:
the compact and complete gallery templates in mountain, wind, blossom,
and lake. Both found the inverted headers readable, the stripes subtle,
and the hierarchy coherent. Neither reported a truthfulness defect or
blocking table-design defect. Fable reported a small PNG capture crop;
the final renders below use wider capture margins.

The review target is a clean, minimal report table using the existing
Hokusai standard: striped body rows, inverted blue headers, fine rules,
and the current palette colors. These choices remain in place.

## Feedback and disposition

| Reviewer | Finding | Disposition |
| --- | --- | --- |
| Sol | “Category / size” repeats the row-group category. | Changed the complete template's stubhead to “Size”. |
| Sol | The final subtotal rule crowds the grand-total double rule. | [Issue #16](https://github.com/viniciusoike/ekiotable/issues/16); verify collapsed-border behavior before changing shared structure. |
| Fable | Complete PNGs touch the right image edge. | Added a reproducible renderer with 20px capture expansion; inspected all final PNGs. |
| Fable | Stripe phase changes between row groups. | [Issue #15](https://github.com/viniciusoike/ekiotable/issues/15); compare group resets with current global striping. |
| Fable | Numeric columns have uneven gaps. | Assigned equal widths to numeric columns within each reusable template. |
| Fable | Titles sit too close to the band. | Increased Hokusai heading padding from 4px to 8px. |
| Fable | Ungrouped tables have a paper-colored line below the band. | Matched column-label and stubhead bottom borders to the band; retained paper-colored spanner rules. |
| Fable | Spanner underlines have asymmetric insets. | [Issue #17](https://github.com/viniciusoike/ekiotable/issues/17); low-priority gt geometry. |
| Fable | Header footnote marks shift numeric label alignment. | [Issue #18](https://github.com/viniciusoike/ekiotable/issues/18); tested `placement = "left"`, but installed gt still renders header marks on the right. |
| Fable | Blossom copy overstates the band difference. | Described the dark title ink and beige labels without claiming a brighter band. |
| Fable | One formatting call has a stray indent. | Aligned it with the surrounding pipeline. |
| Fable | Blank average-price totals could show weighted averages. | Kept the documented additive-only summary template; weighted averages would be a separate content choice. |

Fable measured label-on-band contrast at 7.46:1 (mountain), 4.86:1 (wind),
4.84:1 (blossom), and 4.98:1 (lake), and reported body, note, and summary
text above 5.4:1. These are reviewer measurements of the baseline palette;
the palette values have not changed. Sol reported no contrast failures.

Both reviews cover desktop PNGs. They do not establish narrow-screen
legibility, font availability on other systems, or approval of the final
changes by the reviewers. The final output was checked by the integrating
agent after implementation.

The review baseline was commit `9ba9b447`. Rendering used gt 1.3.0 and
webshot2 0.1.2. Validation after the changes passed 307 test expectations
and `R CMD check --no-manual` with no errors, warnings, or notes.

## Reproduce the renders

From the package root, run `Rscript refs/render-design-review.R`. The
script extracts the current gallery code, loads the local package, and
saves compact and complete tables in all four palettes. It requires
pkgload, knitr, webshot2, and Chrome in the development environment.

Each table is 680px wide, captured at zoom 1 in a 900px viewport with
20px expansion. PNGs are committed; matching HTML files are generated
beside them and ignored by Git. This keeps review artifacts tied to the
same templates used in the published gallery.

| Palette | Compact | Complete |
| --- | --- | --- |
| Mountain | [PNG](mountain-compact.png) | [PNG](mountain-complete.png) |
| Wind | [PNG](wind-compact.png) | [PNG](wind-complete.png) |
| Blossom | [PNG](blossom-compact.png) | [PNG](blossom-complete.png) |
| Lake | [PNG](lake-compact.png) | [PNG](lake-complete.png) |
