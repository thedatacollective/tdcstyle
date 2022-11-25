style_dt_indention <- function(pd) {

  # if it's a let expression vertically align the args by adding 2 extra spaces
  if (is_dt_function_call_expr(pd, c("let", "`:=`"))) {
    opening_paren_idx <- first(which(pd$token == "'('"))
    closing_paren_idx <- last(which(pd$token == "')'"))
    interior_idxs <- clamp(seq_along(pd$token), min_val = opening_paren_idx, max_val = closing_paren_idx)
    if (length(interior_idxs) < 1) {
      # if there's only one arg or no args no need to align
      return(pd)
    }
    # spaces follow newlines
    pd$indent[interior_idxs] <- pd$indent[interior_idxs] + 2
  }
  pd

}
