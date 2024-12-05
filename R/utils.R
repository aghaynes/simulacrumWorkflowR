av_patient_tumour_merge <- function(df1 = sim_av_patient, df2 = sim_av_patient){
  message("Merging `sim_av_patient` and `sim_av_tumour`...")
  merged_df <- merge(df1, df2, by = "PATIENTID", all = TRUE) 
  return(merged_df)
}
