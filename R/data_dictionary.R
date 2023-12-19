#' Data dictionary of Brazil's census data
#'
#' @description
#' Open on a browser the data dictionary of Brazil's census data.
#'
#' @template year
#' @param dataset Character. The dataset of data dictionary to be opened. Options
#'        include `c("population", "households", "families", "mortality", "emigration", "tracts")`.
#' @template showProgress
#' @template cache
#'
#' @return Returns `NULL` and opens .html or .pdf file on the browser
#' @export
#' @family Census documentation
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' # Open data dictionary on browser
#' data_dictionary(year = 2010, dataset = 'population', showProgress = FALSE)
#'
#' data_dictionary(year = 1980, dataset = 'households', showProgress = FALSE)
#'
#' data_dictionary(year = 2010, dataset = 'tracts', showProgress = FALSE)

data_dictionary <- function(year = 2010,
                            dataset = NULL,
                            showProgress = TRUE,
                            cache = TRUE){
  # year = 2010
  # dataset = 'population'

  ### check inputs
  checkmate::assert_numeric(year)
  checkmate::assert_string(dataset)

  # data available for data sets:
  data_sets <- c("population", "households", "families", "mortality", "emigration", "tracts")
  if (isFALSE(dataset %in% data_sets)) { stop( paste0("Error: Dictionary currently only available for the datasets: ",
                                                    paste(data_sets, collapse = ", "))
  )}


  # check year / data availability
  if(dataset == 'tracts'){ years <- c(1970, 1980, 1991, 2000, 2010) }
  if(dataset == 'population'){ years <- c(1970, 1980, 2000, 2010) }
  if(dataset == 'households'){ years <- c(1970, 1980, 2000, 2010) }
  if(dataset == 'families'){ years <- c(2000) }
  if(dataset == 'mortality'){ years <- c(2010) }
  if(dataset == 'emigration'){ years <- c(2010) }

  if (isFALSE(year %in% years)) {
    stop( paste0("Error: Dictionary for ",dataset," data currently only available for the years: ",
                 paste(years,collapse = " ")))
    }



  ### Get url

  # MICRODATA
  if (dataset %in% c("population", "households", "families", "mortality", "emigration")) {
    fname <- paste0(year, '_dictionary_microdata_', dataset, '.html')
    file_url <- paste0("https://github.com/ipeaGIT/censobr/releases/download/censo_docs/", fname)
    }

  # TRACT DATA
  if (dataset == 'tracts') {
    fname <- paste0(year, '_dictionary_tracts.pdf')
    file_url <- paste0("https://github.com/ipeaGIT/censobr/releases/download/censo_docs/", fname)
    }

  ### Download
  local_file <- download_file(file_url = file_url,
                            showProgress = showProgress,
                            cache = cache)

  # check if download worked
  if(is.null(local_file)) { return(NULL) }

  # open data dic on browser
  utils::browseURL(url = local_file)
  return(NULL)
}
