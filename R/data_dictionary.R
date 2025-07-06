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
#' @return Returns `NULL` and opens an .html, .pdf or excel file
#' @export
#' @family Census documentation
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' # Open data dictionary
#' data_dictionary(year = 2010,
#'                 dataset = 'population',
#'                 showProgress = FALSE)
#'
#' data_dictionary(year = 2022,
#'                 dataset = 'tracts',
#'                 showProgress = FALSE)
#'
#' data_dictionary(year = 1980,
#'                 dataset = 'households',
#'                 showProgress = FALSE)
#'
#'
data_dictionary <- function(year,
                            dataset,
                            showProgress = TRUE,
                            cache = TRUE){
  # year = 2010
  # dataset = 'population'

  ### check inputs
  checkmate::assert_numeric(year, any.missing = FALSE)
  checkmate::assert_string(dataset, na.ok = FALSE)

  # data available for data sets:
  data_sets <- c("population", "households", "families", "mortality", "emigration", "tracts")
  if (isFALSE(dataset %in% data_sets)) {
    error_missing_datasets(data_sets)
    }

  # check year / data availability
  if(dataset == 'tracts'){ years <- c(1970, 1980, 1991, 2000, 2010, 2022) }
  if(dataset == 'population'){ years <- c(1960, 1970, 1980, 1991, 2000, 2010) }
  if(dataset == 'households'){ years <- c(1960, 1970, 1980, 1991, 2000, 2010) }
  if(dataset == 'families'){ years <- c(2000) }
  if(dataset == 'mortality'){ years <- c(2010) }
  if(dataset == 'emigration'){ years <- c(2010) }

  if (isFALSE(year %in% years)) {
    years_available <- paste(years, collapse = " ")
    cli::cli_abort(
      "Dictionary for {dataset} data currently only for the years {years_available}.",
      call = rlang::caller_env()
      )
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

    if(year==2022) {file_url <- gsub(".pdf", ".xlsx", file_url)}
    }

  ### Download
  local_file <- download_file(file_url = file_url,
                            showProgress = showProgress,
                            cache = cache)

  # check if download worked
  if(is.null(local_file)) { return(NULL) }

  # open data dic on browser
  file_extension <- fs::path_ext(local_file)

  if (file_extension %in% c('pdf', 'html')) {
    utils::browseURL(url = local_file)
  } else {
    open_file(path = local_file)
  }

  return(NULL)
}



open_file <- function(path) {
  # path <- normalizePath(path, mustWork = FALSE)   # tidy up the path
  if (.Platform$OS.type == "windows") {
    shell.exec(path)                              # built-in Windows helper
  } else if (Sys.info()[["sysname"]] == "Darwin") {
    system2("open", shQuote(path), wait = FALSE)  # macOS
  } else {                                        # Linux, *BSD, etc.
    system2("xdg-open", shQuote(path), wait = FALSE)
  }

  invisible(TRUE)
}
