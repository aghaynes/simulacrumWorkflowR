# Load the necessary package
if (!requireNamespace("lubridate", quietly = TRUE)) {
  install.packages("lubridate")
}
library(lubridate)

compute_time_limit <- function(x)
{
  execution_time <- end_time - start_time
  if (execution_time > hours(3)) {
    print(cat("Total Execution Time:", execution_time, "\n"))
    print("Analysis rejected! Exceeds 3 hours")
  } else {
    print(execution_time, "from the start of the analysis to the end")
    print("Analysis successful")
  }
}
