# gt_theme_ekio_alt() validates its inputs

    Code
      gt_theme_ekio_alt(mtcars)
    Condition
      Error in `gt_theme_ekio_alt()`:
      ! `data` must be a gt table object

---

    Code
      gt_theme_ekio_alt(small_tbl(), table_width = 100)
    Condition
      Error in `gt_theme_ekio_alt()`:
      ! `table_width` must be a single non-empty string.

---

    Code
      gt_theme_ekio_alt(small_tbl(), font_size = 0)
    Condition
      Error in `gt_theme_ekio_alt()`:
      ! `font_size` must be a single positive finite number.

---

    Code
      gt_theme_ekio_alt(small_tbl(), stripe = "yes")
    Condition
      Error in `gt_theme_ekio_alt()`:
      ! `stripe` must be TRUE or FALSE.

# gt_theme_ekio_alt() rejects a non-string font family

    Code
      gt_theme_ekio_alt(small_tbl(), font_title = 1)
    Condition
      Error in `gt_theme_ekio_alt()`:
      ! `font_title` must be a single non-empty family name.

