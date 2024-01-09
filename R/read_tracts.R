#' Download census tract-level data from Brazil's censuses
#'
#' @description
#' Download census tract-level aggregate data from Brazil's censuses.
#'
#' @template year
#' @param dataset Character. The dataset to be opened. Options currently include
#'        `c("Basico", "Domicilio", "DomicilioRenda", "Responsavel", "ResponsavelRenda", "Pessoa", "PessoaRenda",  "Entorno")`.
#' @template as_data_frame
#' @template showProgress
#' @template cache
#'
#' @return An arrow `Dataset` or a `"data.frame"` object.
#' @export
#' @family Census tract data
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
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
                        dataset = NULL,               # dataset = 'Basico'
                        as_data_frame = FALSE,
                        showProgress = TRUE,
                        cache = TRUE){

  ### check inputs
  checkmate::assert_numeric(year)
  checkmate::assert_logical(as_data_frame)
  checkmate::assert_string(dataset, null.ok = FALSE)


  # data available for the years:
  years <- c(2010)
  if (isFALSE(year %in% years)) { stop(paste0("Error: Data currently only available for the years ",
                                              paste(years, collapse = " ")))}

  # data available for data sets:
  data_sets <- c("Basico", "Domicilio", "DomicilioRenda", "Entorno",
                 "ResponsavelRenda", "Responsavel", "PessoaRenda", "Pessoa")
  if (isFALSE(dataset %in% data_sets)) { stop( paste0("Error: Data currently only available for the datasets: ",
                                                    paste(data_sets, collapse = ", "))
  )}

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
  if(is.null(local_file)) { return(NULL) }

  ### read data
  df <- try(arrow::open_dataset(local_file), silent=FALSE)
  check_parquet_file(df)

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
