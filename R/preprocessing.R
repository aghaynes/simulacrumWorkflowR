library(dplyr)

table_sample <- function(df, n = 1000) {
  df[sample(nrow(df), size = n, replace = FALSE), ]
}


###########################
### Lars code work on it ##
###########################


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

group_by_age <- function(df, age_column = "AGE") {
  if (age_column %in% names(df)) {
    df$Grouped_Age <- dplyr::case_when(
      dplyr::between(df[[age_column]], 18, 44)  ~ "18-44",
      dplyr::between(df[[age_column]], 45, 64)  ~ "45-64",
      dplyr::between(df[[age_column]], 65, 74)  ~ "65-74",
      dplyr::between(df[[age_column]], 75, 130) ~ "> 75",
      TRUE                                      ~ "Outside range"
    )
  } else {
    warning(paste("Column", age_column, "not found in the data frame."))
  }
  return(df)
}



