source("preprocessing.R")

library(sqldf)
library(tcltk)

dir <- "C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/"

# Reading the csv files
sim_av_patient <- read.csv(paste0(dir, "sim_av_patient.csv"))
sim_av_tumour <- read.csv(paste0(dir, "sim_av_tumour.csv"))
sim_av_gene <- read.csv(paste0(dir, "sim_av_gene.csv"))
sim_rtds_combined <- read.csv(paste0(dir, "sim_rtds_combined.csv"))
sim_sact_outcome <- read.csv(paste0(dir, "sim_sact_outcome.csv"))
sim_sact_regimen <- read.csv(paste0(dir, "sim_sact_regimen.csv"))
sim_sact_cycle <- read.csv(paste0(dir, "sim_sact_cycle.csv"))
sim_sact_drug_detail <- read.csv(paste0(dir, "sim_sact_drug_detail.csv"))

sql_sim_av_patient <- table_sample(sim_av_patient)
sql_sim_av_tumour <- table_sample(sim_av_patient)
sql_sim_av_gene <- table_sample(sim_av_gene)


sql_sim_sact_outcome <- table_sample(sim_sact_outcome)
sql_sim_sact_cycle <- table_sample(sim_sact_cycle)
sql_sim_sact_regimen <- table_sample(sim_sact_regimen)
sql_sim_sact_drug_detail <- table_sample(sim_sact_drug_detail)

sql_sim_rtds_combined <- table_sample(sim_rtds_combined)

sql_sim_av_patient
sql_sim_av_tumour

join_string <- "
SELECT *
FROM sql_sim_av_patient
INNER JOIN sql_sim_av_tumour ON sql_sim_av_patient.patientid = sql_sim_av_tumour.patientid
INNER JOIN sql_sim_av_gene ON sql_sim_av_tumour.patientid = sql_sim_av_gene.patientid;
"

# Resultant data frame
full_av <- sqldf(join_string, 
                            stringsAsFactors = FALSE)
head(full_av)
colnames(full_av)


# Test queries 
join_string <- "
SELECT *
FROM sql_sim_sact_regimen
INNER JOIN sql_sim_sact_outcome ON sql_sim_sact_regimen.merged_regimen_id = sql_sim_sact_outcome.merged_regimen_id
INNER JOIN sql_sim_sact_cycle ON sql_sim_sact_regimen.merged_regimen_id = sql_sim_sact_cycle.merged_regimen_id
INNER JOIN sql_sim_sact_drug_detail ON sql_sim_sact_cycle.merged_cycle_id = sql_sim_sact_drug_detail.merged_cycle_id;

"

# Resultant data frame
full_sact <- sqldf(join_string, 
                            stringsAsFactors = FALSE)
head(full_sact)
colnames(full_sact)




# Test queries 
join_string2 <- "
SELECT *
FROM sql_sim_av_patient
INNER JOIN sql_sim_av_tumour ON sql_sim_av_patient.patientid = sql_sim_av_tumour.patientid
INNER JOIN sql_sim_av_gene ON sql_sim_av_tumour.patientid = sql_sim_av_gene.patientid
INNER JOIN sql_sim_sact_regimen ON sql_sim_av_patient.patientid = sql_sim_sact_regimen.encore_patient_id
INNER JOIN sql_sim_sact_outcome ON sql_sim_sact_regimen.merged_regimen_id = sql_sim_sact_outcome.merged_regimen_id
INNER JOIN sql_sim_sact_cycle ON sql_sim_sact_regimen.merged_regimen_id = sql_sim_sact_cycle.merged_regimen_id
INNER JOIN sql_sim_sact_drug_detail ON sql_sim_sact_cycle.merged_cycle_id = sql_sim_sact_drug_detail.merged_cycle_id
INNER JOIN sql_sim_rtds_combined ON sql_sim_av_patient.patientid = sql_sim_rtds_combined.patientid;
"

# Resultant data frame
full_data <- sqldf(join_string2, 
                            stringsAsFactors = FALSE)
colnames(full_data)


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
  '
SELECT *
FROM sql_sim_av_patient
INNER JOIN sim_av_tumour ON sim_av_patient.patientid = sim_av_tumour.patientid
INNER JOIN sim_av_gene ON sim_av_tumour.patientid = sim_av_gene.patientid
INNER JOIN sim_sact_regimen ON sim_av_patient.patientid = sim_sact_regimen.encore_patient_id
INNER JOIN sim_sact_outcome ON sim_sact_regimen.merged_regimen_id = sim_sact_outcome.merged_regimen_id
INNER JOIN sim_sact_cycle ON sim_sact_regimen.merged_regimen_id = sim_sact_cycle.merged_regimen_id
INNER JOIN sim_sact_drug_detail ON sim_sact_cycle.merged_cycle_id = sim_sact_drug_detail.merged_cycle_id
INNER JOIN sim_rtds_combined ON sim_av_patient.patientid = sim_rtds_combined.patientid;
'
}
