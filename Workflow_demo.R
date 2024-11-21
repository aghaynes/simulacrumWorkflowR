# Record the start time
start_time <- Sys.time()

source("R/preprocessing.R")
source("R/SQL_queries.R")
source("R/time_management.R")



dir <- "C:/Users/p90j/Desktop/Jakob/Data/Simulacrum/simulacrum_v2.1.0/Data/"
data_frames <- read_all_csv(dir) 


sim_av_patient <- data_frames$sim_av_patient
sim_av_tumour <- data_frames$sim_av_tumour
sim_av_gene <- data_frames$sim_av_gene


query <- query_constructor(tables = "sim_av_tumour", 
                          vars = c("patientid", "gender", "AGE"), 
                        filters = c("age > 50"),
                        limit = c("50"))

query

df <- sql_test(query)

table_query_list()


query1 <- query_constructor(
  tables = "sim_av_patient",
  join_method = "INNER JOIN",
  join_id = "patientid",
  joins_tables = list(
    list("sim_av_patient", "sim_av_tumour")
  )
)
query1
df1 <- sql_test(query1)
df1



query2 <- "select patientid, gender, AGE \n from sim_av_tumour \n  \n where age > 50 \n LIMIT 50"

query3 <- sqlite2oracle(query2)

query3

end_time <- Sys.time()
compute_time_limit(execution_time)