#' Download file from url
#'
#' @param file_url String. A url.
#' @param showProgress Logical.
#' @param cache Logical.

#' @return A string to the address of the file in a tempdir
#'
#' @keywords internal
#' @examples \dontrun{ if (interactive()) {
#' # Generate url
#' file_url <- 'https://github.com/ipeaGIT/censobr/releases/download/v0.0.1/2010_deaths.parquet'
#'
#' # download data
#' download_file(file_url = file_url,
#'               showProgress = TRUE,
#'               cache = TRUE)
#'}}
download_file <- function(file_url = parent.frame()$file_url,
                          showProgress = parent.frame()$showProgress,
                          cache = parent.frame()$cache){ # nocov start

  # name of local file
  file_name <- basename(file_url)

  # local dir
  # cache_dir <- rappdirs::user_cache_dir("censobr", version = 'v0.0.9')
  cache_dir <- tools::R_user_dir("censobr_v0.1.0", which = 'data')
  if (isTRUE(cache) & !dir.exists(cache_dir)) { dir.create(cache_dir, recursive=TRUE) }

  # location of local file
  temp_local_file <- paste0(cache_dir,"/",file_name)

  # If not caching, remove local file to download it again
  if (cache==FALSE & file.exists(temp_local_file)) {
    unlink(temp_local_file, recursive = T)
  }

  # has the file been downloaded already? If not, download it
  if (cache==FALSE | !file.exists(temp_local_file) | file.info(temp_local_file)$size == 0) {

    # download data
    try(silent = TRUE,
      httr::GET(url=file_url,
                if(showProgress==TRUE){ httr::progress()},
                httr::write_disk(temp_local_file, overwrite = T),
                config = httr::config(ssl_verifypeer = FALSE))
      )
  }

  # Halt function if download failed
  if (!file.exists(temp_local_file) | file.info(temp_local_file)$size == 0) {
    message('Internet connection not working.')
    return(invisible(NULL))

    } else {
      return(temp_local_file)
    }
  } # nocov end
