# .ekio_font() rejects a non-string family

    Code
      .ekio_font("title", 12)
    Condition
      Error:
      ! `font_title` must be a single non-empty family name.

---

    Code
      .ekio_font("title", c("Lora", "Lato"))
    Condition
      Error:
      ! `font_title` must be a single non-empty family name.

