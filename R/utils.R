#' Merge of patient and tumour df
#' 
#' @description
#' A simple merge function for gathering the two dataframes .... 
#' 
#' @param df1 a dataframe to be merged with df2. df1 is default set to `sim_av_patient`.
#' @param df2 a dataframe to be merged with df1. df2 is default set to `sim_av_tumour`.
#' 
#' 
#' @return a merged dataframe
#' 
#' @export


av_patient_tumour_merge <- function(df1 = sim_av_patient, df2 = sim_av_tumour){
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

extended_summary <- function(df) {
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

