table_list <- function() {
  writeLines("
  sim_av_patient
  sim_av_tumour
  sim_av_gene
  sim_rtds_combined
  sim_sact_outcome
  sim_sact_regimen
  sim_sact_cycle
  sim_sact_drug_detail
             ")
}


read_all_csv <- function(dir) {
  if (!is.character(dir)) stop("Please make sure input dir is a string")
  
  print("Please wait. It can take a couple of minutes to upload all files.")
  
  
  data_list <- list(
    sim_av_patient = read.csv(paste0(dir, "sim_av_patient.csv")),
    print("sim_av_patient is uploaded"),
    sim_av_tumour = read.csv(paste0(dir, "sim_av_tumour.csv")),
    print("sim_av_tumour is uploaded"),
    sim_av_gene = read.csv(paste0(dir, "sim_av_gene.csv")),
    print("sim_av_gene is uploaded"), 
    sim_rtds_combined = read.csv(paste0(dir, "sim_rtds_combined.csv")),
    print("sim_rtds_combined is uploaded"), 
    sim_sact_outcome = read.csv(paste0(dir, "sim_sact_outcome.csv")),
    print("sim_sact_outcome is uploaded"), 
    sim_sact_regimen = read.csv(paste0(dir, "sim_sact_regimen.csv")),
    print("sim_sact_regimen is uploaded"),
    sim_sact_cycle = read.csv(paste0(dir, "sim_sact_cycle.csv")),
    print("sim_sact_cycle is uploaded"), 
    sim_sact_drug_detail = read.csv(paste0(dir, "sim_sact_drug_detail.csv")),
    print("sim_sact_drug_detail is uploaded"),
    print("All CSV files are successfully uploaded!")
  )
  
  
  
  return(data_list)
}

