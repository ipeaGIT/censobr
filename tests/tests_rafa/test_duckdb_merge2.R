library(arrow)
library(duckdb)
library(duckplyr)
library(DBI)

# download parquet files
url1 <- 'https://github.com/ipeaGIT/censobr/releases/download/v0.2.0/2010_emigration_v0.2.0.parquet'
url2 <- 'https://github.com/ipeaGIT/censobr/releases/download/v0.2.0/2010_households_v0.2.0.parquet'
curl::curl_download(url = url1, destfile = 'temp_parquet1.parquet', quiet = F)
curl::curl_download(url = url2, destfile = 'temp_parquet2.parquet', quiet = F)

# open data sets
arrow1 <- arrow::open_dataset('temp_parquet1.parquet')
arrow2 <- arrow::open_dataset('temp_parquet2.parquet')


# simple function that emulates part of what I do in my package
merge_fun <- function(arrow1, arrow2){

  key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                'code_region', 'name_region', 'code_weighting', 'V0300')

  # drop repeated vars
  all_common_vars <- names(arrow1)[names(arrow1) %in% names(arrow2)]
  vars_to_drop <- setdiff(all_common_vars, key_vars)
  arrow2 <- dplyr::select(arrow2, -all_of(vars_to_drop)) |>
    dplyr::compute()

  # convert to duckdb
  # arrow1 <- arrow::to_duckdb(arrow1)
  # arrow2 <- arrow::to_duckdb(arrow2)

  # con <- DBI::dbConnect(duckdb::duckdb(), read_only = FALSE)
  con <- duckdb::dbConnect(duckdb::duckdb(), read_only = FALSE)
  duckdb::duckdb_register_arrow(con, 'arrow1', arrow1)
  duckdb::duckdb_register_arrow(con, 'arrow2', arrow2)


  # merge
  df_merge <- duckplyr::left_join(dplyr::tbl(con, "arrow1"),
                                  dplyr::tbl(con, "arrow2"))

  df_merge <- dplyr::compute(df_merge)

  df_merge <- arrow::to_arrow(df_merge)  |>
    dplyr::compute()

  # remove duckdb instance
  duckdb::duckdb_unregister_arrow(con, 'arrow1')
  duckdb::duckdb_unregister_arrow(con, 'arrow2')
  duckdb::dbDisconnect(con, shutdown = TRUE)
  # DBI::dbDisconnect(con, shutdown = TRUE)
  rm(con)
  gc()
  return(df_merge)
}

# run function
tictoc::tic()
test <- merge_fun( arrow1, arrow2)
tictoc::toc()
# 19.51    17.22 21.09 16.69

# try to remove file 1.
file.exists('temp_parquet1.parquet')
file.remove('temp_parquet1.parquet')

# remove file 2
file.exists('temp_parquet2.parquet')
file.remove('temp_parquet2.parquet')

