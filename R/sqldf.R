if (!requireNamespace("sqldf", quietly = TRUE)) {
  install.packages("sqldf")
}
if (!requireNamespace("tcltk", quietly = TRUE)) {
  install.packages("tcltk")
}
library(sqldf)
library(tcltk)

########## sql_test setup ###########
sql_test <- function(query) {
  sqldf(query, stringsAsFactors = FALSE)
}