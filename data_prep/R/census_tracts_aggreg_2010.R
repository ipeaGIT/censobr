library(arrow)
library(dplyr)
library(readr)
library(data.table)
library(pbapply)
library(rvest)
library(purrr)
library(stringr)
library(readxl)

data.table::setDTthreads(percent = 100)


# 1) download raw data from IBGE ftp -------------------------------------------
#
# download_tract <- function(year){ # year = 2010
#
#   message(paste0("\nDownloading year: ", year, '\n'))
#
#   # create dir if it has not been created already
#   dest_dir <- paste0('./data_raw/tracts/', year)
#   if (isFALSE(dir.exists(dest_dir))) { dir.create(dest_dir,
#                                                   recursive = T,
#                                                   showWarnings = FALSE) }
#
#   # get ftp
#   if(year==2010){
#     ftp <- 'https://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Resultados_do_Universo/Agregados_por_Setores_Censitarios/'
#   }
#
#   # get file names
#   h <- rvest::read_html(ftp)
#   elements <- rvest::html_elements(h, "a")
#   files <- rvest::html_attr(elements, "href")
#   filenameext <- files[ data.table::like(files, '.zip') ]
#
#   # Download zipped files
#   for (i in filenameext){
#
#     tempf <- paste0(dest_dir, '/', i)
#     httr::GET(url = paste0(ftp, i),
#               httr::progress(),
#               httr::write_disk(tempf, overwrite = T),
#               config = httr::config(ssl_verifypeer = FALSE)
#               )
#     }
#
#
#
#   # 1.2) unzip all files -------------------------------------------------------
#
#    # manually ffs
#         #
#         # message(paste0("\nUnzipping year: ", year, '\n'))
#         #
#         # all_zip <- list.files(dest_dir, pattern = '.zip', full.names = T, recursive = T)
#         # all_zip <- all_zip[!(all_zip %like% 'Documentacao')]
#         #
#         # Sys.setlocale("LC_ALL", "C")
#         #
#         #
#         #
#         # # pblapply(X=all_zip, FUN =
#         #
#         #
#         # #function(z){ # z=all_zip[27]
#         #
#         # # get names of csv files inside zip
#         # zipped_csv <- unzip(z, list=TRUE)$Name
#         # zipped_csv <- zipped_csv[zipped_csv %like% 'csv']
#         #
#         # unzip(z,files = zipped_csv, exdir = dest_dir)
#         # #}
#         #
#
#
#
#
# }
#

# ### delete all excel files
# xls_files <- list.files(path = './data_raw/tracts/2010',
#                         full.names = T, recursive = T,
#                         pattern = '.xls')
#
# file.remove(xls_files)
# rm(xls_files)


# 3) Households data -----------------------------------------------------------

# list all csv files
all_csv_files <- list.files(path = './data_raw/tracts/2010',
                        full.names = T, recursive = T,
                        pattern = '.xls')

# rename file of Alagoas pessoa05
file_to_rename <- all_csv_files[all_csv_files %like% 'pessoa']
file.rename(file_to_rename, str_replace_all(file_to_rename, 'pessoa', 'Pessoa'))

file_to_rename <- all_csv_files[all_csv_files %like% 'responsavel']
file.rename(file_to_rename, str_replace_all(file_to_rename, 'responsavel', 'Responsavel'))

# update list of all csv files
all_csv_files <- list.files(path = './data_raw/tracts/2010',
                            full.names = T, recursive = T,
                            pattern = '.xls')

# get all tables
root_names <- basename(all_csv_files)
root_names <- stringr::str_split(root_names, '_', simplify = TRUE)[,1]
table_names <- str_replace_all(root_names, "[:digit:]", "") |> unique()
table_names


# get all states
all_states <- str_trim(str_extract(all_csv_files, "([:upper:][:upper:])")) |> unique()
if(isFALSE(length(all_states) == 27)){ stop('Error')}

# fix SP state
all_states <- all_states[!grepl("SP",all_states)]
all_states <- c(all_states, 'SP_Capital', 'SP_Exceto')
all_states

all_states <- paste0(all_states, '_')

# remove CE
all_states <- all_states[!grepl("CE",all_states)]


for (t in table_names){ # t = 'Basico'

  message(t)

  csv_tables <- all_csv_files[all_csv_files %like% t]

  root_names <- basename(csv_tables)

  if( t == 'Pessoa' | t == 'Domicilio' | t == 'Responsavel'){
    csv_tables <- csv_tables[ str_detect(root_names, "([:digit:][:digit:])") ]
  }

  # process each state
  final_list <- pblapply(X = all_states, FUN = prep_state)

  # final_list[[8]]$`Cod_Grandes RegiÃµes`
  # final_list[[1]]$`Cod_Grandes Regiões`

  # rbind all states
  final_df <- data.table::rbindlist(final_list, use.names=TRUE)
  gc(T)

  # save data
  arrow::write_parquet(final_df, paste0('./data/tracts/2010/2010_tracts', t, '.parquet'))
  rm(final_df)
  gc(T)
  }




# df12 <- fread(csv_files[1])
# df12 <- fread(csv_files[12])
# df14 <- fread(csv_files[14])



### merge tables in the same state ----------------------------

prep_state <- function(abbrev){ # abbrev = "SP_Capital"     abbrev = "CE_"

  message(abbrev)

  # select files from uf
  uf_files <- csv_tables[csv_tables %like% abbrev]

  # read all tables into a list
  df_list <- lapply(X=uf_files, FUN=read_and_rename)

  # left join them all
  if (length(df_list)>1) {
    temp_uf <- purrr::reduce(.x = df_list, .f = dplyr::left_join, by=c('code_muni', 'code_tract'))
  }
  if (length(df_list)==1) {
    temp_uf <- rbindlist(df_list)
    }

  return(temp_uf)
}

### read and rename tables ----------------------------

read_and_rename <- function(f){ # f = uf_files[1]

#  f = "./data_raw/tracts/2010/CE_20171016/CE/Base informaçoes setores2010 universo CE/CSV/Pessoa07_CE.csv"
### replace "X" with NA
### delete a couple of tracts with ÿ caracter

# f = "./data_raw/tracts/2010/CE_20171016/CE/Base informaçoes setores2010 universo CE/CSV/Basico_CE.csv"
# f = "./data_raw/tracts/2010/BA_20171016/BA/Base informaçoes setores2010 universo BA/CSV/Basico_BA.csv"

  message(f)

  # detect state
  st <- str_trim(str_extract(f, "([:upper:][:upper:])")) |> unique()

  # determine encoding
  enc <- ifelse(st=='ES', 'UTF-8', 'Latin-1')

  # read data
  temp_df <- readxl::read_xls(f)
  # temp_df <- data.table::fread(f,  encoding = enc, sep = ';',dec = ',', fill=TRUE)
  # temp_df <- data.table::fread(f,  encoding = enc, sep = ';',dec = ',', fill=TRUE, nrows = 22328)
  # temp_df2 <- vroom::vroom(f, delim = ';')
  # temp_df <- read_csv2(f)


  # determine columns with 100% of NA and drop them
  setDT(temp_df)
  all_NA_cols <- sapply(temp_df, function(x)all(is.na(x)))
  all_NA_cols <- names(all_NA_cols[all_NA_cols > 0])
  if(length(all_NA_cols)>0){ temp_df[, {{all_NA_cols}} := NULL] }


  # get root of file name
  root_name <- basename(f)
  root_name <- substr(root_name, 1, nchar(root_name)-7)
  root_name <- gsub("_", "", root_name)
  root_name <- tolower(root_name)

  # rename columns
  setnames(temp_df, 'Cod_setor', 'code_tract')
  temp_df[, code_tract := as.character(code_tract)]
  temp_df[, code_muni := substr(code_tract, 1, 7)]
  setcolorder(temp_df, c('code_muni', 'code_tract'))

  cols_to_rename <- names(temp_df)[3:ncol(temp_df)]
  names(temp_df)[3:ncol(temp_df)] <- paste0(root_name,'_', cols_to_rename)


  return(temp_df)
}



### rowbind across states  ----------------------------


