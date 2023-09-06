#' Manage cached files from the censobr package
#'
#' @param list_files Logical. Whether to print a message with the address of all
#'        censobr data sets cached locally. Defaults to `TRUE`.
#' @param delete_file String. The file name (basename) of a censobr data set
#'        cached locally that should be deleted. Defaults to `NULL`, so that no
#'        file is deleted. If `delete_file = "all"`, then all cached censobr
#'        files are deleted.
#'
#' @return A message indicating which file exist and/or which ones have been
#'         deleted from local cache directory.
#' @export
#' @family support
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' # list all files cached
#' censobr_cache(list_files = TRUE)
#'
#' # delete particular file
#' censobr_cache(delete_file = '2010_deaths')
#'
censobr_cache <- function(list_files = TRUE,
                          delete_file = NULL){

  # check inputs
  checkmate::assert_logical(list_files)
  checkmate::assert_character(delete_file, null.ok = TRUE)

  # find / create local dir
  if (!dir.exists(censobr_env$cache_dir)) { dir.create(censobr_env$cache_dir, recursive=TRUE) }

  # list cached files
  files <- list.files(censobr_env$cache_dir, full.names = TRUE)

  # if wants to dele file
  # delete_file = "2_families.parquet"
  if (!is.null(delete_file)) {

    # IF file does not exist, print message
    if (!any(grepl(delete_file, files)) & delete_file != "all") {
      message(paste0("The file '", delete_file, "' is not cached."))
    }

    # IF file exists, delete file
    if (any(grepl(delete_file, files))) {
      f <- files[grepl(delete_file, files)]
      unlink(f, recursive = TRUE)
      message(paste0("The file '", delete_file, "' has been removed."))
    }

    # Delete ALL file
    if (delete_file=='all') {
      unlink(files, recursive = TRUE)
      message(paste0("All files have been removed."))

      ## also delete any files from old data releases
        # determine old cache
        dir_above <- dirname(censobr_env$cache_dir)
        all_cache <- list.files(dir_above, pattern = 'censobr',full.names = TRUE)
        old_cache <- all_cache[!grepl(censobr_env$pkgv, all_cache)]
        # delete
        unlink(old_cache, recursive = TRUE)

    }
  }

  # list cached files
  files <- list.files(censobr_env$cache_dir, full.names = TRUE)

  # print file names
  if(isTRUE(list_files)){
    message('Files currently chached:')
    message(paste0(files, collapse = '\n'))
  }
}

