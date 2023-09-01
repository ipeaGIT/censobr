#' @param cache Logical. Whether the function should read the data cached
#'        locallly, which is much faster. Defaults to `TRUE`. The first time the
#'        user runs the function, `censobr` will download the file and store it
#'        locally so that the file only needs to be download once. If `FALSE`,
#'        the function will download the data again and overwrite the local file.
#'        Data sets are stored at `tools::R_user_dir('censobr_v0.1', 'cache')`.
