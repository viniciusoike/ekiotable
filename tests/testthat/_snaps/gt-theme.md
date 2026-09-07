# gt_theme_ekio() validates its inputs

    Code
      gt_theme_ekio(mtcars)
    Condition
      Error in `gt_theme_ekio()`:
      ! `data` must be a gt table object

---

    Code
      gt_theme_ekio(small_tbl(), table_width = 100)
    Condition
      Error in `gt_theme_ekio()`:
      ! `table_width` must be a single non-empty string.

---

    Code
      gt_theme_ekio(small_tbl(), font_size = 0)
    Condition
      Error in `gt_theme_ekio()`:
      ! `font_size` must be a single positive finite number.

---

    Code
      gt_theme_ekio(small_tbl(), stripe = "yes")
    Condition
      Error in `gt_theme_ekio()`:
      ! `stripe` must be TRUE or FALSE.

# gt_theme_ekio() rejects a non-string font family

    Code
      gt_theme_ekio(small_tbl(), font_title = 1)
    Condition
      Error in `gt_theme_ekio()`:
      ! `font_title` must be a single non-empty family name.

