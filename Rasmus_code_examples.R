df %>%
  mutate(
    ip = substr(SITE_ICD10_O2_3CHAR, 2, 3) %>% as.numeric(),
    
    diag_group = case_when(
      ip %in% c(47, 69:72) ~ "Eye, brain and CNS",
      ip %in% c(50)        ~ "Breast",
      ip %in% c(51:58)    ~ "Gynaecological",
      ip %in% c(0:14, 30:32) ~ "Head and Neck",
      ip %in% c(18:21) ~ "Lower gastrointestinal",
      ip %in% c(33:34, 37:39, 45) ~ "Lung and bronchus",
      ip %in% c(15:17, 22:25) ~ "Upper gastrointestinal",
      ip %in% c(60:68) ~ "Urology",
      ip %in% c(43:44) ~ "Skin",
      ip %in% c(81:86, 90:96) ~ "Haematologic",
      TRUE ~ "Ill-defined and unspecified"),
    
    AGe_grp = case_when(
      age<=30~"18-30",
      age<=40~"31-40",
      T~">40"
      
    )
    
    )


age_list <- list(c(18,30),c(31,40),c(41,80))

lengt_age <- length(age_list)

for (i in 1:lengt_age) {
  
}




library(survival)

ph <- c("1"="A",
  "2"="B",
  "0"="C"
  )

cancer$ph.ecog <- as.character(ph)


cancer$ecog_grp <- ph[cancer$ph.ecog]

cancer %>% select(ph.ecog,ecog_grp)


