has_filter_expr <- function(pd) {
    first_opening_bracket_idx <- first(which(pd$token == "'['"))
    pd$token[first_opening_bracket_idx + 1] == "expr"
}
