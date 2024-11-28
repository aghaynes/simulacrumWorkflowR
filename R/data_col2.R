#' Read and Load Multiple CSV Files
#'
#' @description
#' This function reads multiple CSV files from a specified directory. It validates the presence of required files, allows optional selection of specific files to load, and tracks progress during the loading process.
#'
#' @param dir A character string specifying the directory containing the CSV files.
#' @param selected_files A character vector of file names (without extensions) to load. If `NULL`, all required files are loaded. Default is `NULL`.
#'
#' @return A named list where each element is a data frame corresponding to a loaded CSV file. The names of the list elements are the file names without extensions.
#' @export
#' 
#' @example 
#' data_frames <- read_csv(dir) 
#' sim_av_patient <- data_frames$sim_av_patient

read_csv <- function(dir, selected_files = NULL) {
    if (!requireNamespace("pbapply", quietly = TRUE)) {
      install.packages("pbapply")
    }

  
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
  
  
  if (!is.character(dir)) stop("Please make sure input dir is a string.")
  if (!dir.exists(dir)) stop("Directory does not exist. Please check the path.")
  
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
  return(data_list)
}
