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
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom dplyr across
#' @importFrom dplyr case_when
#' @importFrom dplyr all_of
#'
#' @keywords internal
"_PACKAGE"


## quiets concerns of R CMD check re: the .'s that appear in pipelines
utils::globalVariables( c('year',
                          'temp_local_file') )

NULL
