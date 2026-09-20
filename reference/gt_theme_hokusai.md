# Apply a Minimal Hokusai Theme to GT Tables

Blue typography and fine horizontal rules inspired by four supplied
Hokusai reproductions. White backgrounds and pale paper tints keep
analytical tables clean; color does not encode data values. No footer is
added.

## Usage

``` r
gt_theme_hokusai(
  data,
  palette = c("mountain", "wind", "blossom", "lake"),
  table_width = "100%",
  font_size = 12,
  stripe = FALSE,
  font_title = NULL,
  font_body = NULL,
  font_numeric = NULL,
  font_labels = NULL,
  font_stub = NULL,
  gridlines = FALSE,
  reversed = FALSE
)
```

## Arguments

- data:

  A gt table object.

- palette:

  One of `"mountain"` (default), `"wind"`, `"blossom"`, or `"lake"`.
  Each uses blues and paper tones extracted from a different print.

- table_width:

  Character. Width of the table (default: `"100%"`).

- font_size:

  Numeric. Body font size in pixels (default: 12). Column labels and the
  subtitle are 2px larger, the title 8px larger, and source notes and
  footnotes 1px smaller.

- stripe:

  Logical. Apply subtle alternating row shading (default: FALSE).

- font_title, font_body, font_numeric, font_labels:

  A font family or registry key (`lora`, `lato`, `georgia`,
  `roboto_slab`, `fira_code`, `host_grotesk`). `NULL` uses the
  corresponding `ekiotable.font_<role>` option. Title and body then use
  `ekioplot.font_title` and `ekioplot.font_text`, respectively, before
  falling back to Lora and Lato. Numeric and label fonts inherit the
  resolved body font unless explicitly set or configured through their
  role option. Fonts must be available to the renderer; this function
  does not install them.

- font_stub:

  A font family or registry key for stub (row label) cells. `NULL` uses
  the `ekiotable.font_stub` option and then the resolved body font, so
  row labels stay with the body typography unless you move them.

- gridlines:

  Logical. Show light-gray horizontal and vertical cell rules (default:
  FALSE). Section and outer accent rules remain visible.

- reversed:

  Logical. Fill column labels and spanners with the palette blue and use
  the palette paper color for their text and rules (default: FALSE).

## Value

A styled gt table object.

## Details

The palettes are stored as explicit hex values in `R/utils.R`. Mountain
uses the supplied mountain landscape, wind the windy field, blossom the
bullfinch and weeping cherry, and lake the lakeside landscape. Blues and
paper colors are extracted from the digital reproductions; summary fills
are lightened paper tones on a neutral white canvas. All palettes
include a shared neutral gray scale (`gray_50` to `gray_900`). Zebra
stripes use `gray_100`, gridlines use `gray_200`, and structural
dividers use `gray_300`.

Body text and column labels use dark gray; subtitles and notes use a
softer dark gray. Blue emphasizes titles, group headings, and summaries.

Column labels sit above the body in size and are set in semibold. Stub
cells are also semibold. Families that ship semibold under a separate
family name, such as Host Grotesk, are named in the label and stub font
stacks so the weight resolves.

Apply the theme before any cell-specific highlighting. Font arguments
and options follow
[`gt_theme_ekio()`](https://viniciusoike.github.io/ekiotable/reference/gt_theme_ekio.md).

## Examples

``` r
head(mtcars) |>
  gt::gt() |>
  gt_theme_hokusai()


  

mpg
```
