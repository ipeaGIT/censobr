#' censobr: Download Data from Brazil's Population Census
#'
#' Download data data from Brazil's population Census.
#'
#' @section Usage:
#' Please check the vignettes and data documentation on the
#' [website](https://ipeagit.github.io/censobr/).
#'
#' @docType package
#' @name censobr
#' @aliases censobr-package
#'
"_PACKAGE"


## quiets concerns of R CMD check re: the .'s that appear in pipelines
utils::globalVariables( c('year',
                          'temp_local_file') )

