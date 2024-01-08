#' Questionnaires used in the data collection of Brazil's censuses
#'
#' @description
#' Open on a browser the questionnaire used in the data collection of Brazil's
#' censuses
#'
#' @template year
#' @param type Character. The type of questionnaire used in the survey, whether
#'        the `"long"` one used in the sample component of the census, or the
#'        `"short"` one, which is answered by more households. Options include
#'        `c("long", "short")`.
#' @template showProgress
#' @template cache
#'
#' @return Opens a `.pdf` file on the browser
#' @export
#' @family Questionnaire
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' library(censobr)
#'
#' # Open questionnaire on browser
#' questionnaire(year = 2010, type = 'long', showProgress = FALSE)
#'
questionnaire <- function(year = 2010,
                          type = NULL,
                          showProgress = TRUE,
                          cache = TRUE){
  # year = 2000
  # type = 'short'
  # type = 'long'

  ### check inputs
  checkmate::assert_numeric(year)
  checkmate::assert_string(type)

  # data available for the years:
  years <- c(1960, 1970, 1980, 1991, 2000, 2010, 2022)
  if (isFALSE(year %in% years)) { stop(  paste0("Error: Questionnaire currently only available for the years: ",
                                              paste(years), collapse = " ")
                                        )}

  # data available for data sets:
  data_sets <- c('long', 'short')
  if (isFALSE(type %in% data_sets)) { stop( paste0("Error: Questionnaire currently only available for the types: ",
                                              paste(data_sets, collapse = ", "))
                                            )}

  ### Get url
  fname <- paste0(year, '_questionnaire_', type, '.pdf')
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
