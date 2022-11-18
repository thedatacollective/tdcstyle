style_function_args_linebreak <- function(pd) {

  # Is this a function(a,b,c) of fun(a,b,c)?
  if (is_generic_function_call(pd)) {
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

find_closing_paren <- function(tokens, opening_paren_idx) {
  search_vec <- crop_before_idx(tokens, opening_paren_idx)

  paren_level <-
    Reduce(
      function(x, y) {
        if (y == "'('") {
          x <- x + 1
        } else if (y == "')'") {
          x <- x - 1
        } else {
          x
        }
      },
      search_vec,
      init = 0,
      accumulate = TRUE
    )

	max(which(paren_level == 1)) + (opening_paren_idx - 1)

}

crop_before_idx <- function(vec, idx) {
  tail(vec, length(vec) - (idx - 1))
}


function() {
  pd <- styler:::compute_parse_data_nested("
	foo <- function(a,
	b, c) {
    print(a)
	}
	")
  pd$child[[1]]$child[[3]]

  pd <- styler:::compute_parse_data_nested("
  fun(a,
	b, x[1,2])
	")
  pd$child[[1]]

	styler::style_text(
	'
donors[
  urn %in% c(182929, 43288, 273054, 273532, 273137, 275541),
  `:=`(remove_dm1 = "QC Exclusion",
    remove_dm2 = "QC Exclusion",
    remove_dm3 = "QC Exclusion")]
	',
	style = tdc_style
	)
}
