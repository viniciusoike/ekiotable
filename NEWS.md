# ekiotable 0.1.0

* Color tokens now resolve by name, including named shades and local basic and brand colors, with informative errors for unknown colors.
* `gt_theme_ekio()` now uses Lora for titles and supports configurable title, body, numeric, and label fonts through arguments and options.
* `gt_theme_ekio()` validates its arguments and preserves styles across tables with missing or partially populated summary groups. Text on blue fills follows the palette contrast choice.

* `gt_theme_ekio_alt()` is now exported: the experimental alternative theme is part of the public API.

* `gt_theme_hokusai()` adds a minimal blue theme with four palettes extracted from Hokusai reproductions: mountain, wind, blossom, and lake. A shared neutral gray scale supplies gridline, divider, and zebra stripe colors.

* `gt_theme_hokusai()` supports optional light-gray cell gridlines with `gridlines = TRUE` and uses dark-gray body text, column labels, subtitles, and notes, reserving blue for emphasis. Zebra stripes now extend across stub labels.
