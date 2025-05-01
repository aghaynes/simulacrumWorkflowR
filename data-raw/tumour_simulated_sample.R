# Generates simulated patient data (random_patient_data) for package examples.
# Data is based on Simulacrum's structure but is entirely random.
# Saves output to inst/extdata/minisimulacrum/random_patient_data.csv

set.seed(2025)

num_rows <- 10

generated_patientid <- 1:num_rows
generated_tumourid <- 1:num_rows
generated_er_status <- 1:num_rows

generated_diagnosisdatebest <- rep(as.Date("2014-12-12"), num_rows)

site_codes_o2 <- c('C50','C53','C54','C55','C56','C50','C53','C54','C55','C56')
generated_site_icd10_o2 <- site_codes_o2

generated_site_icd10_o2_3char <- substr(generated_site_icd10_o2, 1, 3)

perf_status_pool <- c(0, 1, 2, 3) 
generated_performancestatus <- sample(perf_status_pool, num_rows, replace = TRUE)

generated_gender <- sample(c(1, 2), num_rows, replace = TRUE, prob = c(0.5, 0.5))

generated_age <- sample(30:90, num_rows, replace = TRUE)

generated_age[10] <- 34
generated_gender[10] <- 2

generated_laterality <- rep("9", num_rows) 

random_tumour_data <- data.frame(
  patientid = generated_patientid,
  diagnosisdatebest = generated_diagnosisdatebest,
  site_icd10_o2 = generated_site_icd10_o2,
  age = generated_age,
  site_icd10_o2_3char = generated_site_icd10_o2_3char,
  performancestatus = generated_performancestatus,
  gender = generated_gender,
  tumourid = generated_tumourid,
  er_status = generated_er_status,
  laterality = generated_laterality
)

sim_data_dir <- "C:/Users/p90j/Documents/simulacrumWorkflowR/inst/extdata/minisimulacrum/random_tumour_data.csv" 

save(random_tumour_data, file = sim_data_dir)