library(tidyverse)
library(lubridate)
library(forestmodel)
library(broom)
library(knitr)
library(DBI)
library(odbc)

# ODBC --------------------------------------------------------------------

my_oracle <- dbConnect(odbc::odbc(),
                       Driver = "Oracle in instantclient_21_12",
                       DBQ = "localhost:1521/XEPDB1", 
                       UID = "system",
                       PWD = "test1234",
                       trusted_connection = TRUE)

query1 <- "..."

query2 <- "..."


sact_regimen <- dbGetQuery(my_oracle, query1)
av_tumour <- dbGetQuery(my_oracle, query2)

# Analysis --------------------------------------------------------------------
# ... #

# Save model as a html table 

html_table(model)
