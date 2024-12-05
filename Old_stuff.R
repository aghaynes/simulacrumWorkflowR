#' Group Ages into Intervals
#'
#' @description
#' Groups ages into certain intervals.
#'
#' @details
#' This function provides a common grouping method to create age categories, 
#' and reducing the complexity of analysis compared to using raw age data. 
#' There is both default and custom age ranges. 
#' The last range extends to 130 to capture all possible ages, 
#' For simplicity are the last range, which are suppose to capture the remaining ages above a certain threshold, labelled as `range[1]` and ">"
#'
#' @param df A data frame containing an age column.
#' @param age The name of the age column. Default is `"AGE"`.
#' @param range1 A numeric vector of length 2 defining the lower and upper bounds of the first age range. Default is `c(18, 44)`.
#' @param range2 A numeric vector of length 2 defining the lower and upper bounds of the second age range. Default is `c(45, 64)`.
#' @param range3 A numeric vector of length 2 defining the lower and upper bounds of the third age range. Default is `c(65, 74)`.
#' @param range4 A numeric vector of length 2 defining the lower and upper bounds of the final age range. Default is `c(75, 130)`.
#'
#' @return A data frame with an added column `Grouped_Age`.
#' @export
#'
#' @examples
#' # Sample data frame
#' sim_av_patient <- data.frame(AGE = c(25, 50, 68, 80, 15))
#' 
#' # Group ages using default ranges
#' sim_av_patient <- group_age(sim_av_patient)
#' 
#' # Group ages using custom ranges
#' sim_av_patient <- group_age(sim_av_patient, 
#'                            range1 = c(0, 18), 
#'                            range2 = c(19, 64), 
#'                            range3 = c(65, 130))

group_age <- function(df, age = "AGE", range1 = c(18, 44), range2 = c(45, 64), range3 = c(65, 74), range4 = c(75, 130)) {
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame.")
  }
  if (!is.numeric(range1)) {
    stop("range1 must be numeric")
  }
  if (!is.numeric(range2)) {
    stop("range2 must be numeric")
  }
  if (!is.numeric(range3)) {
    stop("range3 must be numeric")
  }
  if (!is.numeric(range4)) {
    stop("range4 must be numeric")
  }
  if (age %in% names(df)) {
    df$Grouped_Age <- dplyr::case_when(
      dplyr::between(df[[age]], range1[1], range1[2]) ~ paste0(toString(range1[1]), "-", toString(range1[2])),
      dplyr::between(df[[age]], range2[1], range2[2]) ~ paste0(toString(range2[1]), "-", toString(range2[2])),
      dplyr::between(df[[age]], range3[1], range3[2]) ~ paste0(toString(range3[1]), "-", toString(range3[2])),
      dplyr::between(df[[age]], range4[1], range4[2]) ~ paste0(toString(range4[1]), ">"), 
      TRUE ~ "Outside range" 
    )
  }
  return(df)
}