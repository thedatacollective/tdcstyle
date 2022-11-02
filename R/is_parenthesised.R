#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pd
#' @return
#' @author Miles McBain
#' @export
is_parenthesised <- function(pd) {
  first(pd$token) == "'('" && last(pd$token) == "')'"
}
