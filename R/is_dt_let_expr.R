#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pd
#' @return
#' @author Miles McBain
#' @export
is_dt_let_expr <- function(let_pd) {
  nrow(let_pd) > 1 && let_pd$text[[1]] == "let" && let_pd$token_before[[2]] == "SYMBOL_FUNCTION_CALL"
}
