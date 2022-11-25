is_dt_expr <- function(pd_flat) {
    all(c("'['", "']'") %in% pd_flat$token)
}
