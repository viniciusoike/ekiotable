# ekiotable 0.1.0

* Color tokens now resolve by name, including named shades and local basic and brand colors, with informative errors for unknown colors.
* `gt_theme_ekio()` now uses Lora for titles and supports configurable title, body, numeric, and label fonts through arguments and options.
* `gt_theme_ekio()` validates its arguments and preserves styles across tables with missing or partially populated summary groups. Text on blue fills follows the palette contrast choice.
