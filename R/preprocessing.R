#' Create a representative sample of 1000 rows from a dataset
#'
#' @param data A data frame to sample from
#' @param stratify A character vector of column names to stratify by (optional)
#' @param seed An integer for setting the random seed (optional, default is NULL)
#'
#' @return A data frame with 1000 rows representing a sample of the original dataset
#' @export
create_sample <- function(data, stratify = NULL, seed = NULL) {

  # Set random seed if provided
  if (!is.null(seed)) {
    set.seed(seed)
  }

  # Check if stratification is requested
  if (!is.null(stratify)) {
    # Stratified sampling
    sample_data <- data %>%
      group_by(across(all_of(stratify))) %>%
      sample_n(size = 1000 / n_distinct(across(all_of(stratify))), replace = TRUE) %>%
      ungroup()
  } else {
    # Random sampling if no stratification
    sample_data <- data %>%
      sample_n(size = 1000, replace = TRUE)
  }

  return(sample_data)
}
