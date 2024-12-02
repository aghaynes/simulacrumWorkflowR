#' List of Available SQL Queries
#'
#' @description
#' Provides a list of SQL query-generating functions available in this package, each designed to print a query for a certain table or for joining a series of tables.
#'
#'@details
#' It is recommended to use SQL for either importing of the data of for merging some of the tables and importing.
#' To assist the user with little or no SQL query experience, these helping functions can provide with inspiration to either test the setup 
#' or to get started with data management. 
#'
#' @return A message listing the available SQL-generating functions.
#' @export
#'
#' @examples
#' table_query_list()

table_query_list <- function(){
  writeLines("Generate SQL query for a single table or a merge of tables by executing one of the following functions:
             sql_sim_av_patient()
             sql_av_tumour_patient()
             sql_sim_av_gene()
             sql_sim_rtds_combined()
             sql_sim_sact_outcome()
             sql_sim_sact_regimen()
             sql_sim_sact_cycle()
             sql_full_av()
             sql_full_sact()
             sql_full_rtds()
             sql_full()
             ")
}

#' Generate SQL Query for Individual Tables
#'
#' @description
#' Each of these functions generates an SQL query for selecting all rows from a certain table in the Simulacrum dataset.
#'
#' @return The SQL query as a printed string.
#' @examples
#' sql_sim_av_patient()
#' sql_av_tumour_patient()
#' sql_sim_av_gene()

sql_sim_av_patient <- function() {
  writeLines('SELECT * FROM sim_av_patient')
}

sql_av_tumour_patient <- function() {
  writeLines('SELECT * FROM sim_av_tumour')
}

sql_sim_av_gene <- function() {
  writeLines('SELECT * FROM sim_av_gene')
}

sql_sim_rtds_combined <- function() {
  writeLines('SELECT * FROM sim_rtds_combined')
}

sql_sim_sact_outcome <- function() {
  writeLines('SELECT * FROM sim_sact_outcome')
}

sql_sim_sact_regimen <- function() {
  writeLines('SELECT * FROM sim_sact_regimen')
}

sql_sim_sact_cycle <- function() {
  writeLines('SELECT * FROM sim_sact_cycle')
}

#' Generate SQL Query for Full Joins on small series of Tables 
#'
#' @description
#' These functions generate SQL queries for joining multiple tables within the categories of the Simulacrum, like av, rtds and sact. Also a full join of all the tables:
#'
#' @return The SQL query as a printed string.
#' @examples
#' sql_full_av()
#' sql_full_sact()
#' sql_full_rtds()
#' sql_full()

sql_full_av <- function() {
  writeLines('
SELECT *
FROM sim_av_patient
FULL JOIN sim_av_tumour ON sim_av_patient.patientid = sim_av_tumour.patientid
FULL JOIN sim_av_gene ON sim_av_tumour.patientid = sim_av_gene.patientid;
')
}

sql_full_sact <- function() {
  writeLines('
SELECT *
FROM sim_sact_regimen
FULL JOIN sim_sact_outcome ON sim_sact_regimen.merged_regimen_id = sim_sact_outcome.merged_regimen_id
FULL JOIN sim_sact_cycle ON sim_sact_regimen.merged_regimen_id = sim_sact_cycle.merged_regimen_id
FULL JOIN sim_sact_drug_detail ON sim_sact_cycle.merged_cycle_id = sim_sact_drug_detail.merged_cycle_id;
')
}

sql_full_rtds <- function() {
  writeLines('SELECT * FROM sim_rtds_combined')
}

sql_full <- function() {
  writeLines('
SELECT *
FROM sim_av_patient
INNER JOIN sim_av_tumour ON sim_av_patient.patientid = sim_av_tumour.patientid
INNER JOIN sim_av_gene ON sim_av_tumour.patientid = sim_av_gene.patientid
INNER JOIN sim_sact_regimen ON sim_av_patient.patientid = sim_sact_regimen.encore_patient_id
INNER JOIN sim_sact_outcome ON sim_sact_regimen.merged_regimen_id = sim_sact_outcome.merged_regimen_id
INNER JOIN sim_sact_cycle ON sim_sact_regimen.merged_regimen_id = sim_sact_cycle.merged_regimen_id
INNER JOIN sim_sact_drug_detail ON sim_sact_cycle.merged_cycle_id = sim_sact_drug_detail.merged_cycle_id
INNER JOIN sim_rtds_combined ON sim_av_patient.patientid = sim_rtds_combined.patientid;
')
}
