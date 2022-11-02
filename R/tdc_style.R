tdc_style <- function() {
  styler::create_style_guide(
    line_break = tibble::lst(
      style_dt_linebreak = style_dt_line_break
    ),
    space = tibble::lst(
      style_dt_space = style_dt_space
      ),
    token = tibble::lst(
      style_dt_token = style_dt_token
    ),
    indention = tibble::lst(
      style_dt_indention = style_dt_indention
    ),
    style_guide_name = "tdcstyle@https://gitlab.com/thedatacollective/tdcstyle",
    style_guide_version = read.dcf(here::here("DESCRIPTION"))[, "Version"]
  )
}
