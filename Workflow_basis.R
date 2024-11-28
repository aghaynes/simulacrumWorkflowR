
# Libraries ----------------------------------------------------------

library(tidyverse)
library(lubridate)
library(broom)
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

query1 <- "... query to retrieve data..."



data <- dbGetQuery(my_oracle, query1)


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







