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
"
  workflow_content <- workflow_template %>%
    gsub("\\{libraries\\}", libraries, .) %>%
    gsub("\\{query\\}", query, .) %>%
    gsub("\\{data_management\\}", data_management, .) %>%
    gsub("\\{analysis\\}", analysis, .) %>%
    gsub("\\{model_results\\}", model_results, .)
  
  # Write the workflow content to the specified file
  writeLines(workflow_content, file_path)
  
  message("Workflow script created at: ", file_path)
}


