style_fcase_linebreak <- function(pd) {
  if (is_dt_function_call_expr(pd, "fcase")) {
    lag_token <- c("NO_TOKEN", pd$token[-length(pd$token)])
    lhs_exprs <- pd$token == "expr" & lag_token != "EQ_SUB"
    lhs_exprs[1] <- FALSE #fcase

    # drop all newlines
    pd$newlines[which(lhs_exprs) + 1] <- 0L # + 1 to get us to the comma
    pd$lag_newlines[which(lhs_exprs) + 1 + 1] <- 0L

    exprs_newline_to_follow <- place_newlines(which(lhs_exprs))
    pd$newlines[exprs_newline_to_follow + 1] <- 1L # + 1 to get us to the comma
    pd$lag_newlines[exprs_newline_to_follow + 1 + 1] <- 1L
  }
  pd
}


place_newlines <- function(index_pool, results = integer(0)) {
  if (length(index_pool) == 1) return(c(results, index_pool[[1]]))
  if (length(index_pool) == 0) return(results)
  a <- index_pool[[1]]
  b <- index_pool[[2]]

  # if b is not the right distance from a,
  # a can't be paired with it, so a is just a singleton and
  # needs a line break. b is returned to pool and will be analysed again next.
  if (a != (b - 2)) {
    return(place_newlines(
      index_pool[-1],
      c(results, a)
    ))
  }
  # If b is the right distance from a, pair then and only place line break after b.
  # a and b are removed from pool.
  if (a == (b - 2)) {
    return(place_newlines(
      index_pool[-c(1, 2)],
      c(results, b)
    ))
  }
}

function(x) {
  paint::ipaint(pd)

  pd$text[lhs_exprs]
  which(drop_line_breaks) + 1
  which(lhs_exprs)
}
