source("R/preprocessing.R")

library(sqldf)
library(tcltk)

dir <- "C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/"

read_all_csv <- function(dir)
{
  print("Please wait. It can take a couple of minutes to upload all files ")
  sim_av_patient <- read.csv(paste0(dir, "sim_av_patient.csv"))
  print("sim_av_patient is uploaded")
  sim_av_tumour <- read.csv(paste0(dir, "sim_av_tumour.csv"))
  print("sim_av_tumours is uploaded")
  sim_av_gene <- read.csv(paste0(dir, "sim_av_gene.csv"))
  print("sim_av_gene is uploaded")
  sim_rtds_combined <- read.csv(paste0(dir, "sim_rtds_combined.csv"))
  print("sim_rtds_combined is uploaded")
  sim_sact_outcome <- read.csv(paste0(dir, "sim_sact_outcome.csv"))
  print("sim_sact_outcome is uploaded")
  sim_sact_regimen <- read.csv(paste0(dir, "sim_sact_regimen.csv"))
  print("sim_sact_regimen is uploaded")
  sim_sact_cycle <- read.csv(paste0(dir, "sim_sact_cycle.csv"))
  print("sim_sact_cycle is uploaded")
  sim_sact_drug_detail <- read.csv(paste0(dir, "sim_sact_drug_detail.csv"))
  print("sim_sact_drug_detail is uploaded")
  print("All CSV files is succesfully uploaded!")
  
}

read_all_csv("C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/")



sql_sim_av_patient <- table_sample(sim_av_patient)
sql_sim_av_tumour <- table_sample(sim_av_tumour)
sql_sim_av_gene <- table_sample(sim_av_gene)


sql_sim_sact_outcome <- table_sample(sim_sact_outcome)
sql_sim_sact_cycle <- table_sample(sim_sact_cycle)
sql_sim_sact_regimen <- table_sample(sim_sact_regimen)
sql_sim_sact_drug_detail <- table_sample(sim_sact_drug_detail)

sql_sim_rtds_combined <- table_sample(sim_rtds_combined)

sql_sim_av_patient
sql_sim_av_tumour


########## sql_test setup ###########
sql_test <- function(query) {
  sqldf(query, stringsAsFactors = FALSE)
}

sql_test("SELECT PATIENTID, GENDER, AGE 
 FROM sql_sim_av_tumour 
  
 WHERE age > 50")

sql_test("SELECT sql_sim_av_tumour.PATIENTID, sql_sim_av_patient.ETHNICITY 
 FROM sql_sim_av_tumour 
 INNER JOIN sql_sim_av_patient ON sql_sim_av_tumour.PATIENTID = sql_sim_av_patient.PATIENTID")


###### Test sql builder #######
query_constructor <- function(tables, vars = "*", filters = NULL, joins = NULL) {
  # SELECT
  select_query <- paste("SELECT", paste(vars, collapse = ", "))
  
  # FROM
  from_query <- paste("FROM", tables)
  
  # JOIN
  join_query <- if (!is.null(joins)) {
    paste(joins, collapse = " ")
  } else {
    ""
  }
  
  # FILTERS
  where_query <- if (!is.null(filters)) {
    paste("WHERE", paste(filters, collapse = " AND "))
  } else {
    ""
  }
  
  # Combine all clauses
  query <- paste(select_query, '\n',
                 from_query, '\n',
                 join_query, '\n',
                 where_query) 
  
  # Print the formatted query
  writeLines(query)
}


query1 <- query_constructor(tables = "sql_sim_av_tumour", 
                            vars = c("PATIENTID", "GENDER", "AGE"), 
                            filters = c("age > 50"))


query2 <- query_constructor(
  table = "sql_sim_av_tumour",
  vars = c("sql_sim_av_tumour.PATIENTID", "sql_sim_av_patient.ETHNICITY"),
  joins = c("INNER JOIN sql_sim_av_patient ON sql_sim_av_tumour.PATIENTID = sql_sim_av_patient.PATIENTID"),
  
)



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



###### Test sql builder #######
query_constructor <- function(tables, vars = "*", filters = NULL, joins = NULL) {
  # SELECT
  select_query <- paste("SELECT", paste(vars, collapse = ", "))
  
  # FROM
  from_query <- paste("FROM", tables)
  
  # JOIN
  join_query <- if (!is.null(joins)) {
    paste(joins, collapse = " ")
  } else {
    ""
  }
  
  # FILTERS
  where_query <- if (!is.null(filters)) {
    paste("WHERE", paste(filters, collapse = " AND "))
  } else {
    ""
  }
  
  # Combine all clauses
  query <- paste(select_query, '\n',
                 from_query, '\n',
                 join_query, '\n',
                 where_query) 
  
  # Print the formatted query
  writeLines(query)
}


query1 <- query_constructor(tables = "sql_sim_av_tumour", 
                            vars = c("PATIENTID", "GENDER", "AGE"), 
                            filters = c("age > 50"))


query2 <- query_constructor(
  table = "sql_sim_av_tumour",
  vars = c("sql_sim_av_tumour.PATIENTID", "sql_sim_av_patient.ETHNICITY"),
  joins = c("INNER JOIN sql_sim_av_patient ON sql_sim_av_tumour.PATIENTID = sql_sim_av_patient.PATIENTID"),

)




############ Setup a database function to run queries in R ################
# Just make the sqldf function up as a function with the sql query builder 






