#' Download census tract-level data from Brazil's censuses
#'
#' @description
#' Download census tract-level aggregate data from Brazil's censuses.
#'
#' @template year
#' @param dataset Character. The dataset to be opened. Options currently include
#'        `c("Basico", "Domicilio", "DomicilioRenda", "Responsavel", "ResponsavelRenda", "Pessoa", "PessoaRenda",  "Entorno")`.
#'        Preliminary results of the 2022 census are available with `"Preliminares"`.
#' @template as_data_frame
#' @template showProgress
#' @template cache
#'
#' @return An arrow `Dataset` or a `"data.frame"` object.
#' @export
#' @family Census tract data
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' library(censobr)
#'
#' # return data as arrow Dataset
#' df <- read_tracts(year = 2010,
#'                   dataset = 'PessoaRenda',
#'                   showProgress = FALSE)
#'
#' # return data as data.frame
#' df <- read_tracts(year = 2010,
#'                   dataset = 'Basico',
#'                   as_data_frame = TRUE,
#'                   showProgress = FALSE)
#'
#'
read_tracts <- function(year = 2010,
                        dataset = NULL,
                        as_data_frame = FALSE,
                        showProgress = TRUE,
                        cache = TRUE){

  ### check inputs
  checkmate::assert_numeric(year)
  checkmate::assert_logical(as_data_frame)
  checkmate::assert_logical(showProgress)
  checkmate::assert_logical(cache)
  checkmate::assert_string(dataset, null.ok = FALSE)


  # data available for the years:
  years <- c(2010, 2022)
  if (isFALSE(year %in% years)) {
    error_missing_years(years)
    }

  # data sets available for 2010:
  data_sets_2010 <- c("Basico", "Domicilio", "DomicilioRenda", "Entorno",
                 "ResponsavelRenda", "Responsavel", "PessoaRenda", "Pessoa")
  if (year==2010 & isFALSE(dataset %in% data_sets_2010)) {
    error_missing_datasets(data_sets_2010)
    }

  # data sets available for 2022:
  data_sets_2022 <- c("Preliminares")
  if (year==2022 & isFALSE(dataset %in% data_sets_2022)) {
    error_missing_datasets(data_sets_2022)
  }

  ### Get url
  dataset <- paste0(dataset, '_')
  file_url <- paste0("https://github.com/ipeaGIT/censobr/releases/download/",
                     censobr_env$data_release, "/", year,"_tracts_", dataset,
                     censobr_env$data_release, ".parquet")

  ### Download
  local_file <- download_file(file_url = file_url,
                              showProgress = showProgress,
                              cache = cache)

  # check if download worked
  if(is.null(local_file)) { return(invisible(NULL)) }

  ### read data
  df <- arrow_open_dataset(local_file)

  # ### Select
  # if (!is.null(columns)) { # columns <- c('V0002','V0011')
  #   df <- dplyr::select(df, dplyr::all_of(columns))
  # }

  # ### Add labels
  # if (!is.null(add_labels)) { # add_labels = 'pt'
  #   df <- add_labels_mortality(arrw = df,
  #                              year = year,
  #                              lang = add_labels)
  #   }

  ### output format
  if (isTRUE(as_data_frame)) { return( dplyr::collect(df) )
  } else {
    return(df)
  }
}

