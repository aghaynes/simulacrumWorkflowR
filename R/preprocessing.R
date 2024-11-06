table_sample <- function(df) {
  df[sample(nrow(df), size = 1000, replace = FALSE),]
}


