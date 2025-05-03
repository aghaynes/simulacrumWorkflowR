library(testthat)

sqlite2oracle <- function(query) {
  if (!is.character(query)) stop("Please make sure input query is a string")
  
  # Convert main SQL keywords to uppercase
  keywords <- c("ADD", "ADD CONSTRAINT", "ALL", "ALTER", "ALTER", "ALTER TABLE", "AND", "ANY", "AS", "ASC", "BACKUP DATABASE", "BETWEEN CASE", "CHECK", "COLUMN", "CONSTRAINT",
                "CREATE", "CREATE DATABASE", "CREATE INDEX", "CREATE OR REPLACE VIEW", "CREATE TABLE", "CREATE PROCEDURE", "CREATE UNIQUE INDEX", "CREATE VIEW", "DATABASE",
                "DEFAULT", "DELETE", "DESC", "DISTINCT", "DROP", "DROP COLUMN", "DROP CONSTRAINT", "DROP DATABASE", "DROP DEFAULT", "DROP INDEX", "DROP TABLE", "DROP VIEW",
                "EXEC", "EXISTS", "FOREIGN KEY", "FROM", "FULL OUTER JOIN", "GROUP BY", "HAVING", "IN", "INDEX", "INNER JOIN", "INSERT INTO", "INSERT INTO SELECT", "IS NULL",
                "IS NOT NULL", "JOIN", "LEFT JOIN", "LIKE", "LIMIT", "NOT", "NOT NULL", "OR", "ORDER BY", "OUTER JOIN", "PRIMARY KEY", "PROCEDURE", "RIGHT JOIN", "ROWNUM",
                "SELECT", "SELECT DISTINCT", "SELECT INTO", "SELECT TOP", "SET", "TABLE", "TOP", "TRUNCATE TABLE", "UNION", "UNIQUE", "UPDATE", "VALUES", "VIEW", "WHERE")
  for (keyword in keywords) {
    query <- gsub(keyword, toupper(keyword), query, ignore.case = TRUE)
  }
  
  chech_for_where <- grepl("\\bWHERE\\b", query, ignore.case = TRUE)
  
  if (chech_for_where) {
    query <- gsub("LIMIT\\s+(\\d+)", "AND ROWNUM <= \\1", query, ignore.case = TRUE)
  } else {
    query <- gsub("LIMIT\\s+(\\d+)", "WHERE ROWNUM <= \\1", query, ignore.case = TRUE)
  }
  
  query <- gsub("\\bTRUE\\b", "1", query, ignore.case = TRUE)
  query <- gsub("\\bFALSE\\b", "0", query, ignore.case = TRUE)
  
  query <- trimws(query)
  if (!grepl(";$", query)) {
    query <- paste0(query, ";")
  }
  
  return(query)
}


test_that("sqlite2oracle converts a simple SELECT with LIMIT correctly", {
  sqlite_query <- "select * from MY_table limit 10"
  
  expected_oracle_query <- "SELECT * FROM MY_TABLE WHERE ROWNUM <= 10;"
  
  actual_oracle_query <- sqlite2oracle(sqlite_query)
  
  expect_equal(actual_oracle_query, expected_oracle_query)
})