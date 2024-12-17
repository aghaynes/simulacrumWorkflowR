library(simulacrumR)
report <- file('console_log_test.txt', open = 'wt')
sink(report ,type = 'output')
sink(report, type = 'message')


start <- start_time()

print('æg')

stop <- stop_time()
compute_time_limit(start, stop)
compute_time_limit

dir <- "C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/"
data_frames_lists <- read_simulacrum(dir, selected_files = c("sim_av_patient", "sim_av_tumour")) 

#dfs
sim_av_patient <- data_frames_lists$sim_av_patient
sim_av_tumour <- data_frames_lists$sim_av_tumour
#sim_av_gene <- data_frames_lists$sim_av_gene
#sim_rtds_combined <- data_frames_lists$sim_rtds_combined
#sim_rtds_episode <- data_frames_lists$sim_rtds_episode
#sim_rtds_exposure <- data_frames_lists$sim_rtds_exposure
#sim_rtds_prescription <- data_frames_lists$sim_rtds_prescription
#sim_sact_cycle <- data_frames_lists$sim_sact_cycle
#sim_sact_drug_detail <- data_frames_lists$sim_sact_drug_detail
#sim_sact_outcome <- data_frames_lists$sim_sact_outcome
#sim_sact_regimen <- data_frames_lists$sim_sact_regimen



#Preprocessing
df <- cancer_grouping(sim_av_tumour)
df <- group_ethnicity(sim_av_patient)
extended_summary(sim_av_tumour)


# Run query on SQLite database
df1 <- sql_test("SELECT *
FROM sim_av_patient
INNER JOIN sim_av_tumour ON sim_av_patient.patientid = sim_av_tumour.patientid;")

merged_df <- av_patient_tumour_merge(sim_av_patient, sim_av_tumour)


# Additional preprocessing
df2 <- survival_days(merged_df)

query2 <- "select *
from sim_av_patient
limit 500;"

sqlite2oracle(query2)

create_workflow(
  libraries = "              library(dplyr)",
  query = "                  select * from sim_av_patient
                             where age > 50
                             limit 500;",
  data_management = "         # Run query on SQLite database
                              cancer_grouping(sim_av_tumour)

                              # Additional preprocessing
                              #df2 <- survival_days(df1)
                              ",
  analysis = "                model = glm(x ~ x1 + x2 + x3, data=data)",
  model_results = "html_table_model(model)")

# End timer and calculate execution time 


sink()
sink()