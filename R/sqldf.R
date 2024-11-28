#' Execute an SQL Query on a Data Frame
#'
#' @description
#' This function allows you to execute SQL queries directly on data frames using the `sqldf` package.
#'
#' @param query A character string containing the SQL query to execute.
#'
#' @return A data frame resulting from the SQL query.
#' 
#' @export
#' 
#' @example 
#' df <- sqldf('SELECT * FROM sim_av_patient') 

if (!requireNamespace("sqldf", quietly = TRUE)) {
  install.packages("sqldf")
}
if (!requireNamespace("tcltk", quietly = TRUE)) {
  install.packages("tcltk")
}
library(sqldf)
library(tcltk)
sql_test <- function(query) {
  sqldf(query, stringsAsFactors = FALSE)
}