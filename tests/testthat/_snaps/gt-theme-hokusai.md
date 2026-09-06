# Hokusai validates data and palette choices

    Code
      gt_theme_hokusai(mtcars)
    Condition
      Error in `gt_theme_hokusai()`:
      ! `data` must be a gt table object

---

    Code
      gt_theme_hokusai(small_tbl(), palette = "unknown")
    Condition
      Error in `match.arg()`:
      ! 'arg' should be one of "mountain", "wind", "blossom", "lake"

# gridlines can be enabled without changing data or emphasis

    Code
      gt_theme_hokusai(tbl, gridlines = NA)
    Condition
      Error in `gt_theme_hokusai()`:
      ! `gridlines` must be TRUE or FALSE.
