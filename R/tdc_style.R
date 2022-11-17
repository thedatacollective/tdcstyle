#' @export
tdc_style <- function() {
  transformers <- styler::tidyverse_style()
  styler::create_style_guide(
    line_break =
      c(transformers$line_break,
        style_dt_line_break = style_dt_line_break,
        style_fcase_linebreak = style_fcase_linebreak),
    space =
      c(transformers$space, style_dt_space = style_dt_space),
    token = c(transformers$token, style_dt_token = style_dt_token),
    indention =  c(transformers$indention, style_dt_indentation = style_dt_indention),
    style_guide_name = "tdcstyle@https://gitlab.com/thedatacollective/tdcstyle",
    style_guide_version = packageDescription("tdcstyle")[["Version"]]
  )
}
