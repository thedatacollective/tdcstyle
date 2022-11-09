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

  print(
    styler::style_text(string_to_format, style = tdc_style)
  )

  print(
    styler::style_text(string_to_format_2, style = tdc_style)
  )

  print(
    styler::style_text(string_to_format_3, style = tdc_style)
  )

  print(
    styler::style_text(string_to_format_4, style = tdc_style)
  )
})
