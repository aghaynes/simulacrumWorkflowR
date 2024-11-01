#' Make the Simulacrum tables feasable
#'
#' This function randomly samples 1000 rows from a given dataframe.
#' If the dataframe has fewer than 1000 rows, it returns the original dataframe.
#'
#' @param df A dataframe.
#'
#' @return A dataframe with a maximum of 1000 rows.
#'
#' @examples
#' table_sample(sim_av_patients)
table_sample <- function(df) {
  if (nrow(df) > 1000) {
    return(df[sample(nrow(df), 1000), ])
  } else {
    return(df)
  }
}
