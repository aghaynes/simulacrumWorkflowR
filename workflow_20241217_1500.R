
start <- Sys.time()
log_func(function() {
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
FROM sim_av_patient
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

end <- Sys.time()
compute_time_limit(start, end)
  })
  
