# package global variables
censobr_env <- new.env(parent = emptyenv()) # nocov start

.onAttach <- function(libname, pkgname){

  # data release
  censobr_env$data_release <- 'v0.2.0'

  # local cache dir
  cache_d <- paste0('censobr/data_release_', censobr_env$data_release)
  censobr_env$cache_dir <- tools::R_user_dir(cache_d, which = 'cache')
  # gsub("\\\\", "/", censobr_env$cache_dir)

  ## delete any files from old data releases
  dir_above <- dirname(censobr_env$cache_dir)
  all_cache <- list.files(dir_above, pattern = 'data_release',full.names = TRUE)
  old_cache <- all_cache[!grepl(censobr_env$data_release, all_cache)]
  if(length(old_cache)>0){ unlink(old_cache, recursive = TRUE) }

} # nocov end
