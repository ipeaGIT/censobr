#' Interview manual of the data collection of Brazil's censuses
#'
#' @description
#' Open on a browser the interview manual of the data collection of Brazil's
#' censuses
#'
#' @template year
#' @template showProgress
#' @template cache
#'
#' @return Opens a `.pdf` file on the browser
#' @export
#' @family Census documentation
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' # Open interview manual on browser
#' interview_manual(year = 2010, showProgress = FALSE)
#'
interview_manual <- function(year = NULL,
                             showProgress = TRUE,
                             cache = TRUE){
  # year = 2000

  ### check inputs
  checkmate::assert_numeric(year)

  # data available for the years:
  years <- c(1970, 1980, 1991, 2000, 2010)
  if (isFALSE(year %in% years)) { stop(  paste0("Error: Interview manual currently only available for the years: ",
                                              paste(years), collapse = " ")
                                        )}

  ### Get url
  fname <- paste0(year, '_interview_manual.pdf')
  file_url <- paste0("https://github.com/ipeaGIT/censobr/releases/download/censo_docs/", fname)

  ### Download
  local_file <- download_file(file_url = file_url,
                              showProgress = showProgress,
                              cache = cache)
  # check if download worked
  if(is.null(local_file)) { return(NULL) }

  # open data dic on browser
  utils::browseURL(url = local_file)
}
