#' Random Sample of a Data Frame
#'
#' @description
#' Takes a random sample of rows from a data frame.
#'
#' @param df A data frame to sample from.
#' @param n The number of rows to sample. Default is 1000.
#'
#' @return A data frame containing the sampled rows.
#' @export
#' 
#' @example 
#' sample_df <- table_sample(sim_av_patient, 500)

table_sample <- function(df, n = 1000) {
  df[sample(nrow(df), size = n, replace = FALSE), ]
}


#' Group Cancer Diagnoses by cancer ICD-10 codes 
#'
#' @description
#' Groups cancer diagnoses into broader categories based on ICD-10 codes.
#' 
#' @details
#' This function is a common method used for analysis of cancer datasets. As there are many cancer codes to cover most aspect of subcancer types, it can be hard to make any useful analysis of the data. 
#' This function groups the cancer codes of the ICD10 codes into some aggregated categories. 
#' For the Simulacrum dataset, most of the cancers can be found within some ranges, with some exceptions. Alternatively can these ranges be mapped. 
#' Source for cancer codes: https://digital.nhs.uk/ndrs/data/data-outputs/cancer-data-hub/cancer-prevalence
#' 
#'
#' @param df A data frame with a column `SITE_ICD10_O2_3CHAR` containing ICD-10 codes.
#'
#' @return A data frame with an added column `diag_group` for the cancer category.
#' @export
#' 
#' @example 
#' sim_av_tummour <- cancer_grouping(sim_av_tumour)

library(dplyr)
cancer_grouping <- function(df) {
  df %>%
    mutate(
      ip = as.numeric(substr(SITE_ICD10_O2_3CHAR, 2, 3)),
      diag_group = case_when(
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
    ) %>%
    select(-ip)  # Remove the temporary 'ip' column
}



#' Group Ages into five intervals
#'
#' @description
#' Groups ages into ranges.
#' 
#' @details
#' This function is a common grouping method to make age categories. This is also to decrease the complexity of the analysis compared to using the full age column. 
#' ###### Additionally can the parameter `NN` be used to decide the ranges of the users.
#'
#' @param df A data frame containing an age column.
#' @param age The name of the age column. Default is `AGE`.
#' @param ranges Add customisable ranges. 
#'
#' @return A data frame with an added column `Grouped_Age`.
#' @export
#' 
#' @example 
#' sim_av_patient <- group_age(sim_av_patient)

group_age <- function(df, age = "AGE") { # Add a parameter to change the ranges. 
  if (age %in% names(df)) {
    df$Grouped_Age <- dplyr::case_when(
      dplyr::between(df[[age]], 18, 44)  ~ "18-44",
      dplyr::between(df[[age]], 45, 64)  ~ "45-64",
      dplyr::between(df[[age]], 65, 74)  ~ "65-74",
      dplyr::between(df[[age]], 75, 130) ~ "> 75",
      TRUE                                      ~ "Outside range"
    )
  } else {
    warning(paste("Column", age, "not found in the data frame."))
  }
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

group_ethnicity <- function(df) { # Optimze code with ranges and a argument pointing to the ethnicity column
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



#' Generate an Extended Summary of a Data Frame
#'
#' @description
#' Creates a summary of a data frame, including the number of missing values, unique values, and class of each column.
#' 
#' @details
#' This function helps by providing a dataframe of information about the chosen dataframe. The function provides an overview of: 
#' - 1) The amount of the missing for each column of the columns in the dataframe 
#' - 2) The amount of unique values of the columns in the dataframe  
#' - 3) The classes of each of the columns in the dataframe 
#'
#' @param df A data frame to summarize.
#'
#' @return A data frame with the summary statistics.
#' @export
#' 
#' @example 
#' extended_summary(df)

extended_summary <- function(df) { # Optimize function
  df_sum <- data.frame(
    Columns = colnames(df),
    Missings_val = sapply(df, function(x) sum(is.na(x))),
    Unique_val = sapply(df, function(x) length(unique(x))),
    Class_val = sapply(df, class)
  )
  print(df_sum)
  return(df_sum)
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
  message("Please make sure to merge 'sim_av_patient' and 'sim_av_tumour'")
  
  required_columns <- c("DIAGNOSISDATEBEST", "VITALSTATUSDATE", "VITALSTATUS")
  if (!all(required_columns %in% colnames(df))) {
    stop(paste(
      "The input data frame must contain the following columns:",
      paste(required_columns, collapse = ", ")
    ))
  }
  
  df$DIAGNOSISDATEBEST <- as.Date(df$DIAGNOSISDATEBEST)
  df$VITALSTATUSDATE <- as.Date(df$VITALSTATUSDATE)
  
  df$diff_date <- difftime(df$VITALSTATUSDATE, df$DIAGNOSISDATEBEST, units = "days")
  df$date_to_death <- ifelse(df$VITALSTATUS == "D", df$diff_date, NA)
  
  return(df)
}
