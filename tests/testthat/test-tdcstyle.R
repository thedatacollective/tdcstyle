test_that("tdc styler works", {


# styler: off
string_to_format <-
"dt[
  is.na(remove_na1),
]"


string_to_format_2 <-
'donors[
  is.na(force_reason) & is.na(remove_dm1) & cashemerg_hag_amount >= 1000,
  let(force_include = "Y",
      force_reason = "01. High Mid Value Cash/Emerg",
      pack = "MV"
      )
  ]
'

string_to_format_3 <-
'donors[
  ,
  .N,
  .(group1, group2)
]
'

string_to_format_4 <-
'donors[
  is.na(force_reason) | (is.na(other_reason) & cashemerg_hag_amount >= 1000),
  let(force_include = "Y",
      force_reason = "01. High Mid Value Cash/Emerg",
      pack = "MV"
      )
  ]
'
# styler: on

  styler::cache_deactivate()
  transformers <- styler::tidyverse_style()

  transformers$line_break <- c(transformers$line_break, style_dt_line_break = style_dt_line_break)
  transformers$space <- c(transformers$space, style_dt_space = style_dt_space)
  transformers$token <- c(transformers$token, style_dt_token = style_dt_token)
  transformers$indention <- c(transformers$indention, style_dt_indentation = style_dt_indention)

  print(
    styler::style_text(string_to_format, transformers = transformers)
  )

  print(
    styler::style_text(string_to_format_2, transformers = transformers)
  )

  print(
    styler::style_text(string_to_format_3, transformers = transformers)
  )

  print(
    styler::style_text(string_to_format_4, transformers = transformers)
  )
})
