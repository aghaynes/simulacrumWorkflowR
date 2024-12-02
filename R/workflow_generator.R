#' Transform code into a workflow.R file. 
#'
#' @description 
#' Generate a .R file based on chunks of code where all sections of a analysis is united into a full workflow file. 
#' 
#' @details
#' 
#' @param 
#'
#' @return 
#' @export
#'
#' @examples
#' 


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
start <- start_time()
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

end <- end_time()
compute_time_limit(start, end)
  "
  
  workflow_content <- gsub("\\{libraries\\}", toString(libraries), 
                      gsub("\\{query\\}", toString(query),
                      gsub("\\{data_management\\}", toString(data_management),
                      gsub("\\{analysis\\}", toString(analysis),
                      gsub("\\{model_results\\}", toString(model_results), 
                      workflow_template)))))
  
  writeLines(workflow_content, file_path)

}