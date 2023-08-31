#' @param cache Logical. The first time the user runs the function, `censobr`
#'        will download the file from the internet and store it locally so that
#'        the file only needs to be download once. When the `cache` parameter is
#'        set to `TRUE` (Default), the function will read the cached data, which
#'        is much faster. If `FALSE`, the function will download the file from
#'        the internet again and overwrite an eventual local file. The data is
#'        stored locally at `tools::R_user_dir('censobr_v0.1', 'cache')`.
