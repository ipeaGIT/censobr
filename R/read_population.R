#' Download microdata of population records from Brazil's census
#'
#' @description
#' Download microdata of population records from Brazil's census. Data collected
#' in the sample component of the questionnaire.
#'
#' @template year
#' @template columns
#' @template add_labels
#' @template as_data_frame
#' @template showProgress
#' @template cache
#' @template verbose
#'
#' @return An arrow `Dataset` or a `"data.frame"` object.
#'
#' @template 1960_census_section
#'
#' @export
#' @family Microdata
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' # return data as arrow Dataset
#' df <- read_population(
#'   year = 2010,
#'   showProgress = FALSE
#'   )
#'
read_population <- function(year,
                            columns = NULL,
                            add_labels = NULL,
                            as_data_frame = FALSE,
                            showProgress = TRUE,
                            cache = TRUE,
                            verbose = TRUE){

  ### check inputs
  checkmate::assert_numeric(year, any.missing = FALSE)
  checkmate::assert_vector(columns, null.ok = TRUE)
  checkmate::assert_logical(as_data_frame, null.ok = FALSE)
  checkmate::assert_logical(verbose, null.ok = FALSE)
  # checkmate::assert_logical(merge_households)
  checkmate::assert_string(add_labels, pattern = 'pt', null.ok = TRUE)

  # data available for the years:
  years <- c(1960, 1970, 1980, 1991, 2000, 2010)
  if (isFALSE(year %in% years)) {
    error_missing_years(years)
    }

  ### Get url
  file_url <- paste0("https://github.com/ipeaGIT/censobr/releases/download/",
                     censobr_env$data_release, "/", year, "_population_",
                     censobr_env$data_release, ".parquet")


  ### Download
  local_file <- download_file(file_url = file_url,
                              showProgress = showProgress,
                              cache = cache,
                              verbose = verbose)

  # check if download worked
  if(is.null(local_file)) { return(invisible(NULL)) }

  ### read data
  df <- arrow_open_dataset(local_file)

  # # ### merge household data
  # if (isTRUE(merge_households)) {
  #   df <- merge_household_var(df,
  #                             year = year,
  #                             add_labels = add_labels,
  #                             showProgress)
  # }

  ### Select
  if (!is.null(columns)) { # columns <- c('V0002','V0011')
    df <- dplyr::select(df, dplyr::all_of(columns))
  }

  ### Add labels
  if (!is.null(add_labels)) { # add_labels = 'pt'
    df <- add_labels_population(arrw = df,
                                year = year,
                                lang = add_labels)
  }

  # 1960 warning
  if(year==1960){
    warning("This version of the 1960 microdata was compiled by {censobr} from two different releases elaborated by IBGE. The data was processed to ensure consistency and new variables added. See the documentation.")
  }

  ### output format
  if (isTRUE(as_data_frame)) { return( dplyr::collect(df) )
  } else {
    return(df)
  }

}

