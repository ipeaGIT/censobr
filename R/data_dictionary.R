#' Data dictionary of Brazil's census data
#'
#' @description
#' Open the data dictionary of Brazil's census data sets on a browser.
#'
#' @template year
#' @param table Character. The table of data dictionary to be opened. Options
#'        include `c("microdata")`.
#'
#' @return Opens .html file on the browser
#' @export
#' @family Census documentation
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' # Open data dictionary on browser
#' data_dictionary(year = 2010, table = 'microdata')
#'
data_dictionary <- function(year = NULL,
                            table = NULL){
  # year = 2010
  # table = 'microdata'

  ### check inputs
  checkmate::assert_numeric(year)
  checkmate::assert_string(table)

  # data available for the years:
  years <- c(2000, 2010)
  if (isFALSE(year %in% years)) { stop(  paste0("Error: Dictionary currently only available for the years: ",
                                              paste(years), collapse = " ")
                                        )}

  # data available for data sets:
  data_sets <- c('microdata')
  if (isFALSE(table %in% data_sets)) { stop( paste0("Error: Dictionary currently only available for the tables: ",
                                              paste(data_sets, collapse = ", "))
                                            )}


  # load all dictionary files currenlty available
  data_path <- system.file("extdata", package = "censobr")
  all_dic <- list.files(data_path, full.names = TRUE, pattern = '.html')

  # filter data dic by year and type of data
  temp_dic <- all_dic[grepl(year, all_dic)]
  temp_dic <- temp_dic[grepl(table, temp_dic)]

  # open data dic on browser
  utils::browseURL(url = temp_dic)
}
