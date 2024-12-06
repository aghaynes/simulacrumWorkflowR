av_patient_tumour_merge <- function(df1 = sim_av_patient, df2 = sim_av_patient){
  message("Merging `sim_av_patient` and `sim_av_tumour`...")
  merged_df <- merge(df1, df2, by = "PATIENTID", all = TRUE) 
  return(merged_df)
}



#' Generate an Extended Summary of a Data Frame
#'
#' @description
#' Summarizes a data frame, including missing values, unique values, and column classes.
#'
#' @param df A data frame to summarize.
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
