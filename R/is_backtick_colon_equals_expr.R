#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pd
#' @return
#' @author Miles McBain
#' @export
is_backtick_colon_equals_expr <- function(pd) {
  is_dt_function_call_expr(pd, "`:=`")
}
