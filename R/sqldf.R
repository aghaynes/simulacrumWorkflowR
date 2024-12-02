#' Execute an SQL Query on a Data Frame
#'
#' @description
#' This function allows you to execute SQL queries directly on data frames using the `sqldf` package.
#' 
#' @details
#' The `sqldf` package provides a convenient interface for running SQL queries on R data frames. 
#' Behind the scenes, `sqldf` creates a temporary SQLite database, loads the specified data frames into it, 
#' executes the SQL query, retrieves the results as an R data frame, and then deletes the database. 
#' The process enables the user test SQL without having to setup database or connection between R and the database..
#' 
#' This function is particularly usefull for people who wants to use Simulacrum to access the CAS data. 
#' As the only setup needed is to install the package in R.  
#' 
#' @param query A character string containing the SQL query to execute.
#'
#' @return A data frame resulting from the SQL query.
#' 
#' @export
#' 
#' @example 
#' df <- sqldf('SELECT * FROM sim_av_patient') 
#' @importFrom sqldf sqldf

if (!requireNamespace("sqldf", quietly = TRUE)) {
  install.packages("sqldf")
}
if (!requireNamespace("tcltk", quietly = TRUE)) {
  install.packages("tcltk")
}
library(sqldf)
library(tcltk)
sql_test <- function(query) {
  if(!is.character(query))
    stop("The function must contain a string")
  sqldf(query, stringsAsFactors = FALSE)
}