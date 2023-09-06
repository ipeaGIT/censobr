# package global variables
censobr_env <- new.env(parent = emptyenv()) # nocov start

.onAttach <- function(libname, pkgname){

  # data release
  censobr_env$data_release <- 'v0.1.0'

  # local cache dir
  pkgv <- paste0('censobr_', censobr_env$data_release)
  censobr_env$cache_dir <- tools::R_user_dir(pkgv, which = 'cache')
  } # nocov end
