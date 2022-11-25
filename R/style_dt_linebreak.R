style_dt_line_break <- function(pd) {

  if (is_dt_expr(pd)) {

    # Don't mess with it, if it's all on one line.
    if (is_one_line_expr(pd)) return(pd)

    # Move up closing ']'
    pd$newlines[pd$token_after == "']'"] <- 0L
    pd$lag_newlines[pd$token == "']'"] <- 0L

    # if , follows the first [ - move it up.
    first_bracket_idx <- first(which(pd$token == "'['"))
    if (pd$token_after[first_bracket_idx] == "','") {
      pd$newlines[first_bracket_idx] <- 0L
      pd$lag_newlines[first_bracket_idx + 1] <- 0L
    }

    # if the thing that follows the [ is not a ',', push it down, unlesss we're a `.[]`
    if (pd$token_after[first_bracket_idx] != "','" & !is_dt_named_dot(pd)) {
      pd$newlines[first_bracket_idx] <- 1L
      pd$lag_newlines[first_bracket_idx + 1] <- 1L
    }

    # if the thing that follows the [ is not a ',', and we're a `.[]`, pull it up
    if (pd$token_after[first_bracket_idx] != "','" & is_dt_named_dot(pd)) {
      pd$newlines[first_bracket_idx] <- 0L
      pd$lag_newlines[first_bracket_idx + 1] <- 0L
    }

    # if it has compound filter with & and | split those onto new lines
    if (has_filter_expr(pd)) {
      first_opening_bracket_idx <- first(which(pd$token == "'['"))
      filter_expr_idx <- first_opening_bracket_idx + 1
      pd$child[filter_expr_idx] <- list(rollout_and_or(pd$child[[filter_expr_idx]]))
    }

    # start all DT function expressions, that don't follow an '=', on a new line
    lag_token <- c("NO_TOKEN", pd$token[-length(pd$token)])
    lhs_exprs <- lag_token != "EQ_SUB"
    dt_function_exprs <-
        vapply(
          pd$child,
          is_dt_function_call_expr,
          logical(1),
          c("let", ".", "`:=`")
        )
    pd$text[lhs_exprs & dt_function_exprs]
    pd$lag_newlines[lhs_exprs & dt_function_exprs] <- 1L
    pd$newlines[which(lhs_exprs & dt_function_exprs) - 1] <- 1L
  }

  if (is_dt_function_call_expr(pd, c("let", "`:=`", "."))) {

    # move up the first binding of let() or .() or `:=()` onto same line as "("
    first_opening_paren_idx <- first(which(pd$token == "'('"))
    pd$newlines[first_opening_paren_idx] <- 0L
    pd$lag_newlines[first_opening_paren_idx + 1] <- 0L

    # move up the last ')' of let() or .() or `:=()`
    last_closing_paren_idx <- last(which(pd$token == "')'"))
    pd$newlines[last_closing_paren_idx - 1] <- 0L
    pd$lag_newlines[last_closing_paren_idx] <- 0L

  }

  pd
}



function() {
  pd <- styler:::compute_parse_data_nested("foo[is.na(remove_dm1) & beq_consider == 1 | flag_something == 1, ]")
  pd$child[[4]]
}
