coisas para testar

DBI pure
criar conexao sem ser com :memory: mas com disco local


#' benchmark
#' https://duckdblabs.github.io/db-benchmark/

#' example
#' https://github.com/Robinlovelace/spanishoddata/tree/main

library(DBI)
library(tictoc)
library(arrow)
library(dplyr)
devtools::load_all()

tic()
year = 2010
columns = NULL
add_labels = NULL
merge_households = FALSE
as_data_frame = FALSE
showProgress = TRUE
cache = TRUE

censobr::censobr_cache()
# censobr::censobr_cache(delete_file = 'all')


########## mortality data -----------------
### Get url
file_url <- paste0("https://github.com/ipeaGIT/censobr/releases/download/",
                   censobr_env$data_release, "/", year, "_mortality_",
                   censobr_env$data_release, ".parquet")


### Download
local_file <- download_file(file_url = file_url,
                            showProgress = showProgress,
                            cache = cache)

# check if download worked
if(is.null(local_file)) { return(invisible(NULL)) }

### read data
df <- arrow_open_dataset(local_file)


########## household data -----------------

# download household data
df_household <- censobr::read_households(year = year,
                                         add_labels = add_labels,
                                         as_data_frame = FALSE,
                                         showProgress = showProgress)

if (year == 2010) {
  key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                'code_region', 'name_region', 'code_weighting', 'V0300')

  # rename weight var
  df_household <- dplyr::rename(df_household, 'V0010_household' = 'V0010')
}


# drop repeated vars
all_common_vars <- names(df)[names(df) %in% names(df_household)]
vars_to_drop <- setdiff(all_common_vars, key_vars)
df_household <- dplyr::select(df_household, -all_of(vars_to_drop)) |>
  dplyr::compute()

toc()
gc()

# 14.21 sec elapsed













# ok duckplyr  -----------------------------------------
# pop 38.48 sec elapsed
# mor  9.66 sec elapsed

tic()
# convert to duckdb
df <- arrow::to_duckdb(df)
df_household <- arrow::to_duckdb(df_household)

# merge
df_geo <- dplyr::left_join(df, df_household)

# back to arrow
df_geo <- arrow::to_arrow(df_geo)
head(df_geo) |> collect()
toc()












# ok DBI + duckdb + dplyr  -----------------------------------------
# pop 99.26 sec elapsed
# mor 12.69 sec elapsed
tic()
# Create DuckDB connection
con <- DBI::dbConnect(duckdb::duckdb())

# Ensure the DuckDB connection is closed on function exit
# on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

# Register Arrow data as DuckDB tables
duckdb::duckdb_register_arrow(con, "df", df)
duckdb::duckdb_register_arrow(con, "df_household", df_household)

# Perform the left join using dplyr syntax
df_geo <- dplyr::left_join(tbl(con, "df"),
                    tbl(con, "df_household"),
                    by = key_vars)

# back to arrow
df_geo <- arrow::to_arrow(df_geo)

head(df_geo) |> collect()

DBI::dbDisconnect(con, shutdown = TRUE)
rm(con)
toc()





# ok arrow  -----------------------------------------
# pop ERROR
# mor ERROR
tic()
# merge
df_geo <- dplyr::left_join(df, df_household)

head(df_geo) |> collect()
toc()








# ??? duckdb + DBI::dbGetQueryArrow  -----------------------------------------
# pop
# mor 198.55 sec elapsed

tic()
# Create DuckDB connection
con <- DBI::dbConnect(duckdb::duckdb())

# Ensure the DuckDB connection is closed on function exit
# on.exit(DBI::dbDisconnect(con, shutdown = TRUE))

# Register Arrow data as DuckDB tables
duckdb::duckdb_register_arrow(con, "df", df)
duckdb::duckdb_register_arrow(con, "df_household", df_household)

query <- paste0(
  "SELECT df.*, df_household.* FROM df LEFT JOIN df_household ON ",
  paste(paste("df.", key_vars, " = df_household.", key_vars, sep = ""), collapse = " AND ")
)

# Execute the query
# df_geo <- DBI::dbSendQuery(con, query) # returns duckdb_result
# df_geo <- duckdb::dbSendQuery(con, query) # returns duckdb_result
df_geo <- DBI::dbGetQueryArrow(con, query) # returns nanoarrow_array_stream
df_geo <- arrow::as_arrow_table(df_geo)
head(df_geo) |> collect()

toc()


#  DBI pure  + sql-----------------------------------------


# Step 3: Connect to a DuckDB in-memory database
con <- DBI::dbConnect(duckdb::duckdb(), path = ":memory:", read_only = FALSE)

# Step 4: Register the datasets as DuckDB tables
DBI::dbWriteTableArrow(con, "df", df)
DBI::dbWriteTableArrow(con, "df_household", df_household)

# Step 6: Construct and execute the SQL query for the left join
# Using paste to concatenate column names for the join condition
query <- paste0(
  "SELECT df.*, df_household.* FROM df LEFT JOIN df_household ON ",
  paste(paste("df.", key_vars, " = df_household.", key_vars, sep = ""), collapse = " AND ")
)

# Execute the query
# df_geo <- DBI::dbGetQueryArrow(con, query) # returns nanoarrow_array
df_geo <- DBI::dbGetQuery(con, query) # returns data.frame
df_geo <- DBI::dbSendQuery(con, query) # returns ?????









# reprex -----------------------
# https://github.com/tidyverse/duckplyr/issues/257
library(arrow)
library(duckdb)
library(duckplyr)

# download parquet files
url1 <- 'https://github.com/ipeaGIT/censobr/releases/download/v0.2.0/2010_emigration_v0.2.0.parquet'
url2 <- 'https://github.com/ipeaGIT/censobr/releases/download/v0.2.0/2010_households_v0.2.0.parquet'
curl::curl_download(url = url1, destfile = 'temp_parquet1.parquet')
curl::curl_download(url = url2, destfile = 'temp_parquet2.parquet')

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
  arrow1 <- arrow::to_duckdb(arrow1)
  arrow2 <- arrow::to_duckdb(arrow2)

  # merge
  df_merge <- dplyr::left_join(arrow1, arrow2) |>
            dplyr::compute()

  # ?????? duckdb::duckdb_unregister()

  df_merge <- arrow::to_arrow(df_merge)
  return(df_merge)
}

# run function
test <- merge_fun( arrow1, arrow2)

# try to remove file 1. T
file.exists('temp_parquet1.parquet')
file.remove('temp_parquet1.parquet')

# remove file 2
file.exists('temp_parquet2.parquet')
file.remove('temp_parquet2.parquet')


library(censobr)
censobr::censobr_cache()
# censobr::censobr_cache(delete_file = 'all')


df <- censobr::read_mortality(
  year = 2010,
  merge_households = TRUE
  )

class(df)



