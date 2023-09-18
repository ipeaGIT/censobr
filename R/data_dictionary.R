#' Data dictionary of Brazil's census data
#'
#' @description
#' Open on a browser the data dictionary of Brazil's census data.
#'
#' @template year
#' @param table Character. The table of data dictionary to be opened. Options
#'        include `c("microdata", 'tracts')`.
#' @template showProgress
#' @template cache
#'
#' @return Returns `NULL` and opens .html or .pdf file on the browser
#' @export
#' @family Census documentation
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' # Open data dictionary on browser
#' data_dictionary(year = 2010, table = 'microdata')
#'
#' data_dictionary(year = 2010, table = 'tracts')

data_dictionary <- function(year = NULL,
                            table = NULL,
                            showProgress = TRUE,
                            cache = TRUE){
  # year = 2010
  # table = 'microdata'

  ### check inputs
  checkmate::assert_numeric(year)
  checkmate::assert_string(table)

  # data available for data sets:
  data_sets <- c('microdata', 'tracts')
  if (isFALSE(table %in% data_sets)) { stop( paste0("Error: Dictionary currently only available for the tables: ",
                                                    paste(data_sets, collapse = ", "))
  )}


  ### IF Microdata
  if (table == 'microdata') {
    # data available for the years:
    years <- c(2000, 2010)
    if (isFALSE(year %in% years)) {
      stop(
        paste0(
          "Error: Dictionary for microdata currently only available for the years: ",
          paste(years),
          collapse = " "
        )
      )
    }
  }

  ### IF Census Tracts
  if (table == 'tracts') {
    # data available for the years:
    years <- c(1970,1980, 1991, 2000, 2010)
    if (isFALSE(year %in% years)) {
      stop(
        paste0(
          "Error: Dictionary for census tracts currently only available for the years: ",
          paste(years),
          collapse = " "
        )
      )
    }
  }

  # LOCAL FILES
  if (table == 'microdata') {
  # load all dictionary files currenlty available
  data_path <- system.file("extdata", package = "censobr")
  all_dic <- list.files(data_path, full.names = TRUE, pattern = '.html')

  # filter data dic by year and type of data
  temp_dic <- all_dic[grepl(year, all_dic)]
  temp_dic <- temp_dic[grepl(table, temp_dic)]
  }

  # DOWNLOAD
  if (table == 'tracts') {

    ### Get url
    fname <- paste0(year, '_dictionary_tracts.pdf')
    file_url <- paste0("https://github.com/ipeaGIT/censobr/releases/download/censo_docs/", fname)

    ### Download
    temp_dic <- download_file(file_url = file_url,
                                showProgress = showProgress,
                                cache = cache)
  }

  # open data dic on browser
  utils::browseURL(url = temp_dic)
  return(NULL)
}
