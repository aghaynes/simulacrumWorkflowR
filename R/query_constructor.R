############ Optimize #############
#' Helper Function for Building Queries 
#' 
#' @description 
#' This function helps to construct queries by feeding adding the names and conditinos. 
#' 
#' @example 
#'query1 <- query_constructor(
#'tables = "sim_av_patient",
#'join_method = "INNER JOIN",
#'join_id = "patientid",
#'joins_tables = list(
#'"sim_av_patient", "sim_av_tumour")
#')

query_constructor <- function(tables, vars = "*", filters = NULL, join_method = NULL, joins_tables = NULL, join_id = NULL, limit = NULL) {
  # Validate inputs
  if (!is.character(tables) || length(tables) != 1) {
    stop("`tables` must be a single string representing the table name.")
  }
  
  if (!is.null(join_method)) {
    valid_methods <- c("INNER JOIN", "OUTER JOIN", "LEFT JOIN", "RIGHT JOIN", "FULL JOIN")
    if (!join_method %in% valid_methods) {
      stop(paste("Invalid join method provided. Please use one of the following:", paste(valid_methods, collapse = ", ")))
    }
    if (is.null(joins_tables) || is.null(join_id)) {
      stop("`joins_tables` and `join_id` must be provided when using `join_method`.")
    }
  }
  
  # SELECT clause
  select_query <- paste("SELECT", paste(vars, collapse = ", "))
  
  # FROM clause
  from_query <- paste("FROM", tables)
  
  # JOIN clause
  join_query <- if (!is.null(join_method)) {
    paste(join_method, joins_tables[2], "ON", paste0(joins_tables[1],".",join_id), "=", paste0(joins_tables[2], ".", join_id))
  } else {
    ""
  }
  
  # WHERE clause
  where_query <- if (!is.null(filters)) {
    paste("WHERE", paste(filters, collapse = " AND "))
  } else {
    ""
  }
  
  # LIMIT clause
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
  
  query <- paste0(query, ";")
  
  #query <- writeLines(query)
  
  return(query)
}
