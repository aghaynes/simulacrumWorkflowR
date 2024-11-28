
# Datamanagement ----------------------------------------------------------

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
                       DBQ = "", 
                       UID = "system",
                       PWD = "",
                       trusted_connection = TRUE)

query1 <- "... query to retrieve data..."

query2 <- " ... query to retrieve more data ..."


sact_regimen <- dbGetQuery(my_oracle, query1)
av_tumour <- dbGetQuery(my_oracle, query2)

# Datamanagement ----------------------------------------------------------

### ... Preprocessing ... 

# Table 1 -----------------------------------------------------------------

### ... Analysis ... 

html_table(model)

# Table 2 -----------------------------------------------------------------

### ... Analysis 2 ....

html_table(model2)


# Table 3 (not required) --------------------------------------------------


### ... Analysis 3 ...

html_table(model3)







