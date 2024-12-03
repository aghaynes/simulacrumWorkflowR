#' Workflow Generator
#'
#' @description
#' Generate a full workflow in R by feeding chunks of code into the `create_workflow`
#'
#' @details
#' This time calculation function is implemented in the package because there is a 3-hour time limit for running analyses on NHS servers.
#' To help users estimate the runtime of their analyses, this function can be incorporated into their code.
#'
#' To use this function, place two time variable functions, `start_time()` and `end_time()`, which are `POSIXct` objects, 
#' at the beginning and end of your script, respectively. You can also use these functions to 
#' test the runtime of specific sections of your script. This function uses the `lubridate` package 
#' to calculate the time difference.
#'
#' The function provides messages to inform the user whether the 3-hour runtime has been exceeded.
#'
#' A warning message reminds users that analysis times on local machines and NHS servers are likely different.
#' However, even with potential time differences, the function provides a guide for time management and a reminder of the limitations of using NHS servers.
#'
#' @param start_time A `POSIXct` object representing the start time.
#' @param end_time A `POSIXct` object representing the end time.
#'
#' @return A character string containing the total execution time and the result (accepted or rejected).
#'         If the time exceeds 3 hours, a warning is issued.
#' @export
#'
#' @examples
#' start <- start_time()
#' # ... your code ...
#' end <- end_time()
#' compute_time_limit(start, end)


create_workflow <- function(
    file_path = paste0("workflow_", format(Sys.time(), "%Y%m%d_%H%M"), ".R"),
    libraries = NULL,
    query = "",
    data_management = NULL,
    analysis = NULL,
    model_results = NULL
) {
 
  clean_chunk <- function(chunk) {
    if (is.null(chunk)) 
      return("")
    
    if (is.expression(chunk)) {
      chunk <- toString(chunk) # Convert code into string
    }
    
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