#' System logger and timer logger
#'
#' @description
#' This function logs the execution time and system information of a given function, using the `logger` package for flexible logging.
#'
#' @param func The function to be logged.
#' @param log_file The name of the log file.
#' @param verbose If TRUE, prints log messages to the console.
#' @param log_level The log level to use (e.g., "INFO", "WARN", "ERROR").
#'
#' @return The result of the function `func`.
#'
#' @export
#' @importFrom lubridate duration
#' @importFrom simulacrumR start_time stop_time
#' @importFrom logger log_info log_warn log_error

log_func <- function(func, log_file = "detailed_log.txt") {
  start <- start_time()
  result <- tryCatch(func(), error = function(e) {
    log_error(paste0("Error in ", deparse(substitute(func)), ": ", e$message))
    stop(e)
  })
  stop <- stop_time()
  
  elapsed_time <- as.duration(stop - start)
  print(as.character(elapsed_time))
  
  log_message <- paste0("Function: ", deparse(substitute(func)), "\n",
                        "Elapsed time: ", as.character(elapsed_time), " seconds\n")
  

  log_info(log_message)
  
  cat(log_message, file = log_file, append = TRUE)
  
  return(result)
}

