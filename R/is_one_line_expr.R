is_one_line_expr <- function(pd) {
  if (is_list_all_null(pd) | is.null(pd)) return(TRUE)
  sum(pd$newlines) == 0 & all(vapply(pd$child, is_one_line_expr, logical(1)))
}
