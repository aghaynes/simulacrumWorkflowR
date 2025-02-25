#' Translate SQLite to Oracle-Compatible Queries
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
#' 
#' 
#' @return A string containing the translated Oracle-compatible query.
#' 
#' @export
#' 
#' @examples
#' sqlite_query <- "select * from sim_av_patient where age > 50 limit 500;"
#' oracle_query <- sqlite2oracle(sqlite_query)

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
    
    query <- trimws(query)
    if (!grepl(";$", query)) {
      query <- paste0(query, ";")
    }
    
    return(query)
}

