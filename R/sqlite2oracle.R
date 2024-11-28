#sqlite2oracle <- function(query) {
#  if (!is.character(query)) stop("Please make sure input query is a string")
#  
#  keywords <- c("SELECT", "FROM", "WHERE", "INNER", "OUTER", "JOIN", "RIGHT", "LEFT")
#  for (keyword in keywords) {
#    query <- gsub(keyword, toupper(keyword), query, ignore.case = TRUE)
#  }
#  
#  # Translate "LIMIT"
#  query <- gsub("LIMIT (\\d+)", "WHERE ROWNUM <= \\1", query, ignore.case = TRUE)
#  
#  return(query)
#}

sqlite2oracle <- function(query) {
  if (!is.character(query)) stop("Input query must be a string.")
  if (length(query) != 1) stop("Input query must be a single SQL string.")
  
  keyword_mappings <- list(
    "LIMIT" = function(x) gsub("LIMIT\\s+(\\d+)", "WHERE ROWNUM <= \\1", x, ignore.case = TRUE),
    "TEXT" = "VARCHAR2",
    "INTEGER" = "NUMBER",
    "REAL" = "FLOAT",
    "BLOB" = "BLOB"
  )
  
  standard_keywords <- c(
    "SELECT", "FROM", "WHERE", "INNER", "OUTER", "JOIN", "LEFT", "RIGHT", 
    "ORDER BY", "GROUP BY", "HAVING"
  )
  
  for (keyword in standard_keywords) {
    query <- gsub(paste0("\\b", keyword, "\\b"), toupper(keyword), query, ignore.case = TRUE)
  }
  
  for (key in names(keyword_mappings)) {
    value <- keyword_mappings[[key]]
    if (is.function(value)) {
      query <- value(query) # Apply function transformations
    } else {
      query <- gsub(paste0("\\b", key, "\\b"), value, query, ignore.case = TRUE)
    }
  }
  
  query <- gsub("\\s+", " ", query)
  query <- trimws(query)
  
  return(query)
}
