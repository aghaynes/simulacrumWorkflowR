#' Save model results as HTML table
#' 
#' @param model Statistical model object
#' @param file Directory path for saving
#' @param file_name Name of the output file
#' @param title Title for the table with current date 
#' @param create_dir Logical, whether to create directory if missing
#' 
#' @return Invisible path to saved file
#' 
#' @export
#' 
#' @example 
#' html_table(model)

html_table_model <- function(model, 
                       file = "results/",
                       file_name = "model_results",
                       title = NULL,
                       create_dir = TRUE) {
  
  # Check and install required packages
  if (!requireNamespace("sjPlot", quietly = TRUE)) {
    install.packages("sjPlot")
  }
  if (!requireNamespace("sjmisc", quietly = TRUE)) {
    install.packages("sjmisc")
  }
  if (!requireNamespace("sjlabelled", quietly = TRUE)) {
    install.packages("sjlabelled")
  }
  
  # Create directory if needed
  if (create_dir) {
    create_dir_if_none(file)
  }
  
  # Ensure file path ends with separator
  if (!endsWith(file, "/")) {
    file <- paste0(file, "/")
  }
  
  current_datetime <- format(Sys.time(), "%Y-%m-%d %H:%M")
  
  file_name <- paste0(file_name, ".html")
  
  full_path <- paste0(file, file_name)
  
  date_title <- if (is.null(title)) {
    sprintf("Model Results %s", current_datetime)
  } else {
    sprintf("%s %s", title, current_datetime)
  }
  
  # Create table
  html_table <- tab_model(model, 
                    file = full_path, 
                    title = date_title)
  message(sprintf("Results saved to: %s", full_path))
  
  return(html_table)
}


#' Creating a Dir if there is None
#' 
#' @param dir the direction to the folder 
#' 
#' @return folder 
#' 
#' @export
#' 
#' @example 
#' ...

create_dir_if_none <- function(dir) {
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
}



#' Save Patient Charecteristics as HTML tabel
#' 
#' @param model Statistical model object
#' @param file Directory path for saving
#' @param file_name Name of the output file
#' @param title Title for the table with current date 
#' @param create_dir Logical, whether to create directory if missing
#' 
#' @return Invisible path to saved file
#' 
#' @export
#' 
#' @example 
#' html_table(model)

html_table_patient <- function(extended_summary, 
                                file = "results/",
                                file_name = "model_results",
                                title = NULL,
                                create_dir = TRUE)  {}






