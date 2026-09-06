# gt_theme_ekio() returns a gt table and rejects other input

    Code
      gt_theme_ekio(mtcars)
    Condition
      Error in `gt_theme_ekio()`:
      ! `data` must be a gt table object

# gt_theme_ekio() validates its arguments

    Code
      gt_theme_ekio(small_tbl(), font_size = "14")
    Condition
      Error in `gt_theme_ekio()`:
      ! `font_size` must be a single positive finite number.

---

    Code
      gt_theme_ekio(small_tbl(), font_size = c(12, 14))
    Condition
      Error in `gt_theme_ekio()`:
      ! `font_size` must be a single positive finite number.

---

    Code
      gt_theme_ekio(small_tbl(), font_size = -1)
    Condition
      Error in `gt_theme_ekio()`:
      ! `font_size` must be a single positive finite number.

---

    Code
      gt_theme_ekio(small_tbl(), table_width = 100)
    Condition
      Error in `gt_theme_ekio()`:
      ! `table_width` must be a single non-empty string.

---

    Code
      gt_theme_ekio(small_tbl(), stripe = "yes")
    Condition
      Error in `gt_theme_ekio()`:
      ! `stripe` must be TRUE or FALSE.

---

    Code
      gt_theme_ekio(small_tbl(), add_footer = NA)
    Condition
      Error in `gt_theme_ekio()`:
      ! `add_footer` must be TRUE or FALSE.

---

    Code
      gt_theme_ekio(small_tbl(), font_title = 1)
    Condition
      Error in `gt_theme_ekio()`:
      ! `font_title` must be a single non-empty family name.

# the resolved theme options are stable

    Code
      print(as.data.frame(themed[, c("parameter", "value")]))
    Output
                                     parameter
      1                   table_additional_css
      2                            table_width
      3                 table_background_color
      4                        table_font_size
      5                      table_font_weight
      6                       table_font_color
      7                 table_border_top_style
      8                 table_border_top_width
      9                 table_border_top_color
      10              table_border_right_style
      11             table_border_bottom_style
      12             table_border_bottom_width
      13             table_border_bottom_color
      14               table_border_left_style
      15              heading_background_color
      16               heading_title_font_size
      17             heading_title_font_weight
      18            heading_subtitle_font_size
      19          heading_subtitle_font_weight
      20                       heading_padding
      21           heading_border_bottom_style
      22           heading_border_bottom_width
      23           heading_border_bottom_color
      24        column_labels_background_color
      25               column_labels_font_size
      26             column_labels_font_weight
      27                 column_labels_padding
      28        column_labels_border_top_style
      29     column_labels_border_bottom_style
      30     column_labels_border_bottom_width
      31     column_labels_border_bottom_color
      32            row_group_background_color
      33                 row_group_font_weight
      34                     row_group_padding
      35            row_group_border_top_style
      36            row_group_border_top_width
      37            row_group_border_top_color
      38         row_group_border_bottom_style
      39         row_group_border_bottom_width
      40         row_group_border_bottom_color
      41                 stub_background_color
      42                      stub_font_weight
      43                     stub_border_style
      44                     stub_border_width
      45                     stub_border_color
      46                      data_row_padding
      47          summary_row_background_color
      48                   summary_row_padding
      49              summary_row_border_style
      50              summary_row_border_width
      51              summary_row_border_color
      52    grand_summary_row_background_color
      53             grand_summary_row_padding
      54        grand_summary_row_border_style
      55        grand_summary_row_border_width
      56        grand_summary_row_border_color
      57            footnotes_background_color
      58                   footnotes_font_size
      59                     footnotes_padding
      60         source_notes_background_color
      61                source_notes_font_size
      62                  source_notes_padding
      63          source_notes_border_lr_style
      64         row_striping_background_color
      65       row_striping_include_table_body
      66                      table_font_names
      69                          table_layout
      70                     table_margin_left
      71                    table_margin_right
      72                      table_font_style
      73                table_font_color_light
      74              table_border_top_include
      75              table_border_right_width
      76              table_border_right_color
      77           table_border_bottom_include
      78               table_border_left_width
      79               table_border_left_color
      80                         heading_align
      81            heading_padding_horizontal
      82               heading_border_lr_style
      83               heading_border_lr_width
      84               heading_border_lr_color
      85          column_labels_text_transform
      86      column_labels_padding_horizontal
      90        column_labels_border_top_width
      91        column_labels_border_top_color
      92         column_labels_border_lr_style
      93         column_labels_border_lr_width
      94         column_labels_border_lr_color
      95                  column_labels_hidden
      96           column_labels_units_pattern
      97                   row_group_font_size
      98              row_group_text_transform
      99          row_group_padding_horizontal
      100         row_group_border_right_style
      101         row_group_border_right_width
      102         row_group_border_right_color
      103          row_group_border_left_style
      104          row_group_border_left_width
      105          row_group_border_left_color
      107                  row_group_as_column
      120          data_row_padding_horizontal
      121                       stub_font_size
      122                  stub_text_transform
      123                   stub_indent_length
      125             stub_row_group_font_size
      126           stub_row_group_font_weight
      127        stub_row_group_text_transform
      128          stub_row_group_border_style
      129          stub_row_group_border_width
      130          stub_row_group_border_color
      131       summary_row_padding_horizontal
      132           summary_row_text_transform
      133 grand_summary_row_padding_horizontal
      134     grand_summary_row_text_transform
      135         footnotes_padding_horizontal
      136                     footnotes_margin
      137        footnotes_border_bottom_style
      138        footnotes_border_bottom_width
      139        footnotes_border_bottom_color
      140            footnotes_border_lr_style
      141            footnotes_border_lr_width
      142            footnotes_border_lr_color
      143                      footnotes_marks
      144                   footnotes_spec_ref
      145                   footnotes_spec_ftr
      146                  footnotes_multiline
      147                        footnotes_sep
      148                      footnotes_order
      149      source_notes_padding_horizontal
      150     source_notes_border_bottom_style
      151     source_notes_border_bottom_width
      152     source_notes_border_bottom_color
      153         source_notes_border_lr_width
      154         source_notes_border_lr_color
      155               source_notes_multiline
      156                     source_notes_sep
      157            row_striping_include_stub
      158                      container_width
      159                     container_height
      160                  container_padding_x
      161                  container_padding_y
      162                 container_overflow_x
      163                 container_overflow_y
      164                         ihtml_active
      165                         ihtml_height
      166                 ihtml_use_pagination
      167            ihtml_use_pagination_info
      168                    ihtml_use_sorting
      169                     ihtml_use_search
      170                    ihtml_use_filters
      171                   ihtml_use_resizers
      172                  ihtml_use_highlight
      173               ihtml_use_compact_mode
      174              ihtml_use_text_wrapping
      175           ihtml_use_page_size_select
      176              ihtml_page_size_default
      177               ihtml_page_size_values
      178                ihtml_pagination_type
      180                     page_orientation
      181                       page_numbering
      182         page_header_use_tbl_headings
      183            page_footer_use_tbl_notes
      184                           page_width
      185                          page_height
      186                     page_margin_left
      187                    page_margin_right
      188                      page_margin_top
      189                   page_margin_bottom
      190                   page_header_height
      191                   page_footer_height
      192            quarto_disable_processing
      193                 quarto_use_bootstrap
      194                  latex_use_longtable
      195                  latex_header_repeat
      196                        stub_separate
      197                        latex_toprule
      198                     latex_bottomrule
      199                        latex_tbl_pos
      200             latex_unicode_conversion
                                                                                                                                          value
      1                                                                                                                                  , , , 
      2                                                                                                                                    100%
      3                                                                                                                                 #F2F3F5
      4                                                                                                                                    14px
      5                                                                                                                                  normal
      6                                                                                                                                 #191A1C
      7                                                                                                                                   solid
      8                                                                                                                                     2px
      9                                                                                                                                 #1E3A5F
      10                                                                                                                                   none
      11                                                                                                                                  solid
      12                                                                                                                                    3px
      13                                                                                                                                #1E3A5F
      14                                                                                                                                   none
      15                                                                                                                                #FFFFFF
      16                                                                                                                                   20px
      17                                                                                                                                    600
      18                                                                                                                                   14px
      19                                                                                                                                 normal
      20                                                                                                                                    8px
      21                                                                                                                                  solid
      22                                                                                                                                    3px
      23                                                                                                                                #1E3A5F
      24                                                                                                                                #1E3A5F
      25                                                                                                                                   13px
      26                                                                                                                                    600
      27                                                                                                                                   10px
      28                                                                                                                                   none
      29                                                                                                                                  solid
      30                                                                                                                                    2px
      31                                                                                                                                #AEB1B5
      32                                                                                                                                #E8F6FF
      33                                                                                                                                    600
      34                                                                                                                                    6px
      35                                                                                                                                  solid
      36                                                                                                                                    1px
      37                                                                                                                                #AEB1B5
      38                                                                                                                                  solid
      39                                                                                                                                    1px
      40                                                                                                                                #AEB1B5
      41                                                                                                                                #CFD2D5
      42                                                                                                                                    600
      43                                                                                                                                  solid
      44                                                                                                                                    1px
      45                                                                                                                                #AEB1B5
      46                                                                                                                                    8px
      47                                                                                                                                #E8F6FF
      48                                                                                                                                    8px
      49                                                                                                                                  solid
      50                                                                                                                                    1px
      51                                                                                                                                #AEB1B5
      52                                                                                                                                #152A44
      53                                                                                                                                    8px
      54                                                                                                                                  solid
      55                                                                                                                                    2px
      56                                                                                                                                #1E3A5F
      57                                                                                                                                #F2F3F5
      58                                                                                                                                   11px
      59                                                                                                                                    8px
      60                                                                                                                                #F2F3F5
      61                                                                                                                                   11px
      62                                                                                                                                   10px
      63                                                                                                                                   none
      64                                                                                                                                #CFD2D5
      65                                                                                                                                   TRUE
      66  Lato, system-ui, Segoe UI, Roboto, Helvetica, Arial, sans-serif, Apple Color Emoji, Segoe UI Emoji, Segoe UI Symbol, Noto Color Emoji
      69                                                                                                                                  fixed
      70                                                                                                                                   auto
      71                                                                                                                                   auto
      72                                                                                                                                 normal
      73                                                                                                                                #FFFFFF
      74                                                                                                                                   TRUE
      75                                                                                                                                    2px
      76                                                                                                                                #D3D3D3
      77                                                                                                                                   TRUE
      78                                                                                                                                    2px
      79                                                                                                                                #D3D3D3
      80                                                                                                                                 center
      81                                                                                                                                    5px
      82                                                                                                                                   none
      83                                                                                                                                    1px
      84                                                                                                                                #D3D3D3
      85                                                                                                                                inherit
      86                                                                                                                                    5px
      90                                                                                                                                    2px
      91                                                                                                                                #D3D3D3
      92                                                                                                                                   none
      93                                                                                                                                    1px
      94                                                                                                                                #D3D3D3
      95                                                                                                                                  FALSE
      96                                                                                                                               {1}, {2}
      97                                                                                                                                   100%
      98                                                                                                                                inherit
      99                                                                                                                                    5px
      100                                                                                                                                  none
      101                                                                                                                                   1px
      102                                                                                                                               #D3D3D3
      103                                                                                                                                  none
      104                                                                                                                                   1px
      105                                                                                                                               #D3D3D3
      107                                                                                                                                 FALSE
      120                                                                                                                                   5px
      121                                                                                                                                  100%
      122                                                                                                                               inherit
      123                                                                                                                                   5px
      125                                                                                                                                  100%
      126                                                                                                                               initial
      127                                                                                                                               inherit
      128                                                                                                                                 solid
      129                                                                                                                                   2px
      130                                                                                                                               #D3D3D3
      131                                                                                                                                   5px
      132                                                                                                                               inherit
      133                                                                                                                                   5px
      134                                                                                                                               inherit
      135                                                                                                                                   5px
      136                                                                                                                                   0px
      137                                                                                                                                  none
      138                                                                                                                                   2px
      139                                                                                                                               #D3D3D3
      140                                                                                                                                  none
      141                                                                                                                                   2px
      142                                                                                                                               #D3D3D3
      143                                                                                                                               numbers
      144                                                                                                                                    ^i
      145                                                                                                                                    ^i
      146                                                                                                                                  TRUE
      147                                                                                                                                      
      148                                                                                                                            marks_last
      149                                                                                                                                   5px
      150                                                                                                                                  none
      151                                                                                                                                   2px
      152                                                                                                                               #D3D3D3
      153                                                                                                                                   2px
      154                                                                                                                               #D3D3D3
      155                                                                                                                                  TRUE
      156                                                                                                                                      
      157                                                                                                                                 FALSE
      158                                                                                                                                  auto
      159                                                                                                                                  auto
      160                                                                                                                                   0px
      161                                                                                                                                  10px
      162                                                                                                                                  auto
      163                                                                                                                                  auto
      164                                                                                                                                 FALSE
      165                                                                                                                                  auto
      166                                                                                                                                  TRUE
      167                                                                                                                                  TRUE
      168                                                                                                                                  TRUE
      169                                                                                                                                 FALSE
      170                                                                                                                                 FALSE
      171                                                                                                                                 FALSE
      172                                                                                                                                 FALSE
      173                                                                                                                                 FALSE
      174                                                                                                                                  TRUE
      175                                                                                                                                 FALSE
      176                                                                                                                                    10
      177                                                                                                                       10, 25, 50, 100
      178                                                                                                                               numbers
      180                                                                                                                              portrait
      181                                                                                                                                 FALSE
      182                                                                                                                                 FALSE
      183                                                                                                                                 FALSE
      184                                                                                                                                 8.5in
      185                                                                                                                                11.0in
      186                                                                                                                                 1.0in
      187                                                                                                                                 1.0in
      188                                                                                                                                 1.0in
      189                                                                                                                                 1.0in
      190                                                                                                                                 0.5in
      191                                                                                                                                 0.5in
      192                                                                                                                                 FALSE
      193                                                                                                                                 FALSE
      194                                                                                                                                 FALSE
      195                                                                                                                                 FALSE
      196                                                                                                                                  TRUE
      197                                                                                                                                  TRUE
      198                                                                                                                                  TRUE
      199                                                                                                                                     t
      200                                                                                                                                 FALSE

# invalid scalar values produce actionable errors

    Code
      gt_theme_ekio(small_tbl(), font_size = Inf)
    Condition
      Error in `gt_theme_ekio()`:
      ! `font_size` must be a single positive finite number.

---

    Code
      gt_theme_ekio(small_tbl(), table_width = "")
    Condition
      Error in `gt_theme_ekio()`:
      ! `table_width` must be a single non-empty string.

---

    Code
      gt_theme_ekio(small_tbl(), font_body = NA_character_)
    Condition
      Error in `gt_theme_ekio()`:
      ! `font_body` must be a single non-empty family name.

---

    Code
      gt_theme_ekio(small_tbl(), font_labels = " ")
    Condition
      Error in `gt_theme_ekio()`:
      ! `font_labels` must be a single non-empty family name.

---

    Code
      gt_theme_ekio(small_tbl(), stripe = logical())
    Condition
      Error in `gt_theme_ekio()`:
      ! `stripe` must be TRUE or FALSE.

