table_sample <- function(df, n = 1000) {
  df[sample(nrow(df), size = n, replace = FALSE), ]
}

