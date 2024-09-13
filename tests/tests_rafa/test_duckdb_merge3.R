como como fazer CON em pasta local, e nao na memoria ?
se fazer com  DBI, dá pra fechar o arquivo CON local?

library(censobr)
library(arrow)
library(DBI)
library(duckdb)
library(dbplyr)
library(dplyr)

# con <- DBI::dbConnect(duckdb::duckdb(), read_only = FALSE)
con <- duckdb::dbConnect(duckdb::duckdb(), read_only = FALSE, dbdir = "DBDIR_MEMORY")
duckdb::duckdb_register_arrow(con, 'arrow1', arrow1)
duckdb::duckdb_register_arrow(con, 'arrow2', arrow2)

arrow1_db <- dplyr::tbl(con, "arrow1")
arrow2_db <- dplyr::tbl(con, "arrow2")

t <- dplyr::left_join(
  x = arrow1_db,
  y = arrow2_db,
  by = key_vars
  )
t <- dplyr::compute(t)
ta <- arrow::to_arrow(t)


library(tictoc)


tic()
test <- censobr::read_mortality(year = 2010, merge_households = TRUE)
toc()
# original 19.67    17.7
# dplyr    24.87    21.29
# local    19.7



tic()
test <- censobr::read_emigration(year = 2010, merge_households = TRUE)
toc()
# original 13.07
# dplyr     17.7


class(test)
