#' Compute and Check Execution Time Against a Limit
#'
#' @description
#' Calculates the execution time between given start and end times and checks if it exceeds a 3-hour limit.
#' Returns a message indicating whether the execution time was within the limit or exceeded it.
#'
#' @details
#' This time calculation function is implemented in the package because there is a 3-hour time limit for running analyses on NHS servers.
#' To help users estimate the runtime of their analyses, this function can be incorporated into their code.
#'
#' To use this function, place two time variable functions, `start_time()` and `end_time()`, which are `POSIXct` objects, 
#' at the beginning and end of your script, respectively. You can also use these functions to 
#' test the runtime of specific sections of your script. This function uses the `lubridate` package 
#' to calculate the time difference.
#'
#' The function provides messages to inform the user whether the 3-hour runtime has been exceeded.
#'
#' A warning message reminds users that analysis times on local machines and NHS servers are likely different.
#' However, even with potential time differences, the function provides a guide for time management and a reminder of the limitations of using NHS servers.
#'
#' @param start_time A `POSIXct` object representing the start time.
#' @param end_time A `POSIXct` object representing the end time.
#'
#' @return A character string containing the total execution time and the result (accepted or rejected).
#'         If the time exceeds 3 hours, a warning is issued.
#' @export
#'
#' @examples
#' start <- start_time()
#' # ... your code ...
#' end <- end_time()
#' compute_time_limit(start, end)


compute_time_limit <- function(start_time, end_time, save_to_file = FALSE, file_path = "execution_time_log.txt") {
  if (!requireNamespace("lubridate", quietly = TRUE)) {
    install.packages("lubridate")
  }
  library(lubridate)
    if (!inherits(start_time, "POSIXct") || !inherits(end_time, "POSIXct")) {
    stop("start_time and end_time must be of class POSIXct.")
  }
  
  execution_time <- as.duration(end_time - start_time)
  
  if (execution_time > hours(3)) {
    message <- sprintf(
      "Total Execution Time: %s\nAnalysis rejected! Exceeds the three-hour threshold of NHS.",
      as.character(execution_time)
    )
    warning(message)
  } else {
    message <- sprintf(
      "Total Execution Time: %s\nAnalysis accepted! It is within the three-hour threshold set by the NHS.",
      as.character(execution_time)
    )
    warning("Please note that the processing power of NHS servers and your local machine may vary significantly. As a result, the time required to run your analysis may differ. Please anticipate potential variations in runtime between the two environments.")
  }
  
  if (save_to_file) {
    writeLines(message, con = file_path)
  }
  
  return(message)
}



#' Record the Current Start Time
#'
#' @description
#' Captures the current system time to be used as the start time for timing execution.
#'
#' @return A `POSIXct` object representing the current system time.
#' @export
#'
#' @examples
#' start <- current_start_time()

start_time <- function() {
  return(Sys.time())
}

#' Record the Current End Time
#'
#' @description
#' Captures the current system time to be used as the end time for timing execution.
#'
#' @return A `POSIXct` object representing the current system time.
#' @export
#'
#' @examples end_time() 

end_time <- function() {
  return(Sys.time())
}

