#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param pd
#' @return
#' @author Miles McBain
#' @export
style_dt_line_break <- function(pd) {

  if (is_dt_expr(pd)) {
    pd$newlines[pd$token_after == "']'"] <- 0L
    pd$lag_newlines[pd$token == "']'"] <- 0L

    # if , follows the first [ - move it up.
    first_comma_idx <- first(which(pd$token == "','"))
    if (pd$token_before[first_comma_idx] == "'['") {
      pd$newlines[first_comma_idx - 1] <- 0L
      pd$lag_newlines[first_comma_idx] <- 0L
    }

    # if it has compound filter with & and | split those onto new lines
    if (has_filter_expr(pd)) {
      first_opening_bracket_idx <- first(which(pd$token == "'['"))
      filter_expr_idx <- first_opening_bracket_idx + 1
      pd$child[filter_expr_idx] <- list(rollout_and_or(pd$child[[filter_expr_idx]]))
    }

  }


  if (is_dt_let_expr(pd)) {

    # move up the first binding of let() onto same line as 'let('
    first_opening_paren_idx <- first(which(pd$token == "'('"))
    pd$newlines[first_opening_paren_idx] <- 0L
    pd$lag_newlines[first_opening_paren_idx + 1] <- 0L

    # move up the last ')' of let() if it's followed by ']'
    last_closing_paren_idx <- last(which(pd$token == "')'"))
    if (pd$token_after[[last_closing_paren_idx]] == "']'") {
      pd$newlines[last_closing_paren_idx - 1] <- 0L
      pd$lag_newlines[last_closing_paren_idx] <- 0L
    }

  }

  pd
}



function() {
  pd <- styler:::compute_parse_data_nested("foo[is.na(remove_dm1) & beq_consider == 1 | flag_something == 1, ]")
  pd$child[[1]]$child[[3]]
}
