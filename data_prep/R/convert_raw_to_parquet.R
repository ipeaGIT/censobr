# Parse raw txt file and save it in parquet format
#' @keywords internal
convert_raw_to_parquet <- function(year, txt_file, dic){ # txt_file <- txt_files[1]

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
  fname <- basename(txt_file)
  f_dest <- paste0('./data_prep/data/',year,"/", year,"_",gsub(".txt", ".parquet", fname))
  f_dest <- gsub(".TXT", ".parquet", f_dest)
  arrow::write_parquet(temp_df, f_dest)
  return(NULL)
}
