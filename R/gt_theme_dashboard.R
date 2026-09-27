# Dashboard GT table theme ---------------------------------------------------

#' Apply a Dense Dashboard Theme to GT Tables
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' A tight theme for tables in dashboards and other dense screens. Rows are
#' separated by thin gray rules instead of stripes, column labels are plain
#' semibold text over a blue rule, and numeric cells use a monospace font with
#' tabular figures. Stub, group, and summary styling follow
#' [gt_theme_hokusai()], and so do the palettes.
#'
#' @inheritParams gt_theme_hokusai
#' @param density One of `"compact"` (default) or `"dense"`. Compact uses 4px
#'   row padding and a 13px base size; dense uses 2px and 12px.
#' @param font_size Numeric. Body font size in pixels. `NULL` (default) uses
#'   the size set by `density`. Column labels match the body; the title is 4px
#'   larger and notes 1px smaller.
#' @param font_title,font_body,font_labels A font family or registry key.
#'   `NULL` resolves as in [gt_theme_ekio()].
#' @param font_numeric A font family or registry key for numeric body cells and
#'   summary values. `NULL` uses the `ekiotable.font_numeric` option and then
#'   IBM Plex Mono. The font must be available to the renderer; this function
#'   does not load it.
#' @details
#' Apply the theme before any cell-specific highlighting. Other font arguments
#' and options follow [gt_theme_ekio()]. Dashboards usually need less than the
#' full width; set `table_width` or use [gt::cols_width()] when a narrow table
#' leaves a gap after the stub.
#' @return A styled gt table object.
#' @export
#' @examples
#' head(mtcars) |>
#'   gt::gt() |>
#'   gt_theme_ekio_dashboard()
#'
#' head(mtcars) |>
#'   gt::gt(rownames_to_stub = TRUE) |>
#'   gt_theme_ekio_dashboard(density = "dense", palette = "lake")
gt_theme_ekio_dashboard <- function(
  data,
  density = c("compact", "dense"),
  palette = c("mountain", "wind", "blossom", "lake"),
  table_width = "100%",
  font_size = NULL,
  font_title = NULL,
  font_body = NULL,
  font_numeric = NULL,
  font_labels = NULL,
  font_stub = NULL
) {
  lifecycle::signal_stage("experimental", "gt_theme_ekio_dashboard()")

  if (!inherits(data, "gt_tbl")) {
    cli::cli_abort("{.arg data} must be a gt table object")
  }

  density <- match.arg(density)
  padding <- switch(density, compact = 4, dense = 2)
  if (is.null(font_size)) {
    font_size <- switch(density, compact = 13, dense = 12)
  }
  .validate_gt_theme_args(table_width, font_size, stripe = FALSE)

  font_title <- .ekio_font("title", font_title)
  font_body <- .ekio_font("body", font_body)
  font_numeric <- .ekio_font(
    "numeric",
    font_numeric,
    fallback = .ekio_font_stacks[["ibm_plex_mono"]]
  )
  font_labels <- .ekio_font_semibold(
    .ekio_font("labels", font_labels, fallback = font_body)
  )
  font_stub <- .ekio_font_semibold(
    .ekio_font("stub", font_stub, fallback = font_body)
  )

  stack_title <- .ekio_font_stack(font_title)
  stack_body <- .ekio_font_stack(font_body)
  stack_numeric <- .ekio_font_stack(font_numeric)
  stack_labels <- .ekio_font_stack(font_labels)
  stack_stub <- .ekio_font_stack(font_stub)

  size_title <- font_size + 4
  size_notes <- font_size - 1

  palette <- match.arg(palette)
  pal <- as.list(.hokusai_palettes[[palette]])
  colors <- list(
    title = pal$ink,
    editorial = pal$blue,
    text = pal$gray_800,
    text_mid = pal$gray_700,
    text_light = pal$gray_600,
    border = pal$gray_300,
    rule = pal$gray_200
  )

  styled_table <- data |>
    gt::opt_table_font(font = font_body) |>
    gt::tab_options(
      table.width = table_width,
      table.font.size = gt::px(font_size),
      table.font.color = colors$text,
      table.background.color = pal$canvas,
      table_body.hlines.style = "solid",
      table_body.hlines.width = gt::px(1),
      table_body.hlines.color = colors$rule,
      table_body.vlines.style = "none",
      stub.border.style = "none",
      column_labels.vlines.style = "none",
      table_body.border.top.style = "none",
      table_body.border.bottom.style = "none",

      heading.background.color = pal$canvas,
      heading.title.font.size = gt::px(size_title),
      heading.title.font.weight = "600",
      heading.subtitle.font.size = gt::px(font_size),
      heading.padding = gt::px(padding),
      heading.border.bottom.style = "none",

      # No band. The blue rule under the labels is the only header accent.
      column_labels.background.color = pal$canvas,
      column_labels.font.size = gt::px(font_size),
      column_labels.font.weight = "600",
      column_labels.padding = gt::px(padding + 2),
      column_labels.border.top.style = "none",
      column_labels.border.bottom.style = "solid",
      column_labels.border.bottom.width = gt::px(2),
      column_labels.border.bottom.color = colors$editorial,

      row_group.font.weight = "700",
      row_group.padding = gt::px(padding + 2),
      row_group.border.top.style = "solid",
      row_group.border.top.width = gt::px(1),
      row_group.border.top.color = colors$editorial,
      row_group.border.bottom.style = "none",

      stub.font.weight = "600",

      data_row.padding = gt::px(padding),
      row.striping.include_table_body = FALSE,
      row.striping.include_stub = FALSE,

      summary_row.background.color = pal$canvas,
      summary_row.padding = gt::px(padding),
      summary_row.border.style = "solid",
      summary_row.border.width = gt::px(1),
      summary_row.border.color = colors$border,

      grand_summary_row.background.color = pal$canvas,
      grand_summary_row.padding = gt::px(padding),
      grand_summary_row.border.style = "double",
      grand_summary_row.border.width = gt::px(3),
      grand_summary_row.border.color = colors$editorial,

      table.border.top.style = "none",
      table.border.bottom.style = "solid",
      table.border.bottom.width = gt::px(1),
      table.border.bottom.color = colors$border,
      table.border.left.style = "none",
      table.border.right.style = "none",

      source_notes.font.size = gt::px(size_notes),
      source_notes.border.lr.style = "none",
      source_notes.padding = gt::px(padding),
      source_notes.background.color = pal$canvas,

      footnotes.font.size = gt::px(size_notes),
      footnotes.padding = gt::px(padding),
      footnotes.background.color = pal$canvas
    ) |>
    gt::tab_style(
      style = gt::cell_text(
        color = colors$text,
        weight = "600",
        font = stack_labels
      ),
      locations = list(
        gt::cells_column_labels(),
        gt::cells_column_spanners(),
        gt::cells_stubhead()
      )
    ) |>
    gt::tab_style(
      style = gt::cell_text(
        font = stack_title,
        color = colors$title,
        weight = "600",
        align = "left"
      ),
      locations = gt::cells_title(groups = "title")
    ) |>
    gt::tab_style(
      style = gt::cell_text(
        font = stack_body,
        color = colors$text_light,
        weight = "normal",
        size = gt::px(font_size),
        align = "left"
      ),
      locations = gt::cells_title(groups = "subtitle")
    ) |>
    gt::tab_style(
      style = gt::cell_text(
        color = colors$text_mid,
        weight = "600",
        font = stack_stub,
        align = "left"
      ),
      locations = gt::cells_stub()
    ) |>
    gt::tab_style(
      style = gt::cell_text(font = stack_numeric),
      locations = gt::cells_body(columns = tidyselect::where(is.numeric))
    ) |>
    gt::tab_style(
      style = gt::cell_text(color = colors$text, weight = "700"),
      locations = gt::cells_row_groups()
    ) |>
    gt::tab_style(
      style = gt::cell_text(color = colors$text_light),
      locations = list(gt::cells_source_notes(), gt::cells_footnotes())
    ) |>
    gt::tab_style(
      style = .figure_css,
      locations = list(gt::cells_body(), gt::cells_stub())
    )

  styled_table <- .hokusai_structure(
    styled_table,
    data,
    summary_color = colors$editorial,
    grand_color = colors$title,
    rule_color = colors$editorial,
    font = stack_numeric
  )

  return(styled_table)
}
