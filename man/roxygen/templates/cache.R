#' @param cache Logical. The first time the user runs the function, `censobr`
#'        will download the file from the internet and store it locally at
#'        `tools::R_user_dir('censobr', 'cache')`, so that the file only needs
#'        to be download once. When the `cache` parameter is set to `TRUE`
#'        (Default), the function will read the data cached locally, which is
#'        much faster. If `FALSE`, the function will download the file from the
#'        internet again.
