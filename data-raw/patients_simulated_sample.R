# Generates simulated tumour data (random_tumour_data) for package examples.
# Data is based on Simulacrum's structure but is entirely random.
# Saves output to inst/extdata/minisimulacrum/random_patient_data.Rda

set.seed(2025)

num_rows <- 10

generated_patientid <- 1:num_rows

generated_vitalstatusdate <- rep(as.Date("2022-12-12"), num_rows)

generated_deathcausecode <- rep("c50", num_rows)

status_pool <- c("A", "D")
status_probabilities <- c(0.9, 0.1)
generated_vitalstatus <- sample(status_pool, num_rows, replace = TRUE, prob = status_probabilities)

generated_ethnicity <- rep("D", num_rows)

random_patient_data <- data.frame(
  PATIENTID = generated_patientid,
  VITALSTATUSDATE = generated_vitalstatusdate,
  DEATHCAUSECODE_1A = generated_deathcausecode,
  VITALSTATUS = generated_vitalstatus,
  ETHNICITY = generated_ethnicity 
)

sim_data_dir <- "C:/Users/p90j/Documents/simulacrumWorkflowR/inst/extdata/minisimulacrum/random_patient_data.Rda"

save(random_patient_data, file = sim_data_dir)