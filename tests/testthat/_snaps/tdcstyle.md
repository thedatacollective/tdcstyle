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

---

    Code
      styler::style_text(string_to_format_16, style = tdc_style)
    Output
      
      foo <- function(a, # my comment
                      b, c) {
        print(a)
      }

---

    Code
      styler::style_text(string_to_format_17, style = tdc_style)
    Output
      
      .[ask_conversion,
        on = .(ask_base >= from, ask_base <= to),
        let(ask1 = x1,
            ask2 = x1.5, ask3 = x2)]

---

    Code
      withr::with_options(new = list(tdcstyle.expand_args = TRUE), styler::style_text(
        string_to_format_18, style = tdc_style))
    Output
      
      styler::style_text(selection$text,
        foo = "boo",
        style = tdc_style
      )

---

    Code
      styler::style_text(string_to_format_19, style = tdc_style)
    Output
      
      dt <- rbindlist(list(
        dt1, dt2,
        dt3, dt4
      ), fill = TRUE)

---

    Code
      styler::style_text(string_to_format_20, style = tdc_style)
    Output
      
      mailingbase[,
        let(var = fcase(
            option1_flag == "thing", "option 1 thing",
            option1_flag == "other thing", "option 1 other thing"
          ))]

---

    Code
      styler::style_text(string_to_format_21, style = tdc_style)
    Output
      
      substitute2(
        mailingbase[
          !is.na(duplicate_group_name),
          let(primary_record_name = fcase(
              strategy == "first", indicate_first(.N),
              stragety == "last", indicate_last(.N)
            )),
          .(group)],
        list(
          primary_record_name = primary_record_name,
          duplicate_group_name = duplicate_group_name
        )
      )

---

    Code
      styler::style_text(string_to_format_22, style = tdc_style)
    Output
      
      dm_top_2000_threshold <-
        mailingbase[
          is.na(remove_dm1)
          & !is.na(cash_hag_amount),
          cash_hag_rank][2000]

