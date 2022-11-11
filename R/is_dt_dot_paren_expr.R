#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pd
#' @return
#' @author Miles McBain
#' @export
is_dt_dot_paren_expr <- function(pd) {
  is_dt_function_call_expr(pd, ".")
}
