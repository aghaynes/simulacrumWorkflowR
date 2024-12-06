#' System logger and timer logger
#'
#' @description
#' This function logs the execution time and system information of a given function. It's designed to be used as a wrapper around other functions to track performance and identify potential bottlenecks.
#'
#' @param func The function to be logged.
#' @param ... Additional arguments to be passed to the `func`.
#'
#' @return The return value of the `func`.
#'
#' @examples
#' # Example function
#' my_function <- function(x) {
#'   Sys.sleep(2)
#'   return(x^2)
#' }
#'
#' # Log the execution of my_function
#' result <- logger(my_function, 5)
#' print(result)
#'
#' @export
#' @importFrom tictoc tic toc
#' @importFrom logger log_info log_warn log_error

# tbh
logger <- function() {}


class(print)
