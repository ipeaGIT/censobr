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
source('./R/add_geography_cols.R')

options(scipen = 999)

# ### 1) download raw data from IBGE ftp -------------------------------------------
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
#              )
#     }
# }
#
# download_tract(2010)
#
#
#
# ## 1.2) unzip all files ------
#
#    # manually ffs





# 2) Rename files to lowercase  ----------------------------

# list all excel files
all_csv_files <- list.files(path = './data_raw/tracts/2010',
                            full.names = T, recursive = T,
                            pattern = '.xls|.XLS')

# update extension from XLS to xls
file_to_rename <- all_csv_files[all_csv_files %like% '.XLS']
file.rename(file_to_rename, str_replace_all(file_to_rename, '.XLS', '.xls'))


all_csv_files <- list.files(path = './data_raw/tracts/2010',
                            full.names = T, recursive = T,
                            pattern = '.xls')

# rename file of Alagoas pessoa05
file_to_rename <- all_csv_files[all_csv_files %like% 'pessoa']
file.rename(file_to_rename, str_replace_all(file_to_rename, 'pessoa', 'Pessoa'))

file_to_rename <- all_csv_files[all_csv_files %like% 'responsavel']
file.rename(file_to_rename, str_replace_all(file_to_rename, 'responsavel', 'Responsavel'))




# 3) support functions  ----------------------------

### merge tables in the same state

prep_state <- function(abbrev, tabl){

  # abbrev = "SP_Exceto_"   abbrev = "CE_"   tabl = t

  message(abbrev)

  # select files from uf
  uf_files <- csv_tables[csv_tables %like% abbrev]

  # read all tables into a list
  df_list <- lapply(X=uf_files, FUN=read_and_rename, tabl = tabl)

  # left join them all
  if (length(df_list)>1) {
    temp_uf <- purrr::reduce(.x = df_list, .f = dplyr::left_join, by=c('code_muni', 'code_tract'))
  }
  if (length(df_list)==1) {
    temp_uf <- rbindlist(df_list, fill=TRUE)
  }

  gc(T)
  # return(temp_uf)
  fname <- paste0(tabl,'_tracts_', abbrev, '.parquet')
  arrow::write_parquet(temp_uf, paste0('./data/tracts/2010/', fname))

}

### read and rename tables

read_and_rename <- function(f, tabl){ # f = uf_files[7]

  ### replace "X" with NA
  ### delete a couple of tracts with ÿ caracter

  # 6666
  # f = "./data_raw/tracts/2010/CE_20171016/CE/Base informaçoes setores2010 universo CE/CSV/Pessoa07_CE.csv"
  # f = "./data_raw/tracts/2010/CE_20231030/Base informaçoes setores2010 universo CE/CSV/Basico_CE.csv"
  # f = './data_raw/tracts/2010/CE_20231030/Base informaçoes setores2010 universo CE/EXCEL/Basico_CE.xls'



    # f = "./data_raw/tracts/2010/RO_20231030/Base informaçoes setores2010 universo RO/EXCEL/Entorno05_RO.xls"
  # f = "./data_raw/tracts/2010/CE_20231030/Base informaçoes setores2010 universo CE/EXCEL/Entorno05_CE.xls"

  message(f)

  # detect state
  st <- str_trim(str_extract(f, "([:upper:][:upper:])")) |> unique()

  # determine encoding
  enc <- ifelse(st=='ES', 'UTF-8', 'Latin-1')

  # read data
    temp_df <- readxl::read_xls(f)
  # temp_df <- data.table::fread(f, fill=T, encoding = enc, colClasses = 'character')
  # temp_df <- vroom::vroom(f, delim = ';')


  # determine columns with 100% of NA and drop them
  setDT(temp_df)
  all_NA_cols <- sapply(temp_df, function(x)all(is.na(x)))
  all_NA_cols <- names(all_NA_cols[all_NA_cols > 0])
  if(length(all_NA_cols)>0){ temp_df[, {{all_NA_cols}} := NULL] }

  # all columns to character
  for(col in names(temp_df)) {
    set(temp_df, j = col, value = as.character(temp_df[[col]]))
  }

  # detect error with character 'ÿ' and replace observations with NA
  # Pessoa07_CE.xls¨
  # Entorno05_RO.xls
  row_pos <- temp_df |> map(~str_detect(.x,'ÿ')) |> reduce(`|`)
  n_rows <- sum(row_pos, na.rm = T)

  if (n_rows > 0){
    message(paste0('ÿÿÿÿÿÿ detected in '), f)
    # stop('error')
    ## replace all with empty space
    temp_df <- temp_df |> mutate_all(funs(str_replace_all(., "ÿ", "")))
  }

  #   # replace all with empty space
  #   temp_df2 <- temp_df |> mutate_all(funs(str_replace_all(., "ÿ", "")))
  #
  #   # temp_df2[24, c('V032')] |> nchar()
  #
  # # replace entire cell with NA
  #   temp_df[apply(temp_df, 2, function(i) grepl('ÿ', i))] <- NA


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

  if( tabl == 'Pessoa' | tabl == 'Domicilio' | tabl == 'Responsavel' | tabl == 'Entorno'){
    cols_to_rename <- names(temp_df)[3:ncol(temp_df)]
    names(temp_df)[3:ncol(temp_df)] <- paste0(root_name,'_', cols_to_rename)
  }
  return(temp_df)
}



# 3) Create 1 parquet file for each table / state -----------------------------------------------------------

# update list of all csv files
all_csv_files <- list.files(path = './data_raw/tracts/2010',
                            full.names = T, recursive = T,
                            pattern = '.xls')


# get all tables
root_names <- basename(all_csv_files)
root_names <- stringr::str_split(root_names, '_', simplify = TRUE)[,1]
table_names <- str_replace_all(root_names, "[:digit:]", "") |> unique()
table_names <- table_names[!grepl("-MG.csv",table_names)]  |> unique()
table_names


# get all states
all_states <- str_trim(str_extract(all_csv_files, "([:upper:][:upper:])")) |> unique()
if (isFALSE(length(all_states) == 27)) {stop('Error')}

# fix SP state
all_states <- all_states[!grepl("SP",all_states)]
all_states <- c(all_states, 'SP_Capital', 'SP_Exceto')
all_states

all_states <- paste0(all_states, '_')


for (t in table_names){ # t = 'Basico'         t = 'Pessoa'

  message(t)

  csv_tables <- all_csv_files[all_csv_files %like% t]

  root_names <- basename(csv_tables)

  if( t == 'Pessoa' | t == 'Domicilio' | t == 'Responsavel' | t == 'Entorno'){
    csv_tables <- csv_tables[ str_detect(root_names, "([:digit:][:digit:])") ]
  }

  # process each state
  pblapply(X = all_states, FUN = prep_state, tabl = t)
  # final_list <- pblapply(X = all_states, FUN = prep_state)
  #
  # # final_list[[8]]$`Cod_Grandes RegiÃµes`
  # # final_list[[1]]$`Cod_Grandes Regiões`
  #
  # # rbind all states
  # final_df <- data.table::rbindlist(final_list, use.names=TRUE)
  # gc(T)
  #
  # # save data
  # arrow::write_parquet(final_df, paste0('./data/tracts/2010/2010_tracts', t, '.parquet'))
  # rm(final_df)
  # gc(T)
  }






# 4) create national data - 1 parquet file for each table -----------------------------------------------------------

### rowbind across states

files <- list.files(path = './data/tracts/2010', full.names = T)

# get all tables
root_names <- basename(files)
table_names <- stringr::str_extract(root_names, "[^_]+") |> unique()
table_names <- paste0(table_names, '_')
table_names <- table_names[!grepl("2010_",table_names)]  |> unique()
table_names

table_names <- table_names[!grepl("clean_",table_names)]
table_names



bind_all <- function(tbl){ # tbl = 'DomicilioRenda_'  tbl = 'Pessoa_'

  message(tbl)

  # select type
  temp_f <- files[files %like% tbl]
  #  temp_f <- temp_f[c(1,5:8)]


  ## Define the dataset
  DS <- arrow::open_dataset(sources = temp_f)
  #  DS <- arrow::open_dataset(sources = temp_f[2])

  ## Create a scanner
  SO <- Scanner$create(DS)

  ## Load it as Arrow Table in memory
  AT <- SO$ToTable()

      # # Convert it to an R data frame
      # AT <- as.data.frame(AT)
      # head(AT)

  # make all columns as character
  AT <- mutate(AT, across(everything(), as.character))


  # add code_weighting
  cross <- fread('./data_raw/tracts/2010/composicao_areas_ponderacao_2010.txt', colClasses = 'character')
  AT <- left_join(AT, cross, by = 'code_tract')

  # add geography variables
  if(tbl != 'Basico_'){
    AT <- add_geography_cols_tracts(AT, year = 2010)
  }


  # rename columns
  if(tbl == 'Basico_'){

    options(scipen = 999)

    AT <- dplyr::mutate(AT, code_state = as.character(substr(code_muni, 1, 2)),
                            Cod_subdistrito = as.numeric(Cod_subdistrito))
    AT <- dplyr::mutate(AT, Cod_subdistrito = (format(as.character(Cod_subdistrito), scientific = FALSE)))
    # head(AT) |> collect()

    AT <- dplyr::rename(AT,
                        code_tract = code_tract,
                       # code_muni = Cod_municipio,
                        name_muni = Nome_do_municipio,
                        abbrev_state = Cod_UF ,
                        name_state = Nome_da_UF ,
                        code_state = code_state,
                        code_region = `Cod_Grandes Regiões`,
                        name_region = Nome_Grande_Regiao,
                        code_meso = Cod_meso,
                        name_meso = Nome_da_meso,
                        code_micro = Cod_micro,
                        name_micro = Nome_da_micro,
                        code_metro = Cod_RM,
                        name_metro = Nome_da_RM,
                        name_neighborhood = Nome_do_bairro,
                        code_neighborhood = Cod_bairro,
                        code_district = Cod_distrito,
                        name_district = Nome_do_distrito,
                        code_subdistrict = Cod_subdistrito,
                        name_subdistrict = Nome_do_subdistrito,
                        Basico_V1005 = Situacao_setor
                       # , tipo_setor = Tipo_setor
                        )

    ## reoder columns
    AT <- relocate(AT, c(code_tract, code_weighting, code_muni, name_muni, code_state,
                               abbrev_state, name_state, code_region, name_region,
                               code_meso, name_meso, code_micro, name_micro,
                               code_metro, name_metro, name_neighborhood,
                               code_neighborhood, name_neighborhood,
                               code_neighborhood, Basico_V1005 # , tipo_setor
                         ))

    }


  # rename column Situacao_setor
  all_cols <- names(AT)
  old_names <- all_cols[str_detect(all_cols, 'Situacao_setor')]

  if(tbl == 'Entorno_'){ AT <- select(AT, -c(entorno05_V1005)) }

  AT <- rename_with(AT,
                     ~gsub('Situacao_setor', 'V1005', .x),
                     .cols = all_of(old_names)
                    )
  # AT <-  dplyr::rename_with(AT, ~gsub("Situacao_setor", "V1005", .x))

  message('to numeric')

  # fix missing values ("X") and then convert to numeric
  vars <- names(AT)
  vars <- vars[grep('V', vars)]

  AT <- mutate(AT, across(all_of(vars),
                          ~ as.character(.x)))
  AT <- mutate(AT, across(all_of(vars),
                          ~ if_else(.x=='X', NA_character_, .x)))
  AT <- mutate(AT, across(all_of(vars),
                          ~ as.numeric(.x)))



  message('saving')
  # save
  dest_file <- paste0('2010_tracts_', tbl, '.parquet')
  system.time(
    arrow::write_parquet(AT, paste0('./data/tracts/2010/clean/', dest_file))
              )

  return(NULL)
}


bind_all(tbl = 'Basico_')
bind_all(tbl = 'Entorno_')
bind_all(tbl = 'Pessoa_')

lapply(X=table_names, FUN = bind_all)



a <- arrow::read_parquet("./data/tracts/2010/clean/2010_tracts_Pessoa_.parquet")
head(a)
names(a)

domicilio 2
entorno 5
domiciliorenda 1
pessoa 13
Responsavel 2
