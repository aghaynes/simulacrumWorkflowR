###### Test sql builder #######
query_constructor <- function(tables, vars = "*", filters = NULL, join_method = NULL, joins_tables = NULL, limit = NULL) {
  # SELECT
  select_query <- paste("SELECT", paste(vars, collapse = ", "))
  
  # FROM
  from_query <- paste("FROM", tables)
  
  join_method <- if (!is.null(join_method)){
    methods <- c("INNER JOIN", "OUTER JOIN", "LEFT JOIN", "RIGHT JOIN")
    
    if (!join_method%in%methods) {
      stop(paste("Invalid join method provided. Please use the following methods instead:",
                 paste(methods, collapse = ", ")
      ))
    }
    return(join_method)
  }
  
  # JOIN
  join_query <- if (!is.null(joins_table)) {
    paste(join_method, joins_tables, collapse = " ")  ##### Find a system for assisting joins across the tables
  } else {
    ""
  }
  
  # FILTERS
  where_query <- if (!is.null(filters)) {
    paste("WHERE", paste(filters, collapse = " AND "))
  } else {
    ""
  }
  
  limit_query <- if (!is.null(limit)) {
    paste("LIMIT", limit)
  } else {
    
  }
  
  # Combine all clauses
  query_space <- paste(select_query, '\n',
                       from_query, '\n',
                       join_query, '\n',
                       where_query, '\n',
                       limit_query) 
  
  
  query <- print(query_space)
  
  return(query)
}