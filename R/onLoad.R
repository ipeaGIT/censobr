# package global variables
censobr_env <- new.env(parent = emptyenv()) # nocov start

.onAttach <- function(libname, pkgname){

  # data release
  censobr_env$data_release <- 'v0.1.0'

  # local cache dir
  censobr_env$cache_dir <- tools::R_user_dir('censobr', which = 'cache')
  censobr_env$cache_dir <- paste0(censobr_env$cache_dir,'/',censobr_env$data_release)
  # gsub("\\\\", "/", censobr_env$cache_dir)



} # nocov end
