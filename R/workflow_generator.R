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


####### Add ToString function. So you just save a chunk of code into a variable like libraries = "library(...)
                                                                                                 

######### Make sure to trimws to remove the whitespace between the first letter. The rest have to stay fixed
                                                                                                 


current_datetime <- format(Sys.time(), "%Y%m%d_%H%M")
create_workflow_script <- function(
    file_path = paste0("workflow_", current_datetime, ".R"),
    libraries = NULL,
    query = "",
    data_management = NULL,
    analysis = NULL,
    model_results = 
) {
  clean_chunk <- function(chunk) {
    if (is.null(chunk) || chunk == "") 
      return("")
    cleaned_lines <- trimws(strsplit(chunk, "\n")[[1]])
    cleaned_lines <- cleaned_lines[cleaned_lines != ""]
    
    paste(cleaned_lines, collapse = "\n")
  }
  
  libraries <- clean_chunk(libraries)
  query <- clean_chunk(query)
  data_management <- clean_chunk(data_management)
  analysis <- clean_chunk(analysis)
  model_results <- clean_chunk(model_results)
  
  workflow_template <- "
start <- start_time()

# Libraries ----------------------------------------------------------
library(knitr)
library(DBI)
library(odbc)
{LIBRARIES}

# ODBC --------------------------------------------------------------------
my_oracle <- dbConnect(odbc::odbc(),
                       Driver = \"\",
                       DBQ = \"\", 
                       UID = \"\",
                       PWD = \"\",
                       trusted_connection = TRUE)

# Query ----------------------------------------------------------
query1 <- \"{QUERY}\"
data <- dbGetQuery(my_oracle, query1)

# Data Management ----------------------------------------------------------
{DATA_MANAGEMENT}

# Analysis ----------------------------------------------------------
{ANALYSIS}

# Model Results ----------------------------------------------------------
{MODEL_RESULTS}

end <- end_time()
compute_time_limit(start, end)
"
  
  workflow_content <- workflow_template
  workflow_content <- gsub("\\{LIBRARIES\\}", libraries, workflow_content)
  workflow_content <- gsub("\\{QUERY\\}", query, workflow_content)
  workflow_content <- gsub("\\{DATA_MANAGEMENT\\}", data_management, workflow_content)
  workflow_content <- gsub("\\{ANALYSIS\\}", analysis, workflow_content)
  workflow_content <- gsub("\\{MODEL_RESULTS\\}", model_results, workflow_content)
  
  workflow_content <- gsub("\\n{3,}", "\n\n", workflow_content)
  
  writeLines(workflow_content, file_path)
}