#' Save model results as HTML table
#' 
#' @description
#' A function for saving model summary as a locale HTML file 
#' 
#' @details
#' A requirement from the NHS when executing a analysis on the real CAS data it the output should be saved as a locale file.
#' The reason is that the staff at the database should just be able to run the analysis, copy the result table and send it back to the user by mail. 
#' 
#' This function uses tab_model a powerful package which designes tables for model summary. 
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
html_table_model <- function(model, 
                             file = "results/",
                             file_name = paste0("model_results", format(Sys.time(), "%Y%m%d_%H%M")),
                             title = NULL,
                             create_dir = TRUE,
                             output_format = "html") {
  
  output_format <- match.arg(output_format)
  
  if (!requireNamespace("sjPlot", quietly = TRUE)) {
    install.packages("sjPlot")
  }
  if (!requireNamespace("writexl", quietly = TRUE)) {
    install.packages("writexl")
  }
  
  if (create_dir) {
    create_dir_if_none(file)
  }
  
  if (!endsWith(file, "/")) {
    file <- paste0(file, "/")
  }
  
  current_datetime <- format(Sys.time(), "%Y-%m-%d %H:%M")
  
  date_title <- if (is.null(title)) {
    sprintf("Model Results %s", current_datetime)
  } else {
    sprintf("%s %s", title, current_datetime)
  }
  
  full_path <- paste0(file, file_name)
  
  if (output_format == "html") {
    full_path <- paste0(full_path, ".html")
    
    tab_model(model, 
              file = full_path, 
              title = date_title)
    
    message(sprintf("Results saved as HTML to: %s", full_path))
  } else if (output_format == "excel") {
    full_path <- paste0(full_path, ".xlsx")
    
    model_sum <- summary(model)
    coef_table <- as.data.frame(model_sum$coefficients)
    
    metadata <- data.frame(Description = c("Model Title", "Generated On"), 
                           Value = c(date_title, current_datetime))
    data_out <- list(Metadata = metadata, Coefficients = coef_table)
    
    # Write to Excel
    writexl::write_xlsx(data_out, full_path)
    message(sprintf("Results saved as Excel to: %s", full_path))
  }
  
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

create_dir_if_none <- function(dir) {  #### Move to utils
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
}




###### Write documentation and test 
if (!requireNamespace("tableone", quietly = TRUE)) {
  install.packages("tableone")
}
if (!requireNamespace("htmlTable", quietly = TRUE)) {
  install.packages("htmlTable")
}
if (!requireNamespace("writexl", quietly = TRUE)) {
  install.packages("writexl")
}


create_summary_table <- function(data, vars, strata = NULL, includeNA = FALSE, save_path = NULL, file_format = "html") {


  table <- tableone::CreateTableOne(
    data = data,
    vars = vars,
    strata = strata,
    includeNA = includeNA
  )
  
  if (!is.null(save_path)) {
    if (file_format == "html") {
      html <- htmlTable::htmlTable(print(table, printToggle = TRUE))
      write(html, file = save_path)
    } else if (file_format == "excel") {
      table_df <- as.data.frame(print(table, printToggle = TRUE))
      writexl::write_xlsx(table_df, path = save_path)
    } else {
      stop("Invalid `file_format`. Choose 'html' or 'excel'.")
    }
  }
  
  return(table)
}





########## TableOne: I want to use the function TableOne, but i want to assist it by sorting out problematic
# variables 
# and split the variable to be categorical or continuous based on their datatype 