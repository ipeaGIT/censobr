library(arrow)
library(duckdb)
library(censobr)
library(dplyr)

df <- censobr::read_mortality(year = 2010)



# dplyr
df |>
  filter(code_muni == 1100015) |>
  collect()


# duckdb + dplyr
df |>
  to_duckdb() |>
  filter(sql("code_muni == 1100015")) |>
  collect()

df |>
  to_duckdb() |>
  filter(sql("abbrev_state == 'RJ'")) |>
collect()


df |>
  duckdb:::sql("abbrev_state == 'RJ'")

duckplyr::as_duckplyr_df()

# duckdb + sql
db_tbl <-  df |>
  to_duckdb(table_name = "mortality_2010_tbl")

con <- db_tbl$src$con
DBI::dbGetQuery(con, "SELECT * FROM 'mortality_2010_tbl' LIMIT 100")


