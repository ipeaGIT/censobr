library(arrow)

all_files <- list.files("L:/# RAFAEL HENRIQUE MORAES PEREIRA #/censobr/v30",full.names = T)
dest_dir <- "L:/# RAFAEL HENRIQUE MORAES PEREIRA #/censobr/v50"
dest_dir <- "C:/Users/r1701707/Desktop/ssss"

update_parquet <- function(f) {

  # f = all_files[12]

  temp_df <- arrow::read_parquet(f)

  # sort rows by the first 15 cols (a bit of an overkill)
  data.table::setDT(temp_df)
  first_15_cols <- names(temp_df)[1:15]
  data.table::setorderv(temp_df, first_15_cols)

  # remove data.table
  data.table::setindex(temp_df, NULL)
  data.table::setDF(temp_df)

  base_name <- gsub('v0.3.0', 'v0.5.0',  basename(f))
  dest_file <- fs::path(dest_dir, base_name)

  arrow::write_parquet(
    x = temp_df,
    sink = dest_file,
    compression='zstd',
    compression_level = 22)

  gc()
}


pbapply::pblapply(X=all_files, FUN=update_parquet)


future::plan(future::multisession, workers=4)

furrr::future_map(.x = all_files, .f=update_parquet)
