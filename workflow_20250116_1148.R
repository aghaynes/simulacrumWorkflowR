
# logging ----------------------------------------------------------
start <- start_time()
report <- file('console_log_test.txt', open = 'wt')
sink(report ,type = 'output')
sink(report, type = 'message')

# Libraries ----------------------------------------------------------
library(knitr)
library(DBI)
library(odbc)
library(dplyr)

# ODBC --------------------------------------------------------------------
my_oracle <- dbConnect(odbc::odbc(),
                       Driver = "",
                       DBQ = "", 
                       UID = "",
                       PWD = "",
                       trusted_connection = TRUE)

# Query ----------------------------------------------------------
query1 <- "SELECT *
FROM SIM_AV_PATIENT
WHERE age > 50
AND ROWNUM <= 500;"
data <- dbGetQuery(my_oracle, query1)

# Data Management ----------------------------------------------------------
# Run query on SQLite database
cancer_grouping(sim_av_tumour)
# Additional preprocessing
#df2 <- survival_days(df1)

# Analysis ----------------------------------------------------------
model = glm(x ~ x1 + x2 + x3, data=data)

# Model Results ----------------------------------------------------------
html_table_model(model)

stop <- stop_time()
compute_time_limit(start, stop)

sink()
sink()
  
