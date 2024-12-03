#' Translate SQLite Queries to Oracle-Compatible Queries
#'
#' @description
#' This functions take a string as input, which is a SQLite query and transform it into a Oracle compatible query string
#' 
#' @details
#' This function takes a string as input, which are suppose to be the queries from the SQLite database interaction. 
#' The function have two parts.
#' 
#' 1) It takes the keywords used in SQL queries and make sure they are upper. 
#' This is due to Oracle being strict to the keywords being upper whereas SQLite can take both upper and lower letters
#' 
#' 2) Transform the keyword `LIMIT` into the keyword `ROWNUM <=`
#' There is added a if statement which will add `WHERE` in front of `ROWNUM` is there is no where in the query input.
#' If there is a `WHERE` in the input query, `AND` will be incerted in front of `ROWNUM`
#' 
#' Please note that there are a more two simple and common query corrections in the code. 
#' There are a lot more differencies between the queries of SQLite and Oracle. 
#' However, the purpose of this package is merely to write as little sql as possible and keep the data management in R.
#' This function is not consider as a necessity for the advantage database user, as they are likely to know the difference on their own.
#' 
#' If more query translation could be beneficial, we welcome pull requests! 
#' 
#' @param query A string containing the SQLite query to be translated.
#' @return A string containing the translated Oracle-compatible query.
#' @examples
#' sqlite_query <- "select * from sim_av_patient where age > 50 limit 500;"
#' oracle_query <- sqlite2oracle(sqlite_query)
#' print(oracle_query) 

sqlite2oracle <- function(query) {
  if (!is.character(query)) stop("Please make sure input query is a string")
  
  # Convert main SQL keywords to uppercase
  keywords <- c("SELECT", "FROM", "WHERE", "INNER", "OUTER", "JOIN", "RIGHT", "LEFT", "ORDER BY", "GROUP BY", "HAVING")
  for (keyword in keywords) {
    query <- gsub(keyword, toupper(keyword), query, ignore.case = TRUE)
  }
  
  chech_for_where <- grepl("\\bWHERE\\b", query, ignore.case = TRUE)
  
  if (chech_for_where) {
    query <- gsub("LIMIT\\s+(\\d+)", "AND ROWNUM <= \\1", query, ignore.case = TRUE)
  } else {
    query <- gsub("LIMIT\\s+(\\d+)", "WHERE ROWNUM <= \\1", query, ignore.case = TRUE)
  }
  
  query <- trimws(query)
  if (!grepl(";$", query)) {
    query <- paste0(query, ";")
  }
  
  return(query)
}