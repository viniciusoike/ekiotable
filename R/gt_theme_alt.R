# Alternative GT table theme -----------------------------------------------

# Two blues carry two jobs. Baltic Blue is the editorial voice: title and
# row group headings. Blue 700 is structure: the column label slab and the
# emphasis on summary values.
gt_theme_ekio_alt <- function(
  data,
  table_width = "100%",
  font_size = 14,
  stripe = TRUE,
  font_title = NULL,
  font_body = NULL,
  font_numeric = NULL,
  font_labels = NULL
) {
  if (!inherits(data, "gt_tbl")) {
    cli::cli_abort("{.arg data} must be a gt table object")
  }

  .validate_gt_theme_args(table_width, font_size, stripe, add_footer = FALSE)
  font_title <- .ekio_font("title", font_title)
  font_body <- .ekio_font("body", font_body)
  font_numeric <- .ekio_font("numeric", font_numeric, fallback = font_body)
  font_labels <- .ekio_font("labels", font_labels, fallback = font_body)

  colors <- list(
    title = .ekio("blue", 900),
    editorial = .ekio("ekio_brand", "Baltic Blue"),
    structure = .ekio("blue", 700),
    structure_dark = .ekio("blue", 800),
    structure_light = .ekio("ekio_brand", "Soft Linen 2"),
    text = .ekio("gray", 900),
    text_mid = .ekio("gray", 700),
    text_light = .ekio("gray", 600),
    border = .ekio("stone", 300),
    stripe_bg = .ekio("stone", 100),
    note_bg = .ekio("ekio_brand", "Soft Linen 2")
  )

  styled_table <- data |>
    gt::opt_table_font(font = font_body) |>
    gt::tab_options(
      table.width = table_width,
      table.font.size = gt::px(font_size),
      table.font.color = colors$text,

      heading.background.color = .ekio("basic", "white"),
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
      # source_notes.background.color = colors$note_bg,

      footnotes.font.size = gt::px(font_size - 3),
      footnotes.padding = gt::px(8)
      # footnotes.background.color = colors$note_bg
    ) |>
    gt::tab_style(
      style = list(
        gt::cell_text(
          color = ekioplot::ekio_text_on(colors$structure),
          weight = "600",
          font = font_labels
        ),
        gt::cell_fill(color = colors$structure)
      ),
      locations = gt::cells_column_labels()
    ) |>
    gt::tab_style(
      style = list(
        gt::cell_text(
          color = ekioplot::ekio_text_on(colors$structure),
          weight = "700",
          font = font_labels
        ),
        gt::cell_fill(color = colors$structure)
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
    # and above nothing, which is the level it occupies.
    gt::tab_style(
      style = gt::cell_text(color = colors$text_mid, weight = "600"),
      locations = gt::cells_stub()
    ) |>
    gt::tab_style(
      style = gt::cell_text(font = font_numeric),
      locations = gt::cells_body(columns = tidyselect::where(is.numeric))
    ) |>
    gt::tab_style(
      style = gt::cell_text(color = colors$editorial, weight = "700"),
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
    # gt inlines this into each matching element rather than emitting a
    # document-level rule, so it cannot reach another table on the page.
    gt::opt_css(
      css = ".gt_row { font-variant-numeric: tabular-nums lining-nums; }",
      add = TRUE
    )

  # gt errors on missing summaries. Apply each group separately so a group
  # without summaries cannot discard styles for groups that have them.
  # TRUE avoids gt 1.3.0's everything() resolution error for summary rows.
  summary_style <- gt::cell_text(color = colors$structure, weight = "700")
  for (group in unique(data[["_stub_df"]]$group_id)) {
    styled_table <- tryCatch(
      gt::tab_style(
        styled_table,
        style = summary_style,
        locations = gt::cells_summary(groups = group, rows = TRUE)
      ),
      error = function(e) styled_table
    )
    # The stub label of a summary row is a separate location. Without this
    # the label stays body-colored while its own value is emphasized.
    styled_table <- tryCatch(
      gt::tab_style(
        styled_table,
        style = summary_style,
        locations = gt::cells_stub_summary(groups = group, rows = TRUE)
      ),
      error = function(e) styled_table
    )
  }

  grand_style <- gt::cell_text(
    color = ekioplot::ekio_text_on(colors$structure_dark),
    weight = "700"
  )
  for (location in list(
    gt::cells_grand_summary(rows = TRUE),
    gt::cells_stub_grand_summary(rows = TRUE)
  )) {
    styled_table <- tryCatch(
      gt::tab_style(styled_table, style = grand_style, locations = location),
      error = function(e) styled_table
    )
  }

  return(styled_table)
}
