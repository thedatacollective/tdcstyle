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
