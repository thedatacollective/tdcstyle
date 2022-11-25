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

string_to_format_5 <-
'
source("R/01_targeting.R")
library(ggplot2)

charity <- "UNSW"

trans <- read_latest("trans.fst", "../standard_refresh/data")
brief <- list.files("brief", pattern = "data_brief.*xlsx$", full.names = TRUE)
targeting <- read_excel(brief[length(brief)], "Targeting", skip = 6)
setDT(targeting)

# Set the force include to nothing for now
donors$force_include <- "N"

# Finalise targeting ----------------------------------------------------------
targeting_add_segment_removals(donors, targeting)

# Data fixes

# Create mailingbase
mailingbase <- donors[is.na(remove_dm1) | is.na(remove_edm)]

# Create seeds ------------------------------------------------------------
seeds <- read_excel(brief[length(brief)], "Seeds", skip = 3)
setDT(seeds)

seeds[
  ,
  `:=`(
    donor_type = "seed",
    demog_joint = "Single",
    cash_recency = "0-12",
    remove_sms = "Seed",
    remove_edm = fifelse(is.na(email), "Seed - No Email", NA_character_)
  )
]

mailingbase[, ask_base := NA_real_]
mailingbase[, `:=`(segment = NA_character_, group_code = NA_character_, pack = NA_character_, pack_description = NA_character_)]
mailingbase <- rbindlist(list(mailingbase, seeds), use.names = TRUE, fill = TRUE)


# Create asks
mailingbase[, c("ask_strategy", "ask_override") := NA_character_]
mailingbase[, c("ask_base", "ask1_number", "ask2_number", "ask3_number") := NA_real_]


mailingbase[
  is.na(ask_base) &
    cash_recency %in% c("0-12", "13-24"),
  let(
    ask_base = cash_last_amount,
    ask_strategy = "Last Cash 1/1.5/2"
  )
]

mailingbase[
  is.na(ask_base),
  let(
    ask_base = cash_last_amount,
    ask_strategy = "Last Cash 1/1.5/2"
  )
]

# apply multipliers
tmp_ask <- mailingbase[is.na(ask1_number), .(urn, ask_base)] %>%
  .[
    ask_conversion,
    on = .(ask_base >= from, ask_base <= to),
    `:=`(ask1 = x1, ask2 = x1.5, ask3 = x2)
  ]

mailingbase[
  tmp_ask,
  on = c("urn", "ask_base"),
  `:=`(
    ask1_number = i.ask1,
    ask2_number = i.ask2,
    ask3_number = i.ask3
  )
]

# default
mailingbase[
  is.na(ask_base),
  `:=`(
    ask_base = NA,
    ask1_number = 25,
    ask2_number = 40,
    ask3_number = 50,
    ask_strategy = "Default"
  )
]

# ask sanity check
gift_check <- trans[
  year > year(Sys.Date()) - 3 &
    classification_code %in% c(
      classification_code("Cash"),
      classification_code("Capital Campaign"),
      classification_code("Emergency")
    ),
  .(
    num_gift = .N,
    min_gift = min(amount),
    max_gift = max(amount),
    last_gift_3 = amount[.N - 3],
    last_gift_2 = amount[.N - 2],
    last_gift_1 = amount[.N - 1],
    last_gift = amount[.N],
    avg_gift = mean(amount)
  ),
  by = urn
]
gift_check[mailingbase, on = "urn", `:=`(ask_base = i.ask_base, ask1_ = i.ask1_number, ask_strategy = i.ask_strategy)]
gift_check[ask1_ >= avg_gift * 3 & ask1_ > 200] %>%
  copy_data()

new_asks <- setDT(read_excel(brief[length(brief)], "Ask Sanity", skip = 2))
new_asks[, urn := as.character(urn)]


mailingbase[
  new_asks,
  on = "urn",
  `:=`(
    ask_base = i.new_base,
    ask1_number = `i.ask1`,
    ask2_number = `i.ask2`,
    ask3_number = `i.ask3`,
    ask_override = "Ask Sanity"
  )
]

# format ask amounts
mailingbase[
  ,
  `:=`(
    ask1 = dollar(ask1_number),
    ask2 = dollar(ask2_number),
    ask3 = dollar(ask3_number)
  )
]

# set donors with ask amount >= $5000 to my choice
mailingbase[
  ask1_number >= 5000,
  `:=`(
    ask1 = NA,
    ask2 = NA,
    ask3 = NA,
    ask_override = "My Choice",
    ask_strategy = "My Choice"
  )
]

# Assign Segments --------------------------------


# Assign packs -----------------------------------------------------------
# Just the SV pack
mailingbase[
  ,
  let(
    pack = "SV"
  )
]

# Appeal codes ------------------------------------------------------------
appeal_code_prefix <- "XMAS2022-"
mailingbase[
  ,
  let(
    appeal_code_dm1 = paste0(appeal_code_prefix, "DM"),
    appeal_code_edm1 = paste0(appeal_code_prefix, "EDM01")
  )
]

# Create flag for variable paragraph ----------------------------------------

HV_donors <- trans[date > refresh_date %m-% months(24) & amount > 500, urn] %>% unique()

research_donors <- trans[]

trans$campaign_desc %>% unique()

mailingbase[
  is.na(remove_dm1),
  .N
]

mailingbase[
  is.na(remove_dm1) & urn %in% HV_donors,
  .N
]

mailingbase[
  ,
  let(
    flag_alumni_of_distinction = fifelse(
      !is.na(distiguished_constituent) & alumni == 1,
      1,
      0
    ),
    flag_high_value = fifelse(
      urn %in% HV_donors,
      1,
      0
    ),
  )
]


# Populate Variables -------------------------------------------------------
mailingbase[
  ,
  let(
    V01_ask1 = ask1
  )
]

tdcfun::add_personalisation(
  mailingbase,
  var_start = 10,
  suffixes = c(
    "w",
    "*,_",
    "t",
    "y"
  )
)

# Response Mech
add_rm_variables(mailingbase)

# Mark bequest box ---------------------------------------------------------
stop("here")
mailingbase[, RM_bequest_box := "Yes"] # Yes for tickbox
mailingbase[beq_confirmed == 1, RM_bequest_box := "No"]
mailingbase[donor_category == "Org", RM_bequest_box := "No"]
mailingbase[, .N, RM_bequest_box]
# TODO I dont think they have a bequest box remove?

# Apply client / QC exclusions ---------------------------------------------

# Bar Codes ----------------------------------------------------------------
calc_barcode <- function(urn, fundid, appealid) {
  tmp_num <- paste0(urn, fundid, appealid)
  check_digit <- lapply(strsplit(tmp_num, ""), function(x) {sum(as.numeric(x)) %% 10})

  paste0("A", sprintf("%07d", urn), sprintf("%05d", fundid), sprintf("%05d", appealid), check_digit)
}
fund_system_id <- 3971
appeal_system_id <- 818

donor_system_ids <-
  read_latest("Donor Information") %>%
  .[, .(urn, constituent_system_record_id)]

mailingbase[
  donor_system_ids,
  on = "urn",
  let(
    constituent_system_record_id = i.constituent_system_record_id
  )
]

# give seeds a dummy one
mailingbase[
  donor_type == "seed",
  let(
    constituent_system_record_id = 99999
  )
]

mailingbase[
  is.na(remove_dm1),
  let(
    barcode_number = calc_barcode(constituent_system_record_id, fund_system_id, appeal_system_id)
  )
]
# select a random donor to be mailed
sample_donor <- "9572475"

sample_record <- mailingbase[urn == sample_donor, ]
sample_record[
  ,
  let(
    scannable_barcode = paste0("*", barcode_number, "*")
  )
]

p <-
  ggplot() +
  geom_text(data = sample_record, aes(label = scannable_barcode, x = 1, y = 1), size = 10, family = "Librebarcode39") +
  theme_light() +
  theme(
    panel.grid = element_blank(),
    panel.grid.major = element_blank(),
    axis.line.x = element_blank(),
    axis.line.y = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank()
  )
ggsave("plot_sample.png", p, device = png, width = 15, height = 10, units = "cm")

# Identify Sample Records -------------------------------------------------

# Save mailingbase --------------------------------------------------------
write_fst(mailingbase, glue("data/mb_skeleton_{Sys.Date()}.fst"))

mailingbase[
  is.na(remove_edm),
  .N
]

mailingbase[
  is.na(remove_dm2),
  .N
]

# Write Mailfile

# Write out mail volumes for brief -------------------------------------------------
## DM1
mailingbase[is.na(remove_dm1), .N, keyby = segment_code] %>%
  copy_data() # to data_mailfiles

mailingbase[is.na(remove_dm1), .N, keyby = .(campaign_name, campaign_code)] %>%
  copy_data(header = FALSE) # appeal_codes

mailingbase[is.na(remove_dm1), .N, keyby = pack] %>%
  copy_data() # summary table

### EDM
mailingbase[is.na(remove_edm), .N, keyby = segment_code] %>%
  copy_data() # to data_mailfiles

mailingbase[is.na(remove_edm), .N, keyby = .(channel_segment)] %>%
  copy_data(header = FALSE) # appeal codes (summary)

mailingbase[is.na(remove_edm), .N, keyby = pack] %>%
  copy_data() # summary table

'

string_to_format_6 <-
'
mailingbase[is.na(ask_base)
            & cash_recency %in% c("0-12", "13-24"),
            let(ask_base = cash_last_amount,
                 ask_strategy = "Last Cash 1/1.5/2")]
'

string_to_format_7 <-
'
output_ac_counts[, `:=`(Communication = "XMAS WARM Appeal 2022",
                       `Test Flag` = NA_character_)]
'
string_to_format_8 <-
'mb_w2[
  donors, on = .(urn, key2),
  let(title = i.title)
]
'

string_to_format_9 <-
'
mb_w2[
  is.na(segment)
  & urn %in% trans[appeal_code %ilike% "FLOOD" & year == 2022, urn]
  & donor_type == "emergency",
  let(segment = "Flood Emergency",
      group_code = "FE")]
'

string_to_format_10 <-
'
trans[appeal_code %ilike% "FLOOD" & year == 2022, urn]
'

string_to_format_11 <-
'
mailingbase[, .(
    this = that + 1,
      foo = func(bar)
  ),
  .(foo, bar)
]
'

string_to_format_12 <-
'
mailingbase[, let(VP1 = NA_character_,
  VP2 = NA_character_)]
'

string_to_format_13 <-
'
gift_check <-
  trans[year > year(Sys.Date()) - 3
  & classification_code %in% c(
      classification_code("Cash"),
      classification_code("Capital Campaign"),
      classification_code("Emergency")
    ),
  .(num_gift = .N,
    min_gift = min(amount),
    max_gift = max(amount),
    last_gift_3 = amount[.N - 3],
    last_gift_2 = amount[.N - 2],
    last_gift_1 = amount[.N - 1],
    last_gift = amount[.N],
    avg_gift = mean(amount)
  ),
  by = urn]
'

string_to_format_14 <-
'
mailingbase[
  ask1_number >= 5000,
  `:=`(
    ask1 = NA,
    ask2 = NA,
    ask3 = NA,
    ask_override = "My Choice",
    ask_strategy = "My Choice"
  )
]
'
string_to_format_15 <-
'
mailingbase[
  is.na(VP1),
  let(
    VP1 = fcase(
      segment == "Active Bequest",
      "1.1 Active Bequests (AB)",
      segment == "Active Donors",
      "1.2 Active Donors (AD)",
      segment == "Flood Emergency",
      "1.3 Flood Emergency",
      segment == "Lapsed Donors",
      "1.4 Lapsed Donors (LD)",
      segment == "Newly Acquired Donors -first gift < 3mth (ND)",
      "1.7 Newly Acquired Donors (NAD)",
      segment == "Regular Givers + Cash",
      "1.8 Regular Givers Plus Cash (RG_Cash)",
      segment == "Religious Donor",
      "1.9 Religious Donors (RD)",
      default = "1.10 Standard Value/Default (SV_D)"
    )
  )
]
'
 string_to_format_16 <- '
	foo <- function(a, # my comment
	b, c) {
    print(a)
	}
'

 string_to_format_17 <- '
	 .[ask_conversion,
    on = .(ask_base >= from, ask_base <= to),
    let(ask1 = x1,
    ask2 = x1.5, ask3 = x2)]
'

string_to_format_18 <- '
styler::style_text(selection$text,
  foo = "boo", style = tdc_style
  )
'

string_to_format_19 <- '
dt <- rbindlist(list(
  dt1, dt2,
  dt3, dt4), fill = TRUE)
'

# styler: on

  styler::cache_deactivate()

  expect_snapshot(
    styler::style_text(string_to_format, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_2, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_3, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_4, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_6, style = tdc_style)
  )

  res <- styler::style_text(string_to_format_5, style = tdc_style)
  expect_true(
    all(!is.na(res)) & all(!is.null(res))
  )

  expect_snapshot(
    styler::style_text(string_to_format_7, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_8, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_9, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_10, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_11, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_12, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_13, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_14, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_15, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_16, style = tdc_style)
  )

  expect_snapshot(
    styler::style_text(string_to_format_17, style = tdc_style)
  )

  expect_snapshot(
    withr::with_options(
      new = list(tdcstyle.expand_args = TRUE),
      styler::style_text(string_to_format_18, style = tdc_style)
    )
  )

  expect_snapshot(
      styler::style_text(string_to_format_19, style = tdc_style)
  )

})
