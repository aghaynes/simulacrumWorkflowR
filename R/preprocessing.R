library(dplyr)

table_sample <- function(df, n = 1000) {
  df[sample(nrow(df), size = n, replace = FALSE), ]
}



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

group_by_age <- function(df, age = "AGE") {
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


group_ethnicity <- function(df) {
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




extended_summary <- function(df) {
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
#' This function calculates the number of days between the diagnosis date 
#' and the vital status date for each row in the data frame. 
#'
#' @param df A data frame containing the necessary columns: 'DIAGNOSISDATEBEST', 
#' 'VITALSTATUSDATE', and 'VITALSTATUS'.
#'
#' @return The input data frame with an additional column 'date_diff', 
#' representing the number of days between 'DIAGNOSISDATEBEST' and 'VITALSTATUSDATE'.
#' @export
#'
#' @examples
#' # Assuming you have a merged dataset `merged_data`
#' survival_days(merged_data)
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
