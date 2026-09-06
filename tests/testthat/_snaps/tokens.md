# .ekio() rejects an unknown shade or group

    Code
      .ekio("blue", 750)
    Condition
      Error in `.ekio()`:
      ! Unknown color "750" in "blue".
      i Available: "100", "200", "300", "400", "500", "600", "700", "800", and "900"

---

    Code
      .ekio("basic", "beige")
    Condition
      Error in `.ekio()`:
      ! Unknown color "beige" in "basic".
      i Available: "white", "offwhite", "pivot", and "black"

---

    Code
      .ekio("chartreuse", 500)
    Condition
      Error in `ekioplot::ekio_pal()`:
      ! Palette "chartreuse" not found.
      i Available: "gold", "accent_blue", "accent_orange", "ekio_brand", "full", "full_muted", "cool3", "cool4", "blue", "gray", "stone", "teal", "green", "orange", "red", "blue_orange", "blue_red", "teal_orange", ..., "inferno", and "plasma"

# the local basic tokens are pinned

    Code
      print(.ekio_local[["basic"]])
    Output
          white  offwhite     pivot     black 
      "#FFFFFF" "#FEFEFE" "#F5F3EF" "#000000" 

