#' Add geometry information of census tracts
#'
#' @param df An arrow `Dataset` passed from function above.
#' @param year Numeric. Passed from function above.
#' @param showProgress Logical. Passed from function above.
#'
#' @return An arrow `Dataset` with additional geometry variable.
#'
#' @keywords internal
geometry <- function(df,
                     year = parent.frame()$year,
                     showProgress = parent.frame()$showProgress){

# df <- censobr::read_tracts(year = 2022, dataset = 'PessoaRenda')
# df <- dplyr::collect(df)

  # download tracts geometry from geobr
  tracts_sf <- geobr::read_census_tract(code_tract = 'all',
                                      year = year,
                                      showProgress = showProgress)

  # hamonize col classes
  df <- dplyr::mutate(df, code_muni = as.numeric(code_muni),
                          code_state = as.numeric(code_state))

  if (year == 2010) {

    # determine key vars
    key_vars <- c("code_tract", "code_muni", "code_state")
    }

  # drop repeated vars
  all_common_vars <- names(df)[names(df) %in% names(tracts_sf)]
  vars_to_drop <- setdiff(all_common_vars, key_vars)
  tracts_sf <- dplyr::select(tracts_sf, -all_of(vars_to_drop))

  # merge
  temp_sf <- dplyr::left_join(df, tracts_sf)

  return(temp_sf)
}
