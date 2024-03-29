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
  if (isTRUE(cache) & !dir.exists(censobr_env$cache_dir)) { dir.create(censobr_env$cache_dir, recursive=TRUE) }

  # location of local file
  local_file <- paste0(censobr_env$cache_dir,"/",file_name)

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

  # Halt function if download failed (file must exist and be larger than 200 kb)
  if (!file.exists(local_file) | file.info(local_file)$size < 5000) {
    message('Internet connection not working properly.')
    return(invisible(NULL))

    } else {
      return(local_file)
    }
  } # nocov end


#' Safely use arrow to open a Parquet file
#'
#' This function handles some failure modes, including if the Parquet file is
#' corrupted.
#'
#' @param filename A local Parquet file
#' @return An `arrow::Dataset`
#'
#' @keywords internal
arrow_open_dataset <- function(filename){

  tryCatch(
    arrow::open_dataset(filename),
    error = function(e){
      msg <- paste(
        "File cached locally seems to be corrupted. Please download it again using 'cache = FALSE'.",
        sprintf("Alternatively, you can remove the corrupted file with 'censobr::censobr_cache(delete_file = \"%s\")'", filename),
        sep = "\n"
      )
      stop(msg)
    }
  )
}

#' Message when caching file
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
     message(paste("Downloading data and storing it locally for future use."))
     }

  # NO cache
  if (!file.exists(local_file) & isFALSE(cache)) {
     message(paste("Downloading data. Setting 'cache = TRUE' is strongly recommended to speed up future use. File will be stored locally at:", dir_name))
     }
  } # nocov end
