source("preprocessing.R")


# Record the start time
start_time <- Sys.time()

# Load libraries
library(tidyverse)
library(skimr)
library(DataExplorer)
library(usethis)
library(devtools)

# Load data
sim_av_patients <- read.csv("C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/sim_av_patient.csv")
sim_av_tumour <- read.csv("C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/sim_av_tumour.csv")
sim_av_gene <- read.csv("C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/sim_av_gene.csv")
sim_sact_outcome <- read.csv("C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/sim_sact_outcome.csv")
sim_sact_regimen <- read.csv("C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/sim_sact_regimen.csv")
av_patients <- read.csv("C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/sim_av_patient.csv")

# Perform operations
colnames(sim_av_patients)
create_report(sim_av_patients)

data <- sim_av_patients

# Basic overview
glimpse(data)

# Summary statistics
summary(data)

# More detailed summary with `skimr`
skim(data)

# Record the end time
end_time <- Sys.time()

# Calculate and print the execution time
execution_time <- end_time - start_time
cat("Total Execution Time:", execution_time, "\n")


sim_av_patients_sample <- create_sample(sim_av_patients)
sim_av_patients_sample






