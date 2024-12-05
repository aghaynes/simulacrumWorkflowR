#' Random Sample of a Data Frame
#'
#' @description
#' Takes a random sample of rows from a data frame.
#'
#' @param df A data frame to sample from.
#' @param n An integer specifying the number of rows to sample. Default is 1000.
#'
#' @return A data frame containing the sampled rows.
#' @export
#' 
#' @examples 
#' sample_df <- table_sample(sim_av_patient, 500)

table_sample <- function(df, n = 1000) {
  df[sample(nrow(df), size = n, replace = FALSE), ]
}



#' Group Cancer Diagnoses by ICD-10 Codes
#'
#' @description
#' Groups cancer diagnoses into broader categories based on ICD-10 codes.
#'
#' @details
#' This function aggregates ICD-10 cancer codes into groups 
#' to simplify analyses. It covers common cancer groups and provides a default 
#' "Ill-defined and unspecified" category for unmatched codes.
#'
#' The ICD-10 ranges are derived from NHS guidelines. See the source for details:
#' <https://digital.nhs.uk/ndrs/data/data-outputs/cancer-data-hub/cancer-prevalence>.
#'
#' @param df A data frame containing a column `SITE_ICD10_O2_3CHAR` with ICD-10 codes.
#'
#' @return A data frame with an added column `diag_group` for the cancer category.
#' @export
#' 
#' @examples 
#' sim_av_tumour <- cancer_grouping(sim_av_tumour)

cancer_grouping <- function(df) {
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame.")
  }
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    install.packages("dplyr") 
  }
  df <- dplyr::mutate(df,
                      ip = as.numeric(substr(SITE_ICD10_O2_3CHAR, 2, 3)),
                      diag_group = dplyr::case_when(
                        ip %in% c(47, 69:72) ~ "Eye, brain and CNS",
                        ip %in% c(50) ~ "Breast",
                        ip %in% c(51:58) ~ "Gynaecological",
                        ip %in% c(0:14, 30:32) ~ "Head and Neck",
                        ip %in% c(18:21) ~ "Lower gastrointestinal",
                        ip %in% c(33:34, 37:39, 45) ~ "Lung and bronchus",
                        ip %in% c(15:17, 22:25) ~ "Upper gastrointestinal",
                        ip %in% c(60:68) ~ "Urology",
                        ip %in% c(43:44) ~ "Skin",
                        ip %in% c(81:86, 90:96) ~ "Haematologic",
                        TRUE ~ "Ill-defined and unspecified"
                      ),
                      diag_group = ifelse(substr(SITE_ICD10_O2_3CHAR, 1, 1) == "C", 
                                          diag_group, 
                                          "Other")
  )
  
  df <- dplyr::select(df, -ip)  
  
  return(df)
}

#' Group Ethnicity Categories
#'
#' @description
#' Maps ethnicity codes to broader categories.
#' 
#' @details
#' A function which can be used to map the 24 ethnicity code into 5 categories. The mapping for is based on the guide from NHS which is also the dataholders of the CAS database.
#' The source for the mapping can be found on this link: https://digital.nhs.uk/data-and-information/data-collections-and-data-sets/data-sets/mental-health-services-data-set/submit-data/data-quality-of-protected-characteristics-and-other-vulnerable-groups/ethnicity
#' 
#' @param df A data frame containing an `ETHNICITY` column with ethnicity codes.
#'
#' @return A data frame with an added column `Grouped_Ethinicity`.
#' @export
#' 
#' @example 
#' sim_av_patient <- group_ethnicity(sim_av_patient)

group_ethnicity <- function(df) {
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame.")
  }
  ethnicity_mapping <- c(
    "A" = "White", 
    "B" = "White", 
    "C" = "White", 
    "C2" = "White", 
    "C3" = "White",
    "CA" = "White", 
    "CB" = "White", 
    "CC" = "White", 
    "CD" = "White", 
    "CE" = "White",
    "CF" = "White", 
    "CG" = "White", 
    "CH" = "White", 
    "CJ" = "White", 
    "CK" = "White",
    "CL" = "White", 
    "CM" = "White", 
    "CN" = "White", 
    "CP" = "White", 
    "CQ" = "White",
    "CR" = "White", 
    "CS" = "White", 
    "CT" = "White", 
    "CU" = "White", 
    "CV" = "White",
    "CW" = "White", 
    "CX" = "White", 
    "CY" = "White", 
    "D" = "Mixed", 
    "E" = "Mixed",
    "F" = "Mixed", 
    "G" = "Mixed", 
    "GA" = "Mixed", 
    "GB" = "Mixed", 
    "GC" = "Mixed",
    "GD" = "Mixed", 
    "GE" = "Mixed", 
    "GF" = "Mixed", 
    "H" = "Asian", 
    "J" = "Asian",
    "K" = "Asian", 
    "L" = "Asian", 
    "LA" = "Asian", 
    "LB" = "Asian", 
    "LC" = "Asian",
    "LD" = "Asian", 
    "LE" = "Asian", 
    "LF" = "Asian", 
    "LG" = "Asian", 
    "LH" = "Asian",
    "LJ" = "Asian", 
    "LK" = "Asian", 
    "R" = "Asian", 
    "M" = "Black", 
    "N" = "Black", 
    "P" = "Black",
    "PA" = "Black", 
    "PB" = "Black", 
    "PC" = "Black", 
    "PD" = "Black", 
    "PE" = "Black",
    "S" = "Other", 
    "SA" = "Other", 
    "SB" = "Other", 
    "SC" = "Other",
    "SD" = "Other", 
    "SE" = "Other"
  )
  
  df$ETHNICITY <- as.character(df$ETHNICITY)
  
  df$Grouped_Ethinicity <- ethnicity_mapping[df$ETHNICITY]
  
  return(df)
}



#' Calculate Survival Days
#'
#'@description
#' This function calculates the number of days between the diagnosis date 
#' and the vital status date for each row in the data frame. 
#'
#'@details
#' This function helps the researchers who wants to survival analysis, by offering a fast a custombuilt function to compute the survial days between diagnosis day and day of death
#' The functions does ask the user to merge the two dataframe `sim_av_patient` and `sim_av_tumour` before the function can be used as the variables needed for the operations are split in between the two tables. 
#' 
#'
#' @param df A data frame containing the necessary columns: 'DIAGNOSISDATEBEST', 
#' 'VITALSTATUSDATE', and 'VITALSTATUS'.
#'
#' @return The input data frame with an additional column `date_diff`, 
#' representing the number of days between `DIAGNOSISDATEBEST` and `VITALSTATUSDATE`.
#' Also, a column called `date_to_death` which is the same column as `date_diff` but where the column `VITALSTATUS` is set to be equal to `D` which means death. 
#'   
#' @export
#' 
#' @example 
#' add_survival_merged_df <- survival_days(merged_df)

survival_days <- function(df) {              
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame.")
  }
  
  required_columns <- c("DIAGNOSISDATEBEST", "VITALSTATUSDATE", "VITALSTATUS")
  if (!all(required_columns %in% colnames(df))) {
    stop(paste(
      "The input data frame must contain the following columns:",
      paste(required_columns, collapse = ", "),
      message("Please make sure to merge 'sim_av_patient' and 'sim_av_tumour'"),
      message("Use the function 'df_merged <- av_patient_tumour_merge(sim_av_patient,sim_av_tumour)' to merge the dataframes")
    ))
  }
  
  df$diff_date <- as.numeric(as.Date(df$VITALSTATUSDATE) - as.Date(df$DIAGNOSISDATEBEST))
  df$date_to_death <- ifelse(df$VITALSTATUS == "D", df$diff_date, NA)

    return(df)
}
