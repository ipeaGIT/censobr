#' Download file from url
#'
#' @param file_url String. A url.
#' @param showProgress Logical.
#' @param cache Logical.

#' @return A string to the address of the file in a tempdir
#'
#' @keywords internal
download_file <- function(file_url = parent.frame()$file_url,
                          showProgress = parent.frame()$showProgress,
                          cache = parent.frame()$cache){ # nocov start

  # check input
  checkmate::assert_logical(showProgress)
  checkmate::assert_logical(cache)

  # name of local file
  file_name <- basename(file_url)

  # create local dir
  # pkgv <- paste0('censobr_', utils::packageVersion("censobr") )
  pkgv <- paste0('censobr_', 'v0.1.0' )
  cache_dir <- tools::R_user_dir(pkgv, which = 'cache')
  if (isTRUE(cache) & !dir.exists(cache_dir)) { dir.create(cache_dir, recursive=TRUE) }

  # location of local file
  local_file <- paste0(cache_dir,"/",file_name)

  # cache message
  cache_message(local_file, cache)

  # If not caching, remove local file to download it again
  if (cache==FALSE & file.exists(local_file)) {
    unlink(local_file, recursive = T)
  }

  # has the file been downloaded already? If not, download it
  if (cache==FALSE |
      !file.exists(local_file) |
      file.info(local_file)$size == 0) {

    # download data
    try(silent = TRUE,
      httr::GET(url=file_url,
                if(showProgress==TRUE){ httr::progress()},
                httr::write_disk(local_file, overwrite = TRUE),
                config = httr::config(ssl_verifypeer = FALSE))
      )
  }

  # Halt function if download failed (file must exist and be larger than 500 kb)
  if (!file.exists(local_file) | file.info(local_file)$size < 500000) {
    message('Internet connection not working properly.')
    return(invisible(NULL))

    } else {
      return(local_file)
    }
  } # nocov end


#' Check if parquet file is corrupted
#'
#' @param df The output of a try() passed from a function above

#' @return A string with the address of the file in a tempdir
#'
#' @keywords internal
check_parquet_file <- function(df){

  if (class(df)[1] == "try-error") {
    stop("File cached locally seems to be corrupted. Please download it again using 'cache = FALSE'.\nAlternatively, you can remove the corrupted file with 'censobr::censobr_cache(delete_file = )'")
  }
}


#' Message when chaching file
#'
#' @param local_file The address of a file passed from the download_file function.
#' @param cache Logical.

#' @return A message
#'
#' @keywords internal
cache_message <- function(local_file = parent.frame()$local_file,
                          cache = parent.frame()$cache){ # nocov start

#  local_file <- 'C:\\Users\\user\\AppData\\Local/R/cache/R/censobr_v0.1/2010_deaths.parquet'

  # name of local file
  file_name <- basename(local_file[1])
  dir_name <- dirname(local_file[1])

  ## if file already exists
    # YES cache
    if (file.exists(local_file) & isTRUE(cache)) {
       message('Reading data cached locally.')
       }

    # NO cache
    if (file.exists(local_file) & isFALSE(cache)) {
       message('Overwriting data cached locally.')
       }

  ## if file does not exist yet
  # YES cache
  if (!file.exists(local_file) & isTRUE(cache)) {
     message(paste("Downloading data. File will be stored locally at:", dir_name))
     }

  # NO cache
  if (!file.exists(local_file) & isFALSE(cache)) {
     message(paste("Downloading data. Setting 'cache = TRUE' is strongly recommended to speed up future use. File will be stored locally at:", dir_name))
     }
  }
