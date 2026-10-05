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
      i Available: "white", "offwhite", "cold", "card", "nav", "sunk", "sunk_text", "pivot", and "black"

---

    Code
      .ekio("chartreuse", 500)
    Condition
      Error in `ekioplot::ekio_pal()`:
      ! Palette "chartreuse" not found.
      i Available: "gold", "accent_blue", "accent_orange", "ekio_brand", "yoro_blue", "yoro_green", "full", "full_muted", "full_light", "spectrum_light", "cool3", "cool4", "blue", "gray", "stone", "teal", "green", "orange", ..., "inferno", and "plasma"

# the local basic tokens are pinned

    Code
      print(.ekio_local[["basic"]])
    Output
          white  offwhite      cold      card       nav      sunk sunk_text     pivot 
      "#FFFFFF" "#FBFBF6" "#F6F7F8" "#FFFFFC" "#F7F5EE" "#F3EFE4" "#63676C" "#F5F3EF" 
          black 
      "#000000" 

