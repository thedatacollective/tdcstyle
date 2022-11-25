rollout_and_or <- function(pd) {
  if (is.null(pd) | is_list_all_null(pd)) {
    return(pd)
  }
  if (is_parenthesised(pd)) {
    return(pd)
  }
  if (is_dt_expr(pd)) {
    # don't recurse into nested dt expressions, these will be visited anyway,
    # and if they're one-liners we don't wanto to roll them out.
    return(pd)
  }
  and_or_idx <- which(pd$token %in% c("AND", "OR"))
  pd$lag_newlines[and_or_idx] <- 1L
  pd$newlines[and_or_idx - 1] <- 1L
  pd$newlines[and_or_idx] <- 0L
  pd$lag_newlines[and_or_idx + 1] <- 0L

  if (!is_list_all_null(pd$child)) {
    pd$child <- lapply(pd$child, rollout_and_or)
  }
  pd
}

is_list_all_null <- function(x) {
  is.list(x) && all(all(unlist(lapply(x, is.null))))
}
