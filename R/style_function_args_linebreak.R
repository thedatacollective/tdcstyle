style_function_args_linebreak <- function(pd) {

  # Is this a function(a,b,c) or fun(a,b,c)?
  if (is_generic_function_call(pd) && getOption("tdcstyle.expand_args", FALSE)) {
    opening_paren_idx <- first(which(pd$token == "'('"))
    closing_paren_idx <- find_closing_paren(pd$token, opening_paren_idx)

		function_arg_paren_scope <- seq(opening_paren_idx + 1, closing_paren_idx - 1)
    if (!is_one_line_expr(pd[function_arg_paren_scope, ])) {
		  commas <- pd$token == "','"
			comments_with_commas_prior <- pd$token == "COMMENT" & pd$token_before == "','"
			commas_with_comments_after <- pd$token == "','" & pd$token_after == "COMMENT"
			newline_candidates <-
			  (commas & !commas_with_comments_after) | comments_with_commas_prior
			newline_idx <-
			  intersect(which(newline_candidates), function_arg_paren_scope)

			pd$newlines[newline_idx] <- 1L
			pd$lag_newlines[newline_idx + 1] <- 1L
		}
  }

	pd
}
