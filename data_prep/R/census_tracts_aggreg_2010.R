library(arrow)
library(dplyr)
library(readr)
library(data.table)
library(pbapply)
library(rvest)
library(purrr)
library(stringr)

data.table::setDTthreads(percent = 100)


# 1) download raw data from IBGE ftp -------------------------------------------

download_tract <- function(year){ # year = 2010

  message(paste0("\nDownloading year: ", year, '\n'))

  # create dir if it has not been created already
  dest_dir <- paste0('./data_raw/tracts/', year)
  if (isFALSE(dir.exists(dest_dir))) { dir.create(dest_dir,
                                                  recursive = T,
                                                  showWarnings = FALSE) }

  # get ftp
  if(year==2010){
    ftp <- 'https://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Resultados_do_Universo/Agregados_por_Setores_Censitarios/'
  }

  # get file names
  h <- rvest::read_html(ftp)
  elements <- rvest::html_elements(h, "a")
  files <- rvest::html_attr(elements, "href")
  filenameext <- files[ data.table::like(files, '.zip') ]

  # Download zipped files
  for (i in filenameext){

    tempf <- paste0(dest_dir, '/', i)
    httr::GET(url = paste0(ftp, i),
              httr::progress(),
              httr::write_disk(tempf, overwrite = T),
              config = httr::config(ssl_verifypeer = FALSE)
              )
    }



  # 1.2) unzip all files -------------------------------------------------------

   # manually ffs
        #
        # message(paste0("\nUnzipping year: ", year, '\n'))
        #
        # all_zip <- list.files(dest_dir, pattern = '.zip', full.names = T, recursive = T)
        # all_zip <- all_zip[!(all_zip %like% 'Documentacao')]
        #
        # Sys.setlocale("LC_ALL", "C")
        #
        #
        #
        # # pblapply(X=all_zip, FUN =
        #
        #
        # #function(z){ # z=all_zip[27]
        #
        # # get names of csv files inside zip
        # zipped_csv <- unzip(z, list=TRUE)$Name
        # zipped_csv <- zipped_csv[zipped_csv %like% 'csv']
        #
        # unzip(z,files = zipped_csv, exdir = dest_dir)
        # #}
        #




}


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
                        pattern = '.csv')

# rename file of Alagoas pessoa05
file_to_rename <- all_csv_files[all_csv_files %like% 'pessoa']
file.rename(file_to_rename, str_replace_all(file_to_rename, 'pessoa', 'Pessoa'))

file_to_rename <- all_csv_files[all_csv_files %like% 'responsavel']
file.rename(file_to_rename, str_replace_all(file_to_rename, 'responsavel', 'Responsavel'))

# update list of all csv files
all_csv_files <- list.files(path = './data_raw/tracts/2010',
                            full.names = T, recursive = T,
                            pattern = '.csv')

# get all tables
root_names <- basename(all_csv_files)
root_names <- stringr::str_split(root_names, '_', simplify = TRUE)[,1]
table_names <- str_replace_all(root_names, "[:digit:]", "") |> unique()
table_names


# get all states
all_states <- str_trim(str_extract(all_csv_files, "([:upper:][:upper:])")) |> unique()
if(isFALSE(length(all_states) == 27)){ stop('Error')}


for (t in table_names){ # i = 'Pessoa'

  csv_tables <- all_csv_files[all_csv_files %like% i]

  root_names <- basename(csv_tables)

  if( i == 'Pessoa' | i == 'Domicilio' | i == 'Responsavel'){
    csv_tables <- csv_tables[ str_detect(root_names, "([:digit:][:digit:])") ]
  }

  final_list <- pblapply(X = all_states, FUN = prep_state)
  final_df <- rb

}




# df12 <- fread(csv_files[1])
# df12 <- fread(csv_files[12])
# df14 <- fread(csv_files[14])



### merge tables in the same state ----------------------------

prep_state <- function(abbrev){ # abbrev = "RR"

  message(abbrev)

  # select files from uf
  uf_files <- csv_tables[csv_tables %like% abbrev]

  # read all tables into a list
  df_list <- lapply(X=uf_files, FUN=read_and_rename)

  # left joi them all
  temp_uf <- purrr::reduce(.x = df_list, .f = dplyr::left_join, by=c('code_muni', 'code_tract', 'Situacao_setor'))

  return(temp_uf)
}

### read and rename tables ----------------------------

read_and_rename <- function(f){ # f = csv_files[12]

  message(f)

  # read data
  temp_df <- fread(f)

  # determine columns with 100% of NA and drop them
  all_NA_cols <- sapply(temp_df, function(x)all(is.na(x)))
  all_NA_cols <- names(all_NA_cols[all_NA_cols > 0])
  temp_df[, {{all_NA_cols}} := NULL]


  # get root of file name
  root_name <- basename(f)
  root_name <- substr(root_name, 1, nchar(root_name)-7)
  root_name <- tolower(root_name)

  # rename columns
  cols_to_rename <- names(temp_df)[3:ncol(temp_df)]
  names(temp_df)[3:ncol(temp_df)] <- paste0(root_name,'_', cols_to_rename)

  setnames(temp_df, 'Cod_setor', 'code_tract')
  temp_df[, code_muni := substr(code_tract, 1, 7)]
  setcolorder(temp_df, c('code_muni', 'code_tract'))

  return(temp_df)
}



### rowbind across states  ----------------------------


