
# Complete Workflow for NHS  

# logging ----------------------------------------------------------
start <- start_time()
report <- file(file.path('./Outputs', 'console_log_test.txt'), open = 'wt')
sink(report, type = 'output')
sink(report, type = 'message')
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

stop <- stop_time()
compute_time_limit(start, stop)
sink()
sink()

