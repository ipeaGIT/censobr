#' Performs left_join with duckdb
#'
#' @param con A db connection
#' @param x String. Name of a table present in con
#' @param y String. Name of a table present in con
#' @param output_tb Name of the new table to be written in con
#' @param key_cols Vector. Vector with the names of columns to perform left join
#'
#' @return Writes the result of the left join as a new table in con
#'
#' @keywords internal
duckdb_left_join <- function(con, x, y, output_tb, key_cols){

  # x = 'df'
  # y = 'df_household'
  # output_tb = 'df_geo'
  # key_cols <- key_vars

  # Create dynamic ON condition for matching key columns between `x` and `y`
  match_conditions <- paste(
    paste0(x, ".", key_cols, " = ", y, ".", key_cols),
    collapse = " AND "
  )

  # Construct the SQL match query
  query_match_case <- sprintf("
  CREATE TEMPORARY TABLE %s AS
  SELECT *
  FROM %s
  LEFT JOIN %s
  ON %s;",
              output_tb,          # Name of output table
              x,                  # Left table
              y,                  # Right table
              match_conditions   # Dynamic matching conditions based on key columns
  )

  # parse(query_match_case)
  DBI::dbExecute(con, query_match_case)
}
