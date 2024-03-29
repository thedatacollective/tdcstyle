style_fcase_linebreak <- function(pd) {
  if (is_dt_function_call_expr(pd, "fcase")) {
    lag_token <- c("NO_TOKEN", pd$token[-length(pd$token)])
    lhs_exprs <- pd$token == "expr" & lag_token != "EQ_SUB"
    lhs_exprs[1] <- FALSE #fcase

    # drop newlines after commas
    lhs_expr_ind <- which(lhs_exprs)
    lhs_expr_trailing_commas <- pd$text[lhs_expr_ind + 1] == ","
    lhs_expr_trailing_comma_ind <- lhs_expr_ind[lhs_expr_trailing_commas] + 1
    pd$newlines[lhs_expr_trailing_comma_ind] <- 0L
    pd$lag_newlines[lhs_expr_trailing_comma_ind + 1] <- 0L

    # set newlines
    # set them after the commas for expressions that have them trailing
    # and possibly not after the comma, just after the expression for those that don't
    # a lhs expression that is the last one with no `default` follow will not have a tailing comma
    lhs_exp_no_trailing_comma_ind <- lhs_expr_ind[!lhs_expr_trailing_commas]

    exprs_newline_to_follow <- setdiff(place_newlines(which(lhs_exprs)), lhs_exp_no_trailing_comma_ind)
    pd$newlines[exprs_newline_to_follow + 1] <- 1L # + 1 to get us to the comma
    pd$lag_newlines[exprs_newline_to_follow + 1 + 1] <- 1L

    # and finally something that has no comma, so it must be the last thing
    pd$newlines[lhs_exp_no_trailing_comma_ind] <- 1L
    pd$lag_newlines[lhs_exp_no_trailing_comma_ind + 1] <- 1L
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
