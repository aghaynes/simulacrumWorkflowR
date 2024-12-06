source("R/utils.R")

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
#' @param output_format description
#' 
#' @return a .html or .xlsx of the summary of a glm model presented as a table. 
#' The outputted file will be placed in a folder which can be named or created by the user,
#' but which will by default be placed where the package is installed and called results. 
#' 
#' @export
#' @imprtFrom sjPlot, writexl
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
    
    write_xlsx(data_out, full_path)
    message(sprintf("Results saved as Excel to: %s", full_path))
  }
  
}



#' Table one wrapper for making a table of patient charecteristics
#' 
#' @description
#' Creates a table over the patient characteristics and outputs it as either a .html of a .xlsx
#' 
#' @details
#' This function are handy when woring with simualcrum as it allows you to create a easy table of the patient charecteristics of the data. 
#' The user are able to create a table one where varibles can be selected and splitted into ordinary variables, factor variables stratified or inclusion of NA's.
#' 
#' The function is a using the the `tableone` package and which makes it ease to create a comprehensive table with a nice setup. 
#' All the params with their original description are included from the `tableone` package in this packages adaption, with the only difference being the option to save the tables locally as .html or .xlsx.
#' The option to save the files locally is important for executing the analysis on the CAS database. 
#' 
#' There are added additional code for this function which allows the user to save their table as either a .html or .xlsx. 
#' 
#' @inheritParams tableone::CreateTableOne
#' @param save_path A charecter string providing the direction for the table to be saved. The default value is `NULL` 
#' which results in the table will be saved where the package is located.
#' @param file_format A charecter string which can only take the inputs `html` or `xlsx` to decide if the table should be outputted as a .html or .xlsx. 
#' By default will the table be outputted as .html 
#' 
#' @return a html table or a xlsx table into a user specified folder. 
#' @export
#' 
#' @example 
#' create_summary_table(df_characteristics, vars = c("GENDER", "AGE", "CANCER_DIAG), strata = "GENDER", save_path = "path/to/folder/")

# Make a list over variables which may create problems 
if (!requireNamespace("tableone", quietly = TRUE)) {
  install.packages("tableone")
}
if (!requireNamespace("htmlTable", quietly = TRUE)) {
  install.packages("htmlTable")
}
if (!requireNamespace("writexl", quietly = TRUE)) {
  install.packages("writexl")
}


create_summary_table <- function(data, 
                                 vars, 
                                 factorVars, 
                                 strata = NULL, 
                                 includeNA = FALSE, 
                                 test = TRUE,
                                 testApprox = chisq.test,
                                 argsApprox = list(correct = TRUE),
                                 testExact = fisher.test,
                                 argsExact = list(workspace = 2 * 10^5),
                                 testNormal = oneway.test,
                                 argsNormal = list(var.equal = TRUE),
                                 testNonNormal = kruskal.test,
                                 argsNonNormal = list(NULL),
                                 smd = TRUE,
                                 addOverall = FALSE,
                                 save_path = NULL, 
                                 file_format = "html") {


  table <- CreateTableOne(
    data = data,
    vars = vars,
    factorVars,
    strata = strata,
    includeNA = includeNA,
    test = test,
    testApprox = testApprox,
    argsApprox = argsApprox,
    testExact = testExact,
    argsExact = argsExact,
    testNormal = testNormal,
    argsNormal = argsNormal,
    testNonNormal = testNonNormal,
    argsNonNormal = argsNonNormal,
    smd = smd,
    addOverall = addOverall
  )
  
  if (!is.null(save_path)) {
    if (file_format == "html") {
      html <- htmlTable::htmlTable(print(table, printToggle = TRUE))
      write(html, file = save_path)
    } else if (file_format == "excel") {
      table_df <- as.data.frame(print(table, printToggle = TRUE))
      write_xlsx(table_df, path = save_path)
    } else {
      stop("Invalid `file_format`. Choose 'html' or 'excel'.")
    }
  }
  
  return(table)
}


