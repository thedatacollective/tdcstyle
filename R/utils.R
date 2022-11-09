last <- function(x) tail(x, 1)

first <- function(x) head(x, 1)

clamp <- function(x, min_val = min(x), max_val = max(x)) {
  x[x >= min_val & x <= max_val]
}
