library(testthat)
library(pbapply)
library(tools)
options(warn=-1)



test_read_simulacrum <- function(dir = "inst/extdata/minisimulacrum/", selected_files = NULL) {
  
  required_files <- c(
    "random_patient_data.Rda",
    "random_tumour_data.Rda"
  )
  
  if (!is.character(dir)) stop("Please make sure the input dir is a string.")
  if (!dir.exists(dir)) stop("Directory does not exist. Please check the path.")
  
  if (!is.null(selected_files) && !is.character(selected_files)) {
    stop("Error: 'selected_files' must be NULL or a charactor vector")
  }
  
  all_csv_files <- list.files(dir, pattern = "\\.Rda$", full.names = TRUE)
  available_files <- basename(all_csv_files)
  
  missing_files <- setdiff(required_files, available_files)
  if (length(missing_files) > 0) {
    stop("Missing required files: ", paste(missing_files, collapse = ", "))
  }
  
  files_to_read <- if (is.null(selected_files)) {
    all_csv_files[basename(all_csv_files) %in% required_files]
  } else {
    matched_files <- paste0(selected_files, ".csv")
    files <- all_csv_files[basename(all_csv_files) %in% matched_files]
    if (length(files) == 0) stop("No matching files found for selected files.")
    files
  }
  
  data_list <- pbapply::pblapply(files_to_read, function(file) {
    table_name <- tools::file_path_sans_ext(basename(file))
    message(sprintf("Reading: %s", table_name))
    read.csv(file, stringsAsFactors = FALSE)
  })
  
  names(data_list) <- tools::file_path_sans_ext(basename(files_to_read))
  message("Files successfully loaded!")
  warning("Please refer to tables by their original names, capitalized as presented (e.g., SIM_AV_PATIENT)")
  return(data_list)
  
}

test_that("test_read_simulacrum function works correctly", {

  expect_no_error(result <- test_read_simulacrum())
  
  expect_is(result, "list")
  
  expect_true("random_patient_data" %in% names(result))
  expect_true("random_tumour_data" %in% names(result))
  
  expect_is(result$random_patient_data, "data.frame")
  expect_is(result$random_tumour_data, "data.frame")
  
})