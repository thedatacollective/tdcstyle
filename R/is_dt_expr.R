#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pd_flat
#' @return
#' @author Miles McBain
#' @export
is_dt_expr <- function(pd_flat) {
    all(c("'['", "']'") %in% pd_flat$token)
}
