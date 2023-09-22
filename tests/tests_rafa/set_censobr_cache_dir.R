#' Set custom cache directory for censobr files
#'
#' Set custom directory for caching files from the censobr package. If users
#' want to set a custom cache directory, the function needs to be run again in
#' each new R session.
#'
#' @param path String. The path to an existing directory. It deafults to `path = NULL`,
#'        to use the default directory
#'
#' @return A message indicating the directory where censobr files are cached.
#'
#' @export
#' @family Cache data
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' # Set custom cache directory
#' tempd <- tempdir()
#' set_censobr_cache_dir(path = tempd)
#'
set_censobr_cache_dir <- function(path = NULL) {

  if (dir.exists(path)) {
    censobr_env$cache_dir <- path
  }


  if (is.null(path = NULL)) {
    cache_d <- paste0('censobr/data_release_', censobr_env$data_release)
    censobr_env$cache_dir <- tools::R_user_dir(cache_d, which = 'cache')
  }

  message(paste("censobr files will be cached at ", censobr_env$cache_dir))

  }
