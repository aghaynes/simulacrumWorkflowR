
# Workflow Start
start <- start_time()

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
query1 <- "select *
from sim_av_patient
where age > 50
limit 500;"
data <- dbGetQuery(my_oracle, query1)

# Data Management ----------------------------------------------------------
# Run query on SQLite database
df1 <- sql_test(query1)
# Additional preprocessing
df2 <- survival_days(df1)

# Analysis ----------------------------------------------------------
model = glm(x ~ x1 + x2 + x3, data=data)

# Model Results ----------------------------------------------------------
html_table_model(model)

end <- end_time()
compute_time_limit(start, end)

