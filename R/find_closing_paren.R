find_closing_paren <- function(tokens,
                               opening_paren_idx,
                               open_paren_token = "'('",
                               close_paren_token = "')'") {
  search_vec <- crop_before_idx(tokens, opening_paren_idx)

  paren_level <-
    Reduce(
      function(x, y) {
        if (y == open_paren_token) {
          x <- x + 1
        } else if (y == close_paren_token) {
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
  utils::tail(vec, length(vec) - (idx - 1))
}
