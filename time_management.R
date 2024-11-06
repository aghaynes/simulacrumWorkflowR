compute_time_limit <- function(x)
{
  execution_time <- end_time - start_time
  if (execution_time > hours(3)) {
    print(cat("Total Execution Time:", execution_time, "\n"))
    print("Analysis rejected! Exceeds 3 hours")
  } else {
    print(execution_time)
    print("Analysis successful")
  }
}
