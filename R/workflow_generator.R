####### Add ToString function. 


# Function to generate a workflow script
create_workflow_script <- function(file_path = "workflow.R",
                                   libraries = "",
                                   query = "",
                                   data_management = "",
                                   analysis = "",
                                   model_results = "") {
  
  # Default workflow template
  workflow_template <- "
# Libraries ----------------------------------------------------------

library(knitr)
library(DBI)
library(odbc)
{libraries}

# ODBC --------------------------------------------------------------------

my_oracle <- dbConnect(odbc::odbc(),
                       Driver = \"\",
                       DBQ = \"\", 
                       UID = \"\",
                       PWD = \"\",
                       trusted_connection = TRUE)

query1 <- \"{query}\"

data <- dbGetQuery(my_oracle, query1)

# Datamanagement ----------------------------------------------------------

{data_management}

# Analysis ---------------------------------------------------------------

{analysis}

# Model Results ----------------------------------------------------------

{model_results}


