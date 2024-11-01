library(tidyverse)
library(lubridate)
library(forestmodel)
library(broom)
library(knitr)
library(DBI)
library(odbc)

rf <- function(data, dig = 2) {
  format(round(data, digits = dig), nsmall = dig)
}

CC_calc <- function(df, columnName) {
  code_values <- c('01' = 1, '02' = 1, '03' = 1, '04' = 1, '05' = 1, '06' = 1,
                   '07' = 1, '08' = 1, '09' = 1, '10' = 2, '11' = 2, '12' = 2,
                   '13' = 2, '14' = 0, '15' = 1, '16' = 0, '17' = 3)
  df$com <- sapply(df[[columnName]], function(row) {
    if (is.null(row) || is.na(row)) {
      return(0)
    } else {
      codes <- unlist(strsplit(as.character(row), ","))
      
      if ("09" %in% codes && "10" %in% codes) {
        codes <- codes[codes != "09"]
      }
      if ("15" %in% codes && "17" %in% codes) {
        codes <- codes[codes != "15"]
      }
      
      sum(sapply(codes, function(code) {
        code_trimmed <- trimws(code)
        
        if (code_trimmed %in% names(code_values)) {
          return(code_values[[code_trimmed]])
        } else {
          return(0)
        }
      }))
    }
  })
  return(df)
}

# ODBC --------------------------------------------------------------------

my_oracle <- dbConnect(odbc::odbc(),
                       Driver = "Oracle in instantclient_21_12",
                       DBQ = "localhost:1521/XEPDB1", 
                       UID = "system",
                       PWD = "test1234",
                       trusted_connection = TRUE)

# In the following "DGPDB_INT.SIM_*" should be replaced with the schema name
# and correct table name

query1 <- "SELECT
  st.CLINICAL_TRIAL,
  st.ENCORE_PATIENT_ID,
  st.START_DATE_OF_REGIMEN
FROM
  DGPDB_INT.SIM_SACT_REGIMEN st"

query2 <- "SELECT
  at.PATIENTID,
  at.TUMOURID,
  at.DIAGNOSISDATEBEST,
  at.AGE, 
  at.GENDER,
  at.QUINTILE_2019,
  at.STAGE_BEST,
  at.COMORBIDITIES_27_03,
  at.SITE_ICD10_O2_3CHAR
FROM
  DGPDB_INT.SIM_AV_TUMOUR at"


sact_regimen <- dbGetQuery(my_oracle, query1)
av_tumour <- dbGetQuery(my_oracle, query2)