
# Complete Workflow for NHS  
  
# logging ----------------------------------------------------------
start <- start_time()
report <- file('console_log_test.txt', open = 'wt')
sink(report ,type = 'output')
sink(report, type = 'message')

# Libraries ----------------------------------------------------------
library(knitr)
library(DBI)
library(odbc)
library(survival)
library(sjPlot)
library(sjmisc)
library(sjlabelled)

# ODBC --------------------------------------------------------------------
my_oracle <- dbConnect(odbc::odbc(),
                       Driver = "",
                       DBQ = "", 
                       UID = "",
                       PWD = "",
                       trusted_connection = TRUE)

# Query ----------------------------------------------------------
query1 <- "SELECT *
FROM sim_av_patient
INNER JOIN sim_av_tumour ON sim_av_patient.patientid = sim_av_tumour.patientid;"
data <- dbGetQuery(my_oracle, query1)

# Data Management ----------------------------------------------------------
df2 <- survival_days(df1)
df21 <- df2
df21$VITALSTATUS <- ifelse(df21$VITALSTATUS == "A", 1,
ifelse(df21$VITALSTATUS == "D", 0, NA))

# Analysis ----------------------------------------------------------
cox_model <- coxph(Surv(diff_date, VITALSTATUS) ~ AGE + factor(GENDER.x) + factor(PERFORMANCESTATUS), data=df21)
log_model <- glm(VITALSTATUS ~ AGE + factor(GENDER.x) + factor(PERFORMANCESTATUS), data=df21, family = "binomial")

# Model Results ----------------------------------------------------------
cox_model_sum <- tidy(cox_model)
write.xlsx(cox_model_sum, "cox_model.xlsx")
log_model_sum <- tidy(log_model)
write.xlsx(log_model_sum, "log_model.xlsx")

stop <- stop_time()
compute_time_limit(start, stop)
sink()
sink()
  
