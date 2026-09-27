# GT table theme ------------------------------------------------------------

#' Apply the EKIO Theme to GT Tables
#'
#' EKIO styling for gt table objects. It uses a blue column-label band, blue
#' rules above unfilled group headings, and tabular figures for body numerals.
#' The table sits on the same warm offwhite surface as [ekioplot::theme_ekio()],
#' so a chart and a table in one document share a background. No footer is
#' added.
#'
#' @param data A gt table object.
#' @param table_width Character. Width of the table (default: `"100%"`).
#' @param font_size Numeric. Base font size in pixels (default: 14).
#' @param stripe Logical. Apply alternating row striping (default: `TRUE`).
#' @param font_title,font_body,font_numeric,font_labels A font family or registry
#'   key (`lora`, `lato`, `georgia`, `roboto_slab`, `fira_code`, `host_grotesk`).
#'   `NULL` uses the corresponding `ekiotable.font_<role>` option. Title and body
#'   then use `ekioplot.font_title` and `ekioplot.font_text`, respectively, before
#'   falling back to Lora and Lato. Numeric and label fonts inherit the resolved
#'   body font unless explicitly set or configured through their role option.
#'   Fonts must be available to the renderer; this function does not install them.
#' @param background Character. Table surface, using the same vocabulary as
#'   [ekioplot::theme_ekio()]: `"offwhite"` (default, `#FBFBF6`, a warm white),
#'   `"white"`, `"cold"` (`#F6F7F8`, a cool white), or `"transparent"` to let
#'   the page show through. A hex code is also accepted, though only the named
#'   surfaces are checked for contrast against the brand scales.
#'
#' @return A styled gt table object.
#' @export
#'
#' @examples
#' library(gt)
#' head(mtcars, 10) |>
#'   gt() |>
#'   gt_theme_ekio()

# Four rungs of one blue carry four jobs, light to dark: 600 is the editorial
# voice, ruling off the heading and the row groups; 700 is structure, the
# column label slab and the emphasis on summary values; 800 is the grand
# summary slab; 900 is the title. Sourcing all four from the generated scale
# keeps the identity palette for identity work.
gt_theme_ekio <- function(
  data,
  table_width = "100%",
  font_size = 14,
  stripe = TRUE,
  font_title = NULL,
  font_body = NULL,
  font_numeric = NULL,
  font_labels = NULL,
  background = "offwhite"
) {
  if (!inherits(data, "gt_tbl")) {
    cli::cli_abort("{.arg data} must be a gt table object")
  }

  .validate_gt_theme_args(table_width, font_size, stripe)
  surface <- .resolve_surface(background)
  font_title <- .ekio_font("title", font_title)
  font_body <- .ekio_font("body", font_body)
  font_numeric <- .ekio_font("numeric", font_numeric, fallback = font_body)
  font_labels <- .ekio_font("labels", font_labels, fallback = font_body)

  colors <- list(
    title = .ekio("blue", 900),
    editorial = .ekio("blue", 600),
    structure = .ekio("blue", 700),
    structure_dark = .ekio("blue", 800),
    # The lightest rung of the same scale. It clears the surface and the
    # stripe by roughly dE2000 8, where the warm cream it replaced cleared
    # both by 4.
    structure_light = .ekio("blue", 100),
    text = .ekio("gray", 900),
    text_mid = .ekio("gray", 700),
    text_light = .ekio("gray", 600),
    border = .ekio("stone", 300),
    # One stripe for every surface. The warm stone reads slightly warm on the
    # cold surface, but the cool alternative, gray 100, lands within dE2000 1
    # of it and the striping disappears.
    stripe_bg = .ekio("stone", 100)
  )

  label_style <- list(
    gt::cell_text(
      color = ekioplot::ekio_text_on(colors$structure),
      weight = "600",
      font = font_labels
    ),
    gt::cell_fill(color = colors$structure),
    .header_seam_css(colors$structure)
  )

  styled_table <- data |>
    gt::opt_table_font(font = font_body) |>
    gt::tab_options(
      table.width = table_width,
      table.font.size = gt::px(font_size),
      table.font.color = colors$text,
      table.background.color = surface,

      heading.background.color = surface,
      heading.title.font.size = gt::px(font_size + 6),
      heading.title.font.weight = "600",
      heading.subtitle.font.size = gt::px(font_size),
      heading.border.bottom.style = "solid",
      heading.border.bottom.width = gt::px(3),
      heading.border.bottom.color = colors$editorial,

      column_labels.background.color = colors$structure,
      column_labels.font.size = gt::px(font_size - 1),
      column_labels.font.weight = "600",
      column_labels.padding = gt::px(10),
      column_labels.border.top.style = "none",
      column_labels.border.bottom.style = "solid",
      column_labels.border.bottom.width = gt::px(2),
      column_labels.border.bottom.color = colors$border,

      # A rule above and no fill. The group heading reads as a heading
      # because of its weight and color, not because of a band.
      row_group.font.weight = "700",
      row_group.padding = gt::px(10),
      row_group.border.top.style = "solid",
      row_group.border.top.width = gt::px(2),
      row_group.border.top.color = colors$editorial,
      row_group.border.bottom.style = "none",

      stub.font.weight = "600",

      data_row.padding = gt::px(8),
      row.striping.include_table_body = stripe,
      row.striping.background_color = colors$stripe_bg,

      summary_row.background.color = colors$structure_light,
      summary_row.padding = gt::px(8),
      summary_row.border.style = "none",

      grand_summary_row.background.color = colors$structure_dark,
      grand_summary_row.padding = gt::px(8),
      grand_summary_row.border.style = "solid",
      grand_summary_row.border.width = gt::px(2),
      grand_summary_row.border.color = colors$structure,

      table.border.top.style = "solid",
      table.border.top.width = gt::px(2),
      table.border.top.color = colors$editorial,
      table.border.bottom.style = "solid",
      table.border.bottom.width = gt::px(3),
      table.border.bottom.color = colors$editorial,
      table.border.left.style = "none",
      table.border.right.style = "none",

      source_notes.font.size = gt::px(font_size - 3),
      source_notes.border.lr.style = "none",
      source_notes.padding = gt::px(10),
      source_notes.background.color = surface,

      footnotes.font.size = gt::px(font_size - 3),
      footnotes.padding = gt::px(8),
      footnotes.background.color = surface
    ) |>
    gt::tab_style(
      style = label_style,
      locations = list(gt::cells_column_labels(), gt::cells_stubhead())
    ) |>
    gt::tab_style(
      style = list(
        gt::cell_text(
          color = ekioplot::ekio_text_on(colors$structure),
          weight = "700",
          font = font_labels
        ),
        gt::cell_fill(color = colors$structure),
        .header_seam_css(colors$structure)
      ),
      locations = gt::cells_column_spanners()
    ) |>
    gt::tab_style(
      style = gt::cell_borders(
        sides = "bottom",
        color = colors$border,
        weight = gt::px(1)
      ),
      locations = gt::cells_body()
    ) |>
    gt::tab_style(
      style = gt::cell_text(
        font = font_title,
        color = colors$title,
        weight = "600",
        align = "left"
      ),
      locations = gt::cells_title(groups = "title")
    ) |>
    gt::tab_style(
      style = gt::cell_text(
        font = font_body,
        color = colors$text_light,
        weight = "normal",
        size = gt::px(font_size),
        align = "left"
      ),
      locations = gt::cells_title(groups = "subtitle")
    ) |>
    # No stub fill. A mid-tone keeps the row label below the group heading
    # and above nothing, which is the level it occupies. gt centers a factor
    # stub, so the alignment is set explicitly.
    gt::tab_style(
      style = gt::cell_text(
        color = colors$text_mid,
        weight = "600",
        align = "left"
      ),
      locations = gt::cells_stub()
    ) |>
    gt::tab_style(
      style = gt::cell_text(font = font_numeric),
      locations = gt::cells_body(columns = tidyselect::where(is.numeric))
    ) |>
    # Body text color, so a group heading does not read as a summary. The
    # blue rule above it carries the accent.
    gt::tab_style(
      style = gt::cell_text(color = colors$text, weight = "700"),
      locations = gt::cells_row_groups()
    ) |>
    gt::tab_style(
      style = gt::cell_text(color = colors$text_light),
      locations = gt::cells_source_notes()
    ) |>
    gt::tab_style(
      style = gt::cell_text(color = colors$text_light),
      locations = gt::cells_footnotes()
    ) |>
    # A cell-level style, not opt_css(): gt copies opt_css() rules verbatim
    # into the <style> block, where an unscoped selector reaches every gt
    # table on the page.
    gt::tab_style(
      style = .figure_css,
      locations = list(gt::cells_body(), gt::cells_stub())
    )

  # gt keeps one raw CSS string per cell, so the indent restates the figure
  # style it would otherwise replace.
  if (.has_row_groups(data)) {
    styled_table <- gt::tab_style(
      styled_table,
      style = paste(.figure_css, .stub_indent_css),
      locations = gt::cells_stub()
    )
  }

  # Style only groups that define summaries. Checking `_summary` keeps a
  # missing summary from discarding styles for groups that have them, without
  # swallowing unrelated errors.
  # TRUE avoids gt 1.3.0's everything() resolution error for summary rows.
  summary_style <- list(
    gt::cell_text(color = colors$structure, weight = "700"),
    .figure_css
  )
  for (group in .summary_groups(data)) {
    styled_table <- gt::tab_style(
      styled_table,
      style = summary_style,
      locations = gt::cells_summary(groups = group, rows = TRUE)
    )
    # The stub label of a summary row is a separate location. Without this
    # the label stays body-colored while its own value is emphasized.
    styled_table <- gt::tab_style(
      styled_table,
      style = summary_style,
      locations = gt::cells_stub_summary(groups = group, rows = TRUE)
    )
  }

  grand_style <- list(
    gt::cell_text(
      color = ekioplot::ekio_text_on(colors$structure_dark),
      weight = "700"
    ),
    .figure_css
  )
  if (.has_grand_summary(data)) {
    styled_table <- gt::tab_style(
      styled_table,
      style = grand_style,
      locations = gt::cells_grand_summary(rows = TRUE)
    )
    styled_table <- gt::tab_style(
      styled_table,
      style = grand_style,
      locations = gt::cells_stub_grand_summary(rows = TRUE)
    )
  }

  return(styled_table)
}

# Argument validation -------------------------------------------------------

.validate_gt_theme_args <- function(
  table_width,
  font_size,
  stripe,
  call = parent.frame()
) {
  if (
    !is.character(table_width) ||
      length(table_width) != 1L ||
      is.na(table_width) ||
      !nzchar(trimws(table_width))
  ) {
    cli::cli_abort(
      "{.arg table_width} must be a single non-empty string.",
      call = call
    )
  }
  if (
    !is.numeric(font_size) ||
      length(font_size) != 1L ||
      !is.finite(font_size) ||
      font_size <= 0
  ) {
    cli::cli_abort(
      "{.arg font_size} must be a single positive finite number.",
      call = call
    )
  }
  if (!is.logical(stripe) || length(stripe) != 1L || is.na(stripe)) {
    cli::cli_abort("{.arg stripe} must be TRUE or FALSE.", call = call)
  }
  invisible(NULL)
}
