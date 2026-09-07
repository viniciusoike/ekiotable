# Token and font resolution -------------------------------------------------

.ekio <- function(group, n) {
  if (!is.character(group) || length(group) != 1L || is.na(group)) {
    cli::cli_abort("{.arg group} must be a single token group name.")
  }
  if (length(n) != 1L || is.na(n) || !(is.character(n) || is.numeric(n))) {
    cli::cli_abort("{.arg n} must be a single color name or shade.")
  }
  pal <- if (group %in% names(.ekio_local)) {
    .ekio_local[[group]]
  } else {
    ekioplot::ekio_pal(group)
  }

  hex <- pal[as.character(n)]

  if (is.na(hex)) {
    cli::cli_abort(c(
      "Unknown color {.val {as.character(n)}} in {.val {group}}.",
      "i" = "Available: {.val {names(pal)}}"
    ))
  }
  return(unname(hex))
}

.ekio_font_stacks <- c(
  lora = "Lora",
  lato = "Lato",
  georgia = "Georgia",
  roboto_slab = "Roboto Slab",
  fira_code = "Fira Code",
  host_grotesk = "Host Grotesk"
)

.font_defaults <- c(
  title = "Lora",
  body = "Lato",
  numeric = "Lato",
  labels = "Lato",
  stub = "Lato"
)

# Some families ship every weight under its own family name, so the base
# family holds only 400 and 700. A CSS request for weight 600 against it
# matches the 700 face. Naming the semibold family first gives the browser
# an exact match and leaves the base family as the fallback.
.ekio_semibold_families <- c(
  "Host Grotesk" = "Host Grotesk SemiBold"
)

# opt_table_font() appends the system stack to whatever family it is given.
# tab_style() emits the family exactly as written, so a cell-level font needs
# the same fallbacks added back or a missing family drops to the browser
# default while the rest of the table drops to system-ui.
.ekio_font_stack <- function(family) {
  return(c(family, gt::default_fonts()))
}

# Assumes an already-resolved family name. Families that carry their own
# semibold face pass through unchanged.
.ekio_font_semibold <- function(family) {
  semibold <- .ekio_semibold_families[family]
  if (is.na(semibold)) {
    return(family)
  }
  return(unname(c(semibold, family)))
}

# Resolution order: explicit family, then the ekiotable option, then the
# ekioplot option so a user who themes their charts themes their tables,
# then the EKIO default. A registry key resolves to its family name;
# anything else passes through as a literal family.
.ekio_font <- function(
  role,
  family = NULL,
  fallback = NULL,
  call = parent.frame()
) {
  role <- match.arg(role, names(.font_defaults))

  if (is.null(family)) {
    family <- getOption(paste0("ekiotable.font_", role))
  }
  if (is.null(family)) {
    family <- switch(
      role,
      title = getOption("ekioplot.font_title"),
      body = getOption("ekioplot.font_text"),
      NULL
    )
  }
  if (is.null(family)) {
    family <- if (is.null(fallback)) .font_defaults[[role]] else fallback
  }
  if (
    !is.character(family) ||
      length(family) != 1L ||
      is.na(family) ||
      !nzchar(trimws(family))
  ) {
    cli::cli_abort(
      "{.arg {paste0('font_', role)}} must be a single non-empty family name.",
      call = call
    )
  }
  if (family %in% names(.ekio_font_stacks)) {
    family <- .ekio_font_stacks[[family]]
  }
  return(unname(family))
}

# Hokusai palettes ----------------------------------------------------------

# Shared neutral scale for structural elements, independent of print colors.
.hokusai_grays <- c(
  gray_50 = "#FAFAFA",
  gray_100 = "#F5F5F5",
  gray_200 = "#E5E5E5",
  gray_300 = "#D4D4D4",
  gray_400 = "#A3A3A3",
  gray_500 = "#737373",
  gray_600 = "#525252",
  gray_700 = "#404040",
  gray_800 = "#262626",
  gray_900 = "#171717"
)

# Representative RGB colors extracted from the four supplied reproductions
# (cropped 4% at each edge, reduced to 400 px, median-cut quantized to 10 colors).
# Ink, blue, mist, and paper are extracted colors. White is a neutral canvas;
# wash is an explicit 25% paper-on-white tint. Each palette includes the
# shared gray scale for rules, zebra stripes, and other neutral elements.
# These describe the supplied digital images, not original print pigments.
.hokusai_palettes <- list(
  # Inume Pass in Kai Province
  mountain = c(
    ink = "#204D6D",
    blue = "#204D6D",
    mist = "#ACC1C2",
    paper = "#EFEADE",
    canvas = "#FFFFFF",
    wash = "#FBFAF7",
    .hokusai_grays
  ),
  # Ejiri in Suruga Province
  wind = c(
    ink = "#3F5C6C",
    blue = "#3F5C6C",
    mist = "#919E9F",
    paper = "#DDD5C4",
    canvas = "#FFFFFF",
    wash = "#F6F4F0",
    .hokusai_grays
  ),
  # Bullfinch and Weeping Cherry (Uso, shidarezakura)
  blossom = c(
    ink = "#2C4254",
    blue = "#2A5471",
    mist = "#8F8D7A",
    paper = "#D3C8A9",
    canvas = "#FFFFFF",
    wash = "#F4F1EA",
    .hokusai_grays
  ),
  # Lake Suwa in Shinano Province
  lake = c(
    ink = "#3D5369",
    blue = "#416880",
    mist = "#9DA99E",
    paper = "#FCE8C6",
    canvas = "#FFFFFF",
    wash = "#FEF9F1",
    .hokusai_grays
  )
)
