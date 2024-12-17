#' Merge of patient and tumour df
#' 
#' @description
#' A simple merge function for gathering the two dataframes .... 
#' 
#' @param df1 a dataframe to be merged with df2. df1 is default set to `sim_av_patient`.
#' @param df2 a dataframe to be merged with df1. df2 is default set to `sim_av_tumour`.
#' 
#' @importFrom simulacrumR log_func
#' 
#' @return a merged dataframe
#' 
#' @export


av_patient_tumour_merge <- function(df1 = sim_av_patient, df2 = sim_av_tumour){
  log_func(function() {
  message("Merging `sim_av_patient` and `sim_av_tumour`...")
  merged_df <- merge(df1, df2, by = "PATIENTID", all = TRUE) 
  return(merged_df)
  })
}



#' Generate an Extended Summary of a Data Frame
#'
#' @description
#' Summarizes a data frame, including missing values, unique values, and column classes.
#'
#' @param df A data frame to summarize.
#' 
#' @importFrom simulacrumR log_func
#'
#' @return A data frame summarizing:
#' - Column names
#' - Number of missing values
#' - Number of unique values
#' - Data class of each column
#' @export
#' 
#' @examples 
#' summary_df <- extended_summary(sim_av_patient)

extended_summary <- function(df) { ######### Optimize -  add more to the columns 
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame.")
  }
  df_summary <- data.frame(
    Columns = colnames(df),
    Missing_Values = sapply(df, function(x) sum(is.na(x))),
    Unique_Values = sapply(df, function(x) length(unique(x))),
    Class = sapply(df, class)
  )
  return(df_summary)
}


#' Creating a Dir if there is None
#' 
#' @param dir the direction to the folder 
#' 
#' @importFrom simulacrumR log_func
#' 
#' @return folder 
#' 
#' @export

create_dir_if_none <- function(dir) {
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
}

# Make it to work with tab_model, tableOne, dfs, etc. 
# add example in vignette

#' Generate a HTML or XLSX table for regressions or dataframes
#' 
#' @description
#' tbh
#' 
#' @param tbh tbh
#' 
#' @return tbh
#' 
#' @export

#Save_results <- function(functions = NULL, file_path = NULL, )


