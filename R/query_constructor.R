#' Query Constructor: A Flexible Query Builder for R
#' 
#' @description 
#' Build SQL queries dynamically with support for selecting columns, filtering, joining tables, and limiting results. 
#' 
#' @details
#' This functinos allow the user to build simple queries from .... 
#' 
#' 
#' @param tables A character string specifying the main table to query.
#' @param vars A character vector of column names to select (default is "*").
#' @param filters A character vector of conditions to apply in the WHERE clause.
#' @param join_method A character string specifying the type of join (e.g., "INNER JOIN"). Default is NULL (no join).
#' @param joins_tables A character vector with two table names for the join. Required if `join_method` is specified.
#' @param join_id A character string specifying the column name used for the join condition. Required if `join_method` is specified.
#' @param limit An integer specifying the maximum number of rows to return. Default is NULL (no limit).
#' @param format A logical value indicating whether to format the SQL query for readability (default is TRUE).
#' 
#' @return A SQL query string.
#' 
#' @examples
#' query <- query_constructor(
#'   tables = "sim_av_patient",
#'   vars = c("name", "age"),
#'   filters = c("age > 30"),
#'   join_method = "INNER JOIN",
#'   joins_tables = c("sim_av_patient", "sim_av_tumour"),
#'   join_id = "patientid",
#'   limit = 100
#' )
#' 
#' @export


query_constructor <- function(
    tables,
    vars = "*",
    filters = NULL,
    join_method = NULL,
    joins_tables = NULL,
    join_id = NULL,
    limit = NULL
    ) {
  if (!is.character(tables) || length(tables) != 1) {
    stop("`tables` must be a single string representing the main table name.")
  }
  if (!is.character(vars) || length(tables) != 1) {
    stop("`vars` must be a single string representing the main table name.")
  }
  if (!is.character(filters) || length(tables) != 1) {
    stop("`filters` must be a single string representing the main table name.")
  }
  if (!is.character(join_method) || length(tables) != 1) {
    stop("`join_method` must be a single string representing the main table name.")
  }
  if (!is.character(joins_tables) || length(tables) != 1) {
    stop("`joins_tables` must be a single string representing the main table name.")
  }
  if (!is.character(join_id) || length(tables) != 1) {
    stop("`join_id` must be a single string representing the main table name.")
  }
  if (!is.character(limit) || length(tables) != 1) {
    stop("`limit` must be a single string representing the main table name.")
  }
  
  if (!is.null(join_method)) {
    valid_methods <- c("INNER JOIN", "OUTER JOIN", "LEFT JOIN", "RIGHT JOIN", "FULL JOIN")
    if (!join_method %in% valid_methods) {
      stop("Invalid `join_method`. Use one of: ", paste(valid_methods, collapse = ", "))
    }
    if (is.null(joins_tables) || length(joins_tables) != 2) {
      stop("`joins_tables` must contain exactly two table names when using `join_method`.")
    }
    if (is.null(join_id)) {
      stop("`join_id` must be provided when using `join_method`.")
    }
  }
  
  select_query <- paste("SELECT", paste(vars, collapse = ", "))
  
  from_query <- paste("FROM", tables)
  
  join_query <- if (!is.null(join_method)) {
    paste(
      join_method, joins_tables[2],
      "ON", paste0(joins_tables[1], ".", join_id), "=", paste0(joins_tables[2], ".", join_id)
    )
  } else {
    ""
  }
  
  where_query <- if (!is.null(filters)) {
    paste("WHERE", paste(filters, collapse = " AND "))
  } else {
    ""
  }
  
  limit_query <- if (!is.null(limit)) {
    paste("LIMIT", limit)
  } else {
    ""
  }
  
  query <- paste(
    select_query,
    from_query,
    join_query,
    where_query,
    limit_query,
    sep = "\n"
  )
  
  query <- trimws(query)
  query <- gsub("\n+", "\n", query) 
  query <- gsub(" +", " ", query)  

  query <- paste0(query, ";") 

  return(query)
}
