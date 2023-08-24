

#' Download file from url
#'
#' @param file_url String. A url passed from \code{\link{get_flights_url}}.
#' @param showProgress Logical, passed from \code{\link{read_flights}}
#' @param dest_file String, passed from \code{\link{read_flights}}
#'
#' @return Silently saves downloaded file to temp dir.
#'
#' @keywords internal
#' @examples \dontrun{ if (interactive()) {
#' # Generate url
#' file_url <- get_flights_url(type='basica', year=2000, month=11)
#'
#' # download data
#' download_flightsbr_file(file_url=file_url,
#'                         showProgress=TRUE,
#'                         dest_file = tempfile(fileext = ".zip")
#'                        )
#'}}
download_flightsbr_file <- function(file_url = parent.frame()$file_url,
                                    showProgress = parent.frame()$showProgress,
                                    dest_file = temp_local_file){

  # download data
  try(
    httr::GET(url=file_url,
              if(showProgress==T){ httr::progress()},
              httr::write_disk(dest_file, overwrite = T),
              config = httr::config(ssl_verifypeer = FALSE)
    ), silent = TRUE)

  # check if file has NOT been downloaded, try a 2nd time
  if (!file.exists(dest_file) | file.info(dest_file)$size == 0) {

    # download data: try a 2nd time
    try(
      httr::GET(url=file_url,
                if(showProgress==T){ httr::progress()},
                httr::write_disk(dest_file, overwrite = T),
                config = httr::config(ssl_verifypeer = FALSE)
      ), silent = TRUE)
  }

  # Halt function if download failed
  if (!file.exists(dest_file) | file.info(dest_file)$size == 0) {
    message('Internet connection not working.')
    return(invisible(NULL)) }
}



