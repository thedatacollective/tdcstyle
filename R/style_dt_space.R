#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pd
#' @return
#' @author Miles McBain
#' @export
style_dt_space <- function(pd) {

  if (is_dt_expr(pd)) {
      pd$spaces[pd$token_after == "']'"] <- 0L
  }

  pd
}



function() {
  pd <- styler:::compute_parse_data_nested("foo[, let(arg1 = 'foo', arg100 = 'baz') ]")
  pd <- pd$child[[1]]$child[[4]]
}
