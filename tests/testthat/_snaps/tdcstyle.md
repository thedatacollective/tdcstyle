# tdc styler works

    Code
      styler::style_text(string_to_format, style = tdc_style)
    Output
      dt[
        is.na(remove_na1),]

---

    Code
      styler::style_text(string_to_format_2, style = tdc_style)
    Output
      donors[
        is.na(force_reason)
        & is.na(remove_dm1)
        & cashemerg_hag_amount >= 1000,
        let(force_include = "Y",
            force_reason = "01. High Mid Value Cash/Emerg",
            pack = "MV")]

---

    Code
      styler::style_text(string_to_format_3, style = tdc_style)
    Output
      donors[,
        .N,
        .(group1, group2)]

---

    Code
      styler::style_text(string_to_format_4, style = tdc_style)
    Output
      donors[
        is.na(force_reason)
        | (is.na(other_reason) & cashemerg_hag_amount >= 1000),
        let(force_include = "Y",
            force_reason = "01. High Mid Value Cash/Emerg",
            pack = "MV")]

---

    Code
      styler::style_text(string_to_format_6, style = tdc_style)
    Output
      
      mailingbase[
        is.na(ask_base)
        & cash_recency %in% c("0-12", "13-24"),
        let(ask_base = cash_last_amount,
            ask_strategy = "Last Cash 1/1.5/2")]

---

    Code
      styler::style_text(string_to_format_7, style = tdc_style)
    Output
      
      output_ac_counts[,
        let(Communication = "XMAS WARM Appeal 2022",
            `Test Flag` = NA_character_)]

---

    Code
      styler::style_text(string_to_format_8, style = tdc_style)
    Output
      mb_w2[
        donors,
        on = .(urn, key2),
        let(title = i.title)]

---

    Code
      styler::style_text(string_to_format_9, style = tdc_style)
    Output
      
      mb_w2[
        is.na(segment)
        & urn %in% trans[appeal_code %ilike% "FLOOD" & year == 2022, urn]
        & donor_type == "emergency",
        let(segment = "Flood Emergency",
            group_code = "FE")]

---

    Code
      styler::style_text(string_to_format_10, style = tdc_style)
    Output
      
      trans[appeal_code %ilike% "FLOOD" & year == 2022, urn]

---

    Code
      styler::style_text(string_to_format_11, style = tdc_style)
    Output
      
      mailingbase[,
        .(this = that + 1,
          foo = func(bar)),
        .(foo, bar)]

---

    Code
      styler::style_text(string_to_format_12, style = tdc_style)
    Output
      
      mailingbase[,
        let(VP1 = NA_character_,
            VP2 = NA_character_)]

---

    Code
      styler::style_text(string_to_format_13, style = tdc_style)
    Output
      
      gift_check <-
        trans[
          year > year(Sys.Date()) - 3
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
            avg_gift = mean(amount)),
          by = urn]

---

    Code
      styler::style_text(string_to_format_14, style = tdc_style)
    Output
      
      mailingbase[
        ask1_number >= 5000,
        let(ask1 = NA,
            ask2 = NA,
            ask3 = NA,
            ask_override = "My Choice",
            ask_strategy = "My Choice")]

---

    Code
      styler::style_text(string_to_format_15, style = tdc_style)
    Output
      
      mailingbase[
        is.na(VP1),
        let(VP1 = fcase(
            segment == "Active Bequest", "1.1 Active Bequests (AB)",
            segment == "Active Donors", "1.2 Active Donors (AD)",
            segment == "Flood Emergency", "1.3 Flood Emergency",
            segment == "Lapsed Donors", "1.4 Lapsed Donors (LD)",
            segment == "Newly Acquired Donors -first gift < 3mth (ND)", "1.7 Newly Acquired Donors (NAD)",
            segment == "Regular Givers + Cash", "1.8 Regular Givers Plus Cash (RG_Cash)",
            segment == "Religious Donor", "1.9 Religious Donors (RD)",
            default = "1.10 Standard Value/Default (SV_D)"
          ))]

