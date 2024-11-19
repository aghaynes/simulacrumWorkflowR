source("R/preprocessing.R")

library(sqldf)
library(tcltk)



########## sql_test setup ###########
sql_test <- function(query) {
  sqldf(query, stringsAsFactors = FALSE)
}

#sql_test("SELECT PATIENTID, GENDER, AGE 
# FROM sim_av_tumour 
# WHERE age > 50")

#sql_test("SELECT PATIENTID, GENDER, AGE 
# FROM sim_av_tumour")


#sql_test("SELECT PATIENTID, GENDER, AGE 
# FROM sql_sim_av_tumour 
  
# WHERE age > 50
# limit 50")

#sql_test("SELECT sql_sim_av_tumour.PATIENTID, sql_sim_av_patient.ETHNICITY 
# FROM sql_sim_av_tumour 
# INNER JOIN sql_sim_av_patient ON sql_sim_av_tumour.PATIENTID = sql_sim_av_patient.PATIENTID")


###### Test sql builder #######
query_constructor <- function(tables, vars = "*", filters = NULL, join_method = NULL, joins_tables = NULL, limit = NULL) {
  # SELECT
  select_query <- paste("SELECT", paste(vars, collapse = ", "))
  
  # FROM
  from_query <- paste("FROM", tables)
  
  join_method <- if (!is.null(join_method)){
    methods <- c("INNER JOIN", "OUTER JOIN", "LEFT JOIN", "RIGHT JOIN")
    
    if (!join_method%in%methods) {
      stop(paste("Invalid join method provided. Please use the following methods instead:",
                 paste(methods, collapse = ", ")
      ))
    }
    return(join_method)
  }
  
  # JOIN
  join_query <- if (!is.null(joins_table)) {
    paste(join_method, joins_tables, collapse = " ")  ##### Find a system for assisting joins across the tables
  } else {
    ""
  }
  
  # FILTERS
  where_query <- if (!is.null(filters)) {
    paste("WHERE", paste(filters, collapse = " AND "))
  } else {
    ""
  }
  
  limit_query <- if (!is.null(limit)) {
    paste("LIMIT", limit)
  } else {
    
  }
  
  # Combine all clauses
  query_space <- paste(select_query, '\n',
                 from_query, '\n',
                 join_query, '\n',
                 where_query, '\n',
                 limit_query) 
  

  query <- print(query_space)
  
  return(query)
}


#query1 <- query_constructor(tables = "sql_sim_av_tumour", 
  #                          vars = c("PATIENTID", "GENDER", "AGE"), 
    #                        filters = c("age > 50"))


#query2 <- query_constructor(
#  table = "sql_sim_av_tumour",
#  vars = c("sql_sim_av_tumour.PATIENTID", "sql_sim_av_patient.ETHNICITY"),
#  joins = c("INNER JOIN sql_sim_av_patient ON sql_sim_av_tumour.PATIENTID = sql_sim_av_patient.PATIENTID"),
#  
#)



######## Single tables query ########## 


sql_sim_av_patient <- function()
{
  writeLines('SELECT
*
FROM
  sim_av_patient
        ')
}

sql_av_tumour_patient <- function()
{
  writeLines('SELECT
*
FROM
  sim_av_tumour
        ')
}

sql_sim_av_gene <- function()
{
  writeLines('SELECT
*
FROM
  sim_av_gene
        ')
}

sql_sim_rtds_combined <- function()
{
  writeLines('SELECT
*
FROM
  sim_rtds_combined
        ')
}

sql_sim_sact_outcome <- function()
{
  writeLines('SELECT
*
FROM
  sim_sact_outcome
        ')
}


sql_sim_sact_regimen <- function()
{
  writeLines('SELECT
*
FROM
  sim_sact_regimen
        ')
}


sql_sim_sact_cycle <- function()
{
  writeLines('SELECT
*
FROM
  sim_sact_cycle
        ')
}

sql_sim_sact_regimen <- function()
{
  writeLines('SELECT
*
FROM
  sim_sact_regimen
        ')
}

sql_full_av <- function()
{
  writeLines('
SELECT *
FROM sim_av_patient
FULL JOIN sim_av_tumour ON sim_av_patient.patientid = sim_av_tumour.patientid
FULL JOIN sim_av_gene ON sim_av_tumour.patientid = sim_av_gene.patientid;
')
}

sql_full_sact <- function()
{
  writeLines('
SELECT *
FROM sql_sim_sact_regimen
FULL JOIN sim_sact_outcome ON sim_sact_regimen.merged_regimen_id = sim_sact_outcome.merged_regimen_id
FULL JOIN sim_sact_cycle ON sim_sact_regimen.merged_regimen_id = sim_sact_cycle.merged_regimen_id
FULL JOIN sim_sact_drug_detail ON sim_sact_cycle.merged_cycle_id = sim_sact_drug_detail.merged_cycle_id;
')
}

sql_full_rtds <- function()
{
  writeLines('SELECT
*
FROM
  sim_rtds_combined
        ')
}

sql_full <- function()
{
  writeLines('SELECT *
FROM sql_sim_av_patient
INNER JOIN sim_av_tumour ON sim_av_patient.patientid = sim_av_tumour.patientid
INNER JOIN sim_av_gene ON sim_av_tumour.patientid = sim_av_gene.patientid
INNER JOIN sim_sact_regimen ON sim_av_patient.patientid = sim_sact_regimen.encore_patient_id
INNER JOIN sim_sact_outcome ON sim_sact_regimen.merged_regimen_id = sim_sact_outcome.merged_regimen_id
INNER JOIN sim_sact_cycle ON sim_sact_regimen.merged_regimen_id = sim_sact_cycle.merged_regimen_id
INNER JOIN sim_sact_drug_detail ON sim_sact_cycle.merged_cycle_id = sim_sact_drug_detail.merged_cycle_id
INNER JOIN sim_rtds_combined ON sim_av_patient.patientid = sim_rtds_combined.patientid;
')
}




