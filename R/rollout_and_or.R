#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param nameme1
#' @return
#' @author Miles McBain
#' @export
rollout_and_or <- function(pd) {
  if (is.null(pd)) {
    return(NULL)
  }
  if (is_parenthesised(pd)) {
    return(pd)
  }
  and_or_idx <- pd$token %in% c("AND", "OR")
  pd$lag_newlines[and_or_idx] <- 1L
  pd$newlines[and_or_idx - 1] <- 1L

  if (!is.null(pd$child)) {
    if(any(lapply(pd$child, is.null))) browser()
    pd$child <- lapply(pd$child, rollout_and_or)
  }
  pd
}
