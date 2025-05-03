#' Read and Load Multiple CSV Files
#'
#' @description
#' This function reads multiple CSV files from a specified directory. It validates the presence of required files, allows optional selection of specific files to load, and tracks progress during the loading process.
#'
#' @details
#' The function takes a directory path as input, where the CSV files downloaded from Simulacrum are located. 
#' It checks if the files are valid CSVs and verifies that all required CSV files are present in the directory by comparing the list of files in the directory with an internal list (required_files).
#' Optionally, users can specify certain CSV files to load using the selected_files argument.
#' 
#' Once the files are selected, they are imported into a list of data frames. Each data frame corresponds to a CSV file, and users can assign these data frames to variables as needed. 
#' It is recommended to name the data frames after their corresponding CSV files for clarity.
#' 
#' To enhance user experience, the function uses the pbapply package to display a progress bar and track the time taken to import each file.
#'
#' @param dir A character string specifying the directory containing the CSV files.
#' @param selected_files A character vector of file names (without extensions) to load. If NULL, all required files are loaded. Default is NULL.
#'
#'
#' @return A named list where each element is a data frame corresponding to a loaded CSV file. The names of the list elements are the file names without extensions.
#'
#' @examples
#' # Load all required files
#' data_frames <- read_csv("directory/to/csv")
#' sim_av_patient <- data_frames$sim_av_patient
#'
#' # Load specific files
#' data_frames <- read_csv("directory/to/csv"), selected_files = c("sim_av_patient", "sim_av_tumour"))
#'
#' @export
#' @importFrom pbapply pblapply

read_simulacrum <- function(dir = "./simulacrum_v2.1.0/Data/", selected_files = NULL) {
  
  required_files <- c(
    "sim_av_gene.csv",
    "sim_av_patient.csv",
    "sim_av_tumour.csv",
    "sim_rtds_combined.csv",
    "sim_rtds_episode.csv",
    "sim_rtds_exposure.csv",
    "sim_rtds_prescription.csv",
    "sim_sact_cycle.csv",
    "sim_sact_drug_detail.csv",
    "sim_sact_outcome.csv",
    "sim_sact_regimen.csv"
  )
  
  if (!is.character(dir)) stop("Please make sure the input dir is a string.")
  if (!dir.exists(dir)) stop("Directory does not exist. Please check the path.")
  
  if (!is.null(selected_files) && !is.character(selected_files)) {
    stop("Error: 'selected_files' must be NULL or a character vector")
  }
  
  all_csv_files <- list.files(dir, pattern = "\\.csv$", full.names = TRUE)
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

