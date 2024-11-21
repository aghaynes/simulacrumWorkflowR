sqlite2oracle <- function(query) {
  if (!is.character(query)) stop("Please make sure input query is a string")
  
  keywords <- c("SELECT", "FROM", "WHERE", "INNER", "OUTER", "JOIN", "RIGHT", "LEFT")
  for (keyword in keywords) {
    query <- gsub(keyword, toupper(keyword), query, ignore.case = TRUE)
  }
  
  # Translate "LIMIT"
  query <- gsub("LIMIT (\\d+)", "WHERE ROWNUM <= \\1", query, ignore.case = TRUE)
  
  return(query)
}


