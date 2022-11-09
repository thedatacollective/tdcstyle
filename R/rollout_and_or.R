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
  if (is.null(pd) | is_list_all_null(pd)) {
    return(pd)
  }
  if (is_parenthesised(pd)) {
    return(pd)
  }
  and_or_idx <- pd$token %in% c("AND", "OR")
  pd$lag_newlines[and_or_idx] <- 1L
  pd$newlines[and_or_idx - 1] <- 1L

  if (!is_list_all_null(pd$child)) {
    pd$child <- lapply(pd$child, rollout_and_or)
  }
  pd
}

is_list_all_null <- function(x) {
  is.list(x) && all(all(unlist(lapply(x, is.null))))
}
