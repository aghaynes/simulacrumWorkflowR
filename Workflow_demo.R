source("R/preprocessing.R")
source("R/data_col2.R")
source("R/sql_queries.R")
source("R/query_constructor.R")
source("R/time_management.R")
source("R/sqldf.R")
source("R/sqlite2oracle.R")
source("R/workflow_generator.R")
start <- start_time()

dir <- "C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/"
# Automated data loading 
data_frames_lists <- read_csv(dir) 

#dfs
sim_av_patient <- data_frames_lists$sim_av_patient
sim_av_tumour <- data_frames_lists$sim_av_tumour
sim_av_gene <- data_frames_lists$sim_av_gene

sim_av_tumour
#Preprocessing
df <- cancer_grouping(sim_av_tumour)
df <- group_age(df) 
df <- group_ethnicity(sim_av_patient)
extended_summary(sim_av_tumour)


# See list of queries for merging
table_query_list()

# Query Constructor for merge
query1 <- query_constructor(
  tables = "sim_av_patient",
  join_method = "INNER JOIN",
  join_id = "patientid",
  joins_tables = list(
    "sim_av_patient", "sim_av_tumour")
  )

query1 <- "SELECT * FROM sim_av_patient"
create_workflow(analysis <- {model <- glm(Y ~ X1 + x2, data=data)}) 

query <- 

# Run query on SQLite database
df1 <- sql_test("SELECT *
FROM sim_av_patient
INNER JOIN sim_av_tumour ON sim_av_patient.patientid = sim_av_tumour.patientid;")

survival_days <- function(df, sim_av_patient = NULL, sim_av_tumour = NULL) {
  # Check if the input is a data frame
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame.")
  }
  
  # Required columns
  required_columns <- c("DIAGNOSISDATEBEST", "VITALSTATUSDATE", "VITALSTATUS")
  
  # Check for required columns
  if (!all(required_columns %in% colnames(df))) {
    if (is.null(sim_av_patient) || is.null(sim_av_tumour)) {
      stop(paste(
        "The input data frame is missing required columns and",
        "either `sim_av_patient` or `sim_av_tumour` is not provided.",
        "Required columns:",
        paste(required_columns, collapse = ", ")
      ))
    }
    
    # Attempt to merge the provided data frames
    message("Merging `sim_av_patient` and `sim_av_tumour`...")
    merged_df <- merge(sim_av_patient, sim_av_tumour, by = "common_id", all = TRUE)
    
    # Check again for required columns after merging
    if (!all(required_columns %in% colnames(merged_df))) {
      stop(paste(
        "After merging, the required columns are still missing:",
        paste(setdiff(required_columns, colnames(merged_df)), collapse = ", ")
      ))
    }
    
    # Use the merged dataframe for further processing
    df <- merged_df
  }
  
  # Ensure date columns are properly formatted
  df$DIAGNOSISDATEBEST <- as.Date(df$DIAGNOSISDATEBEST)
  df$VITALSTATUSDATE <- as.Date(df$VITALSTATUSDATE)
  
  # Calculate date differences
  df$diff_date <- as.numeric(df$VITALSTATUSDATE - df$DIAGNOSISDATEBEST)
  df$date_to_death <- ifelse(df$VITALSTATUS == "D", df$diff_date, NA)
  
  return(df)
}


# Additional preprocessing
df2 <- survival_days(df1)

# ... run analysis

# Save results as a html table 
#html_table(model)

query2 <- "select *
from sim_av_patient
limit 500;"

sqlite2oracle(query2)

create_workflow(
                             libraries = {
                                                                                  library(dplyr)},
                             query = "select * 
                             from sim_av_patient
                             where age > 50
                             limit 500;",
                             data_management = {
                             # Run query on SQLite database
                              cancer_grouping(sim_av_tumour)

                              # Additional preprocessing
                              #df2 <- survival_days(df1)
                              },
                             analysis = 
                                                                  {model = glm(x ~ x1 + x2 + x3, data=data)},
                             model_results = {html_table_model(model)})

# End timer and calculate execution time 
end <- end_time()
compute_time_limit(start, end)