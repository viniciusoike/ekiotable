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
  labels = "Lato"
)

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
