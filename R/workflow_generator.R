#' Workflow Generator
#'
#' @description
#' Generate a full workflow in R by feeding chunks of code into the `create_workflow` and get a script returned, which is ready to be send to NHS.
#'
#' @details
#' 
#' 
#' @param file_path
#' @param libraries bla bla 
#' @param query 
#' @param data_management 
#' @param analysis bla bla 
#' @param model_results blabla
#' 
#'
#' @return A character string containing the total execution time and the result (accepted or rejected).
#'         If the time exceeds 3 hours, a warning is issued.
#' @export
#'
#' @examples
#' 

###################### Add sqlite2oracle function in the create_workflow()
create_workflow <- function(
    file_path = paste0("workflow_", format(Sys.time(), "%Y%m%d_%H%M"), ".R"),
    libraries = "",
    query = "",
    data_management = "",
    analysis = "",
    model_results = ""
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
  
  if (query != "") {
    query <- sqlite2oracle(query)
  }
  
  workflow_template <- "
start <- Sys.time()

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

end <- Sys.time()
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
  message("Workflow script created at: ", file_path)
}
