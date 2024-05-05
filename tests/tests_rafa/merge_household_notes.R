library(dplyr)
library(censobr)
library(arrow)

year = 1980


df <- censobr::read_population(year = year,
                                as_data_frame = F)



# censobr::data_dictionary(year = year, dataset = 'population')
# censobr::data_dictionary(year = year, dataset = 'households')





#' @template merge_households


#' Add household variables to the data set
#'
#' @param df Object a data.frase
#' @param year String. A url.
#' @template add_labels
#' @param showProgress Logical.
#'
#' @return Internal silent function
#'
#' @keywords internal
merge_household_var <- function(df, year, add_labels=NULL, showProgress=T){



  # download household data
  df_household <- censobr::read_households(year = year,
                                           add_labels = add_labels,
                                           as_data_frame = FALSE,
                                           showProgress = showProgress)

  # set vars to merge
  if (year == 1970) {

    # determine key vars
    key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                  'code_region', 'name_region', 'household_id')
    }

  if (year == 1980) {

    # rename weight var
    df_household <- dplyr::rename(df_household, 'V603_household' = 'V603')

    # determine key vars
    key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                  'code_region', 'name_region', 'V6', 'V601')
    }

  if (year == 1991) {

    # rename weight var
    df_household <- dplyr::rename(df_household, 'V7300_household' = 'V7300')

    # determine key vars
    key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                  'code_region', 'name_region', 'V0109')
    }

  if (year == 2000) {

    # determine key vars
    key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                  'code_region', 'name_region', 'code_weighting', 'V0300')
    }

  if (year == 2010) {

    # rename weight var
    df_household <- dplyr::rename(df_household, 'V0010_household' = 'V0010')

    # determine key vars
    key_vars <- c('code_muni', 'code_state', 'abbrev_state','name_state',
                  'code_region', 'name_region', 'code_weighting', 'V0300')
    }


  # drop repeated vars
  all_common_vars <- names(df)[names(df) %in% names(df_household)]
  vars_to_drop <- setdiff(all_common_vars, key_vars)
  df_household <- dplyr::select(df_household, -all_of(vars_to_drop))

  # merge
  temp_df <- dplyr::left_join(df, df_household)

  return(temp_df)
  }
