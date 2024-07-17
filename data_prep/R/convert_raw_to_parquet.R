# Parse raw txt file and save it in parquet format
#' @keywords internal
convert_raw_to_parquet <- function(year, txt_file, dic){

  # txt_file <- txt_files[1]

  temp_df <- read_fwf(txt_file,
                      fwf_positions(
                        start = dic$int_pos,
                        end = dic$fin_pos,
                        col_names = dic$var_name),
                      col_types = paste(dic$col_type,collapse ='')
                      , # progress = interactive()
  )
  setDT(temp_df)

  # add decimal places
  if (any(dic$decimal_places)) {

    cols_with_decimals <- which(dic$decimal_places > 0, arr.ind=TRUE)

    lapply( X = cols_with_decimals,
            FUN = function(x){
              if(dic$col_type[x] == "d"){
                var <- dic$var_name[x]
                temp_df[, (var):= get(var) /(10**dic$decimal_places[x])]
              }
            })
  }

  # column classes
  cols_numeric <- subset(dic, decimal_places>0)$var_name
  cols_integer64 <- subset(dic, decimal_places==0 & length > 8)$var_name
  cols_integer <- setdiff(dic$var_name, c(cols_numeric, cols_integer64))

  temp_df <- temp_df |>
    mutate(across(all_of(cols_numeric), ~ as.numeric(as.character(.))),
           across(all_of(cols_integer64), ~ bit64::as.integer64(as.character(.))),
           across(all_of(cols_integer), ~ as.integer(as.character(.)))
    )


  # add geography cols
  temp_df <- add_geography_cols(arrw = temp_df, year = year)



  fname <- basename(txt_file)
  f_dest <- paste0('./data/microdata_sample/',year,"/", year,"_",gsub(".txt", ".parquet", fname))
  f_dest <- gsub(".TXT", ".parquet", f_dest)
  arrow::write_parquet(temp_df, f_dest)
  return(NULL)
}
