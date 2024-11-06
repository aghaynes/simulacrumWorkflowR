source("preprocessing.R")
source("time_management.R")
source("SQL_queries.R")
# Record the start time
start_time <- Sys.time()



library(tidyverse)
library(skimr)
library(DataExplorer)
library(usethis)
library(devtools)

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


sim_av_patient_sample <- table_sample(sim_av_patient)
sim_sact_outcome_sample <- table_sample(sim_sact_outcome)
summary(sim_sact_outcome_sample)



colnames(sim_av_patient_sample)


glimpse(sim_av_patient_sample)


summary(sim_av_patient_sample)


skim(sim_av_patient_sample)



end_time <- Sys.time()
compute_time_limit(execution_time)

sql_sim_av_patient()
