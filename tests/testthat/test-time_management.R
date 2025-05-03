library(testthat)
library(lubridate)

compute_time_limit <- function(start_time, end_time, time_limit_hours = 3, save_to_file = TRUE, 
                               file_path = "execution_time_log.txt", output_dir = "./Outputs") {
  execution_time <- as.duration(as.numeric(difftime(end_time, start_time, units = "secs")))
  
  time_limit <- duration(hours = time_limit_hours)
  
  if (execution_time > time_limit) {
    message_text <- sprintf(
      "Total Execution Time: %s\nAnalysis rejected! Exceeds the three-hour threshold of NHS.",
      as.character(execution_time)
    )
    
    warning(message_text)
  } else {
    message_text <- sprintf(
      "Total Execution Time: %s\nAnalysis accepted! It is within the three-hour threshold set by the NHS.",
      as.character(execution_time)
    )
    message(message_text)
    warning("Please note that the processing power of NHS servers and your local machine may vary significantly. As a result, the time required to run your analysis may differ. Please anticipate potential variations in runtime between the two environments.")
    warning("Please also take into account the time required for the NDRS analyst to process the workflow request and produce anonymous outputs.")
  }
  
  if (save_to_file) {
    create_dir(output_dir)
    
    full_file_path <- file.path(output_dir, file_path)
    
    tryCatch({
      writeLines(message_text, con = full_file_path)
      message(paste("Log saved to:", full_file_path))
    }, error = function(e) {
      warning(paste("Failed to write log file:", e$message))
    })
  }
  
  result <- list(
    execution_time = execution_time,
    time_limit_hours = time_limit_hours,
    message = message_text
  )
  
  return(result)
}



start_time <- function() {
  return(Sys.time())
}



stop_time <- function() {
  return(Sys.time())
}


##################################################################
############## Test if the print and time log works ##############
##################################################################
test_that("compute_time_limit correctly identifies time within limit and produces expected output", {
  start_t <- ymd_hms("2023-01-01 10:00:00")
  end_t <- ymd_hms("2023-01-01 10:15:00")
  

  result <- expect_message({
    expect_warning({ 
      expect_warning({ 
        compute_time_limit(start_time = start_t, end_time = end_t, save_to_file = FALSE)
      }, regexp = "Please note that the processing power") 
    }, regexp = "Please also take into account") 
  }, regexp = "Total Execution Time") 
  
  expected_message_part <- "Analysis accepted! It is within the three-hour threshold set by the NHS."
  
  expect_true(grepl(expected_message_part, result$message))
})

##################################################################
############## Test if the time measure works  ###################
##################################################################
test_that("start_time and stop_time accurately capture time difference", {
  sleep_duration_secs <- 2 
  
  start_t <- start_time()
  
  Sys.sleep(sleep_duration_secs)
  
  end_t <- stop_time()
  
  measured_duration_secs <- as.numeric(difftime(end_t, start_t, units = "secs"))
  
  expect_equal(measured_duration_secs, sleep_duration_secs, tolerance = 0.5) 
})
