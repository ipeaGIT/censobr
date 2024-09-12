#' Add household variables to the data set
#'
#' @param df An arrow `Dataset` passed from function above.
#' @param year Numeric. Passed from function above.
#' @param add_labels Character. Passed from function above.
#' @param showProgress Logical. Passed from function above.
#'
#' @return An arrow `Dataset` with additional household variables.
#'
#' @keywords internal
merge_household_var <- function(df,
                                year = parent.frame()$year,
                                add_labels = parent.frame()$add_labels,
                                showProgress = parent.frame()$showProgress){

  # download household data
  df_household <- censobr::read_households(year = year,
                                           add_labels = add_labels,
                                           as_data_frame = FALSE,
                                           showProgress = showProgress)

  # set vars to merge
  if (year == 1970) {
    key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                  'code_region', 'name_region', 'id_household')
    }

  if (year == 1980) {
    key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                  'code_region', 'name_region', 'V6', 'V601')

    # rename weight var
    df_household <- dplyr::rename(df_household, 'V603_household' = 'V603')
    }

  if (year == 1991) {
    key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                  'code_region', 'name_region', 'V0109')

    # rename weight var
    df_household <- dplyr::rename(df_household, 'V7300_household' = 'V7300')
    }

  if (year == 2000) {
    key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                  'code_region', 'name_region', 'code_weighting', 'V0300')
  }

  if (year == 2010) {
    key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                  'code_region', 'name_region', 'code_weighting', 'V0300')

    # rename weight var
    df_household <- dplyr::rename(df_household, 'V0010_household' = 'V0010') |>
                    dplyr::compute()
  }


  # drop repeated vars
  all_common_vars <- names(df)[names(df) %in% names(df_household)]
  vars_to_drop <- setdiff(all_common_vars, key_vars)
  df_household <- dplyr::select(df_household, -all_of(vars_to_drop)) |>
                  dplyr::compute()


  # convert to duckdb
  # df <- arrow::to_duckdb(df)
  # df_household <- arrow::to_duckdb(df_household)

  # con <- DBI::dbConnect(duckdb::duckdb(), read_only = FALSE)
  con <- duckdb::dbConnect(duckdb::duckdb(), read_only = FALSE)
  duckdb::duckdb_register_arrow(con, 'df', df)
  duckdb::duckdb_register_arrow(con, 'df_household', df_household)

  # limit RAM and threads of duckdb ???
  # dbExecute(con, "PRAGMA threads=1; PRAGMA memory_limit='1GB';")
  # dbExecute(conn = conn, paste0("PRAGMA memory_limit='12GB'"))
  # appears to work.
  # https://github.com/duckdb/duckdb-r/issues/83
  # https://github.com/duckdb/duckdb-r/issues/72

  # merge
  df_geo <- duckplyr::left_join(dplyr::tbl(con, "df"),
                                dplyr::tbl(con, "df_household"))

  df_geo <- dplyr::compute(df_geo)

  # back to arrow
  df_geo <- arrow::to_arrow(df_geo)
  df_geo <- dplyr::compute(df_geo)

  # remove duckdb instance
  duckdb::duckdb_unregister_arrow(con, 'df')
  duckdb::duckdb_unregister_arrow(con, 'df_household')
  duckdb::dbDisconnect(con, shutdown = TRUE)
  rm(con)
  gc()

  return(df_geo)
}
