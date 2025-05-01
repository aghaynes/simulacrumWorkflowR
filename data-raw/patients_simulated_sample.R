# Generates simulated tumour data (random_tumour_data) for package examples.
# Data is based on Simulacrum's structure but is entirely random.
# Saves output to inst/extdata/minisimulacrum/random_tumour_data.csv

set.seed(2025)

num_rows <- 10

generated_patientid <- 1:num_rows

generated_vitalstatusdate <- rep(as.Date("2022-12-12"), num_rows)

generated_deathcausecode <- rep("c50", num_rows)

status_pool <- c("A", "D")
status_probabilities <- c(0.9, 0.1)
generated_vitalstatus <- sample(status_pool, num_rows, replace = TRUE, prob = status_probabilities)

random_patient_data <- data.frame(
  patientid = generated_patientid,
  vitalstatusdate = generated_vitalstatusdate,
  deathcausecode_1a = generated_deathcausecode,
  vitalstatus = generated_vitalstatus
)

sim_data_dir <- "C:/Users/p90j/Documents/simulacrumWorkflowR/inst/extdata/minisimulacrum/random_patient_data.csv" 

save(random_patient_data, file = sim_data_dir)