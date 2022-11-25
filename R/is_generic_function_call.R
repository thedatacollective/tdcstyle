is_generic_function_call <- function(fun_pd) {
  nrow(fun_pd) > 1 && fun_pd$token_before[[2]] %in% c("SYMBOL_FUNCTION_CALL", "FUNCTION")
}
