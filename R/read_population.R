#' Download microdata of population records from Brazil's census
#'
#' @description
#' Download microdata of population records from Brazil's census.
#'
#' @template year
#' @template columns
#' @template as_data_frame
#' @template showProgress
#' @template cache
#'
#' @return An Arrow table or a `"data.frame"` object.
#' @export
#' @family download microdata
#' @examples \dontrun{ if (interactive()) {
#' # return data as data.frame
#' df <- read_population(year = 2010, as_data_frame = TRUE)
#' head(df)
#'
#' # return data as arrow table
#' df <- read_population(year = 2010, as_data_frame = FALSE)
#' head(df)
#'}}
read_population <- function(year = 2010,
                        columns = NULL,
                        as_data_frame = TRUE,
                        showProgress = TRUE,
                        cache = TRUE){

  ### check inputs
  checkmate::assert_numeric(year)
  checkmate::assert_vector(columns, null.ok = TRUE)
  checkmate::assert_logical(as_data_frame)
  checkmate::assert_logical(showProgress)
  checkmate::assert_logical(cache)

  years <- c(2010)
  if (isFALSE(year %in% years)) { stop(paste0("Error: Data set only available for the years ",
                                             paste(years), collapse = " "))}

  ### Get url
  if (year==2010) { file_url <- 'https://github.com/ipeaGIT/censobr/releases/download/v0.1.0/2010_population.parquet'
  }


  ### Download
  local_file <- download_file(file_url = file_url,
                              showProgress = showProgress,
                              cache = cache)

  # check if download worked
  if(is.null(local_file)) { return(NULL) }

  # read data
  df <- arrow::read_parquet(local_file, as_data_frame = FALSE)


  ### Select
  if (!is.null(columns)) { # columns <- c('V0002','V0011')
    df <- dplyr::select(df, columns)
  }

  ### output format
  if (isTRUE(as_data_frame)) { return( dplyr::collect(df) )
  } else {
      return(df)
    }

}

