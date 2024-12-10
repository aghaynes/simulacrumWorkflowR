
start <- Sys.time()

# Libraries ----------------------------------------------------------
library(knitr)
library(DBI)
library(odbc)

# ODBC --------------------------------------------------------------------
my_oracle <- dbConnect(odbc::odbc(),
                       Driver = "",
                       DBQ = "", 
                       UID = "",
                       PWD = "",
                       trusted_connection = TRUE)

# Query ----------------------------------------------------------
query1 <- ""
data <- dbGetQuery(my_oracle, query1)

# Data Management ----------------------------------------------------------

# Analysis ----------------------------------------------------------

# Model Results ----------------------------------------------------------

end <- Sys.time()
compute_time_limit(start, end)

