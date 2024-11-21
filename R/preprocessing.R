table_sample <- function(df, n = 1000) {
  df[sample(nrow(df), size = n, replace = FALSE), ]
}




###########################
### Lars code work on it ##
###########################
sact_2 <- sact_1 |> 
  mutate(ip = as.numeric(substr(PRIMARY_DIAGNOSIS, 2, 3)),
         diag = case_when(ip %in% c(47, 69:72)       ~ "Eye, brain and CNS",
                          ip %in% c(50)              ~ "Breast",
                          ip %in% c(51:58)           ~ "Gynaecological",
                          ip %in% c(0:14, 30:32)     ~ "Head and Neck",
                          ip %in% c(18:21)           ~ "Lower gastrointestinal",
                          ip %in% c(33:34, 37:39,45) ~ "Lung and bronchus",
                          ip %in% c(15:17, 22:25)    ~ "Upper gastrointestinal",
                          ip %in% c(60:68)           ~ "Urology",
                          ip %in% c(43:44)           ~ "Skin",
                          ip %in% c(81:86, 90:96)    ~ "Haematologic",
                          TRUE                       ~ "Ill-defined and unspecified")) |> 
  filter(diag != "Haematologic", 
         !is.na(MERGED_TUMOUR_ID), 
         substr(PRIMARY_DIAGNOSIS, 1, 1) == "C", 
         AGE >= 18)

sact_3 <- sact_2 |> 
  group_by(PATIENTID) |> 
  mutate(trial_all = any(CLINICAL_TRIAL %in% c("y", "Y","01","1"))) |> #We assume the following, y,Y,01,1 are indicators for clinical trial
  summarize(across(everything(), first))

sact_4 <- sact_3 |> 
  filter(SEX %in% c(1,2)) %>% 
  mutate(sex_group = if_else(SEX == 2, "Female", "Male"), 
         age_group = case_when(between(AGE, 18, 44)  ~ "18-44",
                               between(AGE, 45, 64)  ~ "45-64",
                               between(AGE, 65, 74)  ~ "65-74",
                               between(AGE, 75, 130) ~ "> 75"),
         seps = if_else(QUINTILE_2015 == "5 - most deprived", "vulnerable", "non-vulnerable"),
         year = year(DIAGNOSISDATEBEST),
         tnm = substr(STAGE_BEST, 0, 1),
         tnm = case_when(tnm == "1" ~ "I",
                         tnm == "2" ~ "II",
                         tnm == "3" ~ "III",
                         tnm == "4" ~ "IV",
                         TRUE ~ "Not recorded"),
         ACE27 = if_else(ACE27 == 9 | is.na(ACE27), "Not recorded", as.character(substr(ACE27,0,1))),
         com = as.factor(ACE27),
         Total = "total")

