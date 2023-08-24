#' Download microdata of death records from Brazil's census
#'
#' @description
#' Download microdata of death records from Brazil's census.
#'
#' @template year
#' @template columns
#' @template as_data_frame
#'
#' @return An Arrow table or a `"data.frame"` object.
#' @export
#' @family download microdata
#' @examples \dontrun{ if (interactive()) {
#' # return data as data.frame
#' df <- read_deaths(year = 2010, as_data_frame = TRUE)
#'
#' # return data as arrow table
#' df <- read_deaths(year = 2010, as_data_frame = FALSE)
#'
#'}}
read_deaths <- function(year = 2010,
                        columns = NULL,
                        as_data_frame = TRUE){

  ### check inputs
  checkmate::assert_logical(as_data_frame)
  checkmate::assert_vector(columns, null.ok = TRUE)
  checkmate::assert_numeric(year)

  years <- c(2010)
  if (isFALSE(year %in% years)) { stop(paste0("Error: Data set only available for the years ",
                                             paste(years), collapse = " "))}

  ### Get url
  if (year==2010) { url <- '2010_deaths.parquet' }


  ### Download
  df <- arrow::read_parquet(url, as_data_frame = FALSE)

  # check downloaded
    # if (is.null(df)) {message()}

      # load('R:/Dropbox/bases_de_dados/censo_demografico/censo_2010/data/censo2010_BRdeaths.Rdata')
      #
      # head(censo2010_BRdeaths)
      #
      # df <- arrow::as_arrow_table(censo2010_BRdeaths, )
      #
      # arrow::write_parquet(df, '2010_deaths.parquet')


  ### Select
  if (!is.null(columns)) { # columns <- c('V0002','V0011')
    df <- dplyr::select(df, columns)
  }



      df |> dplyr::collect()


  ### output format
  if (isTRUE(as_data_frame)) { return( dplyr::collect(df) )
  } else {
      return(df)
    }

}

