is_parenthesised <- function(pd) {
  first(pd$token) == "'('" && last(pd$token) == "')'"
}
