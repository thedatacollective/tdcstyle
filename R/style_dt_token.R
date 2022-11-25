style_dt_token <- function(pd) {

  if(is_dt_function_call_expr(pd, "`:=`")) {
    pd$text[[1]] <- "let"
    pd$short[[1]] <- "let"
    pd$child[[1]]$text <- "let"
    pd$child[[1]]$short <- "let"
  }

  pd

}


