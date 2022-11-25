#' Style either the active file or active selection with tdc_style()
#'
#'  Preference is given to the active selection if it exists.
#'
#' @param expand_args expand arguments for function calls to new lines if one is
#'  on a new line
#' @export
style <- function(expand_args = getOption("tdcstyle.expand_args", FALSE)) {
  if (!requireNamespace("rstudioapi", quietly = TRUE)) {
    stop("style() needs the {rstudioapi} package to interact with your editor.")
  }
  selection_context <- rstudioapi::getSourceEditorContext()
  selection <- rstudioapi::primary_selection(selection_context)

  styled_text <-
    withr::with_options(
      new =
        list(
          tdcstyle.expand_args = expand_args
        ),
      code = {
        if (nchar(selection$text) == 0) {
          styler::style_file(selection_context$path, style = tdc_style)
        } else {
          styler::style_text(selection$text, style = tdc_style)
        }
      }
    )

  if (nchar(selection$text) != 0) {
    rstudioapi::insertText(
      location = selection$range,
      text = as.character(paste0(styled_text, collapse = "\n"))
    )
  }

  invisible(styled_text)
}

