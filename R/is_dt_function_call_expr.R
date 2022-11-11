#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param nameme1
#' @return
#' @author Miles McBain
#' @export
is_dt_function_call_expr <- function(fun_pd, text) {
  nrow(fun_pd) > 1 && any(fun_pd$text[[1]] %in% text) && fun_pd$token_before[[2]] == "SYMBOL_FUNCTION_CALL"
}
