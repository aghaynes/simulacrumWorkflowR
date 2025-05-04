library(testthat)

create_workflow <- function(
    file_path = paste0("workflow_", format(Sys.time(), "%Y%m%d_%H%M"), ".R"),
    output_dir = "./Outputs",
    libraries = "",
    query = "",
    data_management = "",
    analysis = "",
    model_results = "",
    logging = TRUE
) 
{
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
  
  create_dir(output_dir)
  
  if (logging == TRUE) {
    logging_top <- sprintf("
# logging ----------------------------------------------------------
start <- start_time()
report <- file(file.path('%s', 'console_log_test.txt'), open = 'wt')
sink(report, type = 'output')
sink(report, type = 'message')", output_dir)
  } else {
    logging_top <- ""
  }
  
  if (logging == TRUE) {
    logging_bottom = "
stop <- stop_time()
compute_time_limit(start, stop)
sink()
sink()" 
  } else {
    logging_bottom <- ""
  }
  
  workflow_template <- "
# Complete Workflow for NHS  
{LOGGING_TOP}
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
{LOGGING_BOTTOM}
"
  
  workflow_content <- workflow_template
  workflow_content <- gsub("\\{LOGGING_TOP\\}", logging_top, workflow_content)
  workflow_content <- gsub("\\{LOGGING_BOTTOM\\}", logging_bottom, workflow_content)
  workflow_content <- gsub("\\{LIBRARIES\\}", libraries, workflow_content)
  workflow_content <- gsub("\\{QUERY\\}", query, workflow_content)
  workflow_content <- gsub("\\{DATA_MANAGEMENT\\}", data_management, workflow_content)
  workflow_content <- gsub("\\{ANALYSIS\\}", analysis, workflow_content)
  workflow_content <- gsub("\\{MODEL_RESULTS\\}", model_results, workflow_content)
  
  workflow_content <- gsub("\\n{3,}", "\n\n", workflow_content)
  
  output_file_path <- file.path(output_dir, file_path)
  
  tryCatch({
    writeLines(workflow_content, output_file_path)
    message("Workflow script created at: ", output_file_path)
  }, error = function(e) {
    warning(paste("Failed to write workflow file:", e$message))
  })
  
  message("The workflow script is designed for execution on National Health Service (NHS). Local execution of this script is likely to fail due to its dependency on a database connection. The goal of this package is to generate a workflow file compatible with the NHS server environment, which eliminates the need for local database configuration. Assuming successful execution of all local operations, including library imports, data queries, data management procedures, analyses, and file saving, the generated workflow is expected to function correctly within the NHS server environment.")  
  
  return(invisible(output_file_path))
}


test_that("creates the specified file in the specified directory", {
  test_output_dir <- file.path(tempdir(), paste0("test_dir_", sample(100, 1)))
  dir.create(test_output_dir, showWarnings = FALSE, recursive = TRUE)
  
  on.exit(unlink(test_output_dir, recursive = TRUE), add = TRUE)
  
  test_file_name <- "specific_workflow_file.R"
  expected_file_path <- file.path(test_output_dir, test_file_name)

  suppressMessages(
    create_workflow(
      file_path = test_file_name,   
      output_dir = test_output_dir 
    )
  )
  
  expect_true(file.exists(expected_file_path))
})
