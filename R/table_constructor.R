#' Save model results as HTML table
#' 
#' @description
#' A function for saving model summary as a locale HTML file 
#' 
#' @details
#' A requirement from the NHS when executing a analysis on the real CAS data it the output should be saved as a locale file.
#' The reason is that the staff at the database should just be able to run the analysis, copy the result table and send it back to the user by mail. 
#' 
#' This function uses `tab_model` a powerful package which designes tables for model summary. 
#' The package is fast and flexible, which allows it to be customised for the simulacrumR package.
#' 
#' As a extension of using this package, there is added some design modifications like added date and a default results. 
#' The function also sets a directory and helps create a folder for the results of the model. 
#' To make sure there is no overwritting are the local table name dynamic, meaning that the user will have to make sure to clean the folder after usages.
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
#' @imprtFrom sjPlot, sjmisc, sjlabelled
#' 
#' @example 
#' html_table(model)

html_table_model <- function(model, ######### Make the model name dynamic to help against overwritting # Add current date and time to the name of the file
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



#' Save Patient Characteristics as HTML table
#'
#' @param df Dataframe with patient characteristics
#' @param file Directory path for saving
#' @param file_name Name of the output file
#' @param title Title for the table with current date 
#' @param create_dir Logical, whether to create directory if missing
#'
#' @return Invisible path to saved file
#'
#' @export
#' @importFrom sjPlot tab_df
#'
#' @example 
#' html_table_patient(df)

html_table_patient <- function(df,                                        ##### Test and refine 
                               file = "results/",
                               file_name = "patient_characteristics",
                               title = NULL,
                               create_dir = TRUE) {
  
  if (!requireNamespace("sjPlot", quietly = TRUE)) {
    install.packages("sjPlot")
  }
  
  if (create_dir) {
    create_dir_if_none(file)
  }
  
  if (!endsWith(file, "/")) {
    file <- paste0(file, "/")
  }
  
  current_datetime <- format(Sys.time(), "%Y-%m-%d %H:%M")
  
  file_name <- paste0(file_name, ".html")
  
  full_path <- paste0(file, file_name)
  
  date_title <- if (is.null(title)) {
    sprintf("Patient Characteristics %s", current_datetime)
  } else {
    sprintf("%s %s", title, current_datetime)
  }
  
  html_table <- tab_df(df, 
                       file = full_path, 
                       title = date_title)
  
  message(sprintf("Results saved to: %s", full_path))
  
  return(html_table)
}