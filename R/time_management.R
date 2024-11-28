#' Compute and Check Execution Time Against a Limit
#'
#' @description
#' Calculates the execution time between a given start and end time and checks if it exceeds a 3-hour limit. 
#' Returns a message indicating whether the execution time was within the limit or exceeded it.
#'
#' @param start_time A `POSIXct` object representing the start time.
#' @param end_time A `POSIXct` object representing the end time.
#'
#' @return A character string containing the total execution time and the result (success or rejection).
#' If the time exceeds 3 hours, a warning is issued.
#' @export
#'
#' @examples
#' start_time()
#' ...
#' end_time()
#' compute_time_limit(start_time, end_time)
if (!requireNamespace("lubridate", quietly = TRUE)) {
  install.packages("lubridate")
}
if (!requireNamespace("tibble", quietly = TRUE)) {
  install.packages("tibble")
}

library(lubridate)
library(tibble)

compute_time_limit <- function(start_time, end_time) {
  if (!inherits(start_time, "POSIXct") || !inherits(end_time, "POSIXct")) {
    stop("start_time and end_time must be of class POSIXct.")
  }
  
  execution_time <- as.duration(end_time - start_time)
  
  if (execution_time > hours(3)) {
    message <- sprintf(
      "Total Execution Time: %s\n Analysis rejected! Exceeds the three hours threshold of NHS.",
      as.character(execution_time)
    )
    warning(message)
    return(message)
  } else {
    message <- sprintf(
      "Total Execution Time: %s \n Analysis accepted! It is within the three hour threshold set by the NHS",
      as.character(execution_time)
    )
    writeLines(message)
    #return(message)
    
    warning("Please note that the processing power of NHS servers and your local machine may vary significantly. As a result, the time required to run your analysis may differ. Please anticipate potential variations in runtime between the two environments.")
  }
}

#################################
###### Save log locally #########
#################################





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
#' @examples

end_time <- function() {
  return(Sys.time())
}

