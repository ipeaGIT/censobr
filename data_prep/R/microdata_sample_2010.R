library(arrow)
library(dplyr)
library(readr)
library(data.table)
library(pbapply)

data.table::setDTthreads(percent = 100)
source('./R/convert_raw_to_parquet.R')
source('./R/add_geography_cols.R')


# 1) download raw data from IBGE ftp -------------------------------------------

# 2) unzip all files -----------------------------------------------------------

# 3) Households data -----------------------------------------------------------

  ## 3.1) Parse every file and covert them to parquet --------------------------

  # read guide to parse the data
  dic <- fread('./read_guides/readguide_2010_households.csv')
  head(dic)


  # list all files
  txt_files <- list.files('R:/Dropbox/bases_de_dados/censo_demografico/censo_2010/data/dados_txt2010/Microdados',
                          pattern = 'Domicilios_[[:digit:]]',
                          recursive = TRUE,
                          full.names = TRUE)
  # parse and save
  pbapply::pblapply(X=txt_files, FUN = convert_raw_to_parquet, year=2010, dic=dic)


  ## 3.2) read all files and pile them up --------------------------------------
  parqt_files <- list.files('./data/microdata_sample/2010/',
                            pattern = 'Domicilios_[[:digit:]]',
                            recursive = TRUE,
                            full.names = TRUE)

  # building schema: unite columns
  dic[, col_class := fcase(decimal_places>0, 'numeric(),',
                           between(length, 1, 2) & is.na(decimal_places), 'uint8(),',
                           between(length, 3, 4) & is.na(decimal_places), 'uint8(),',
                           between(length, 5, 9) & is.na(decimal_places), 'uint32(),',
                           length > 9 & is.na(decimal_places), 'uint64(),',
                           default= 'string(),')]

  schema_tbl <- dic[,. (var_name, col_class)] |> unique()
  u <- tidyr::unite(schema_tbl, col = 'col_class', sep = ' = ')

  # build text expression
  schema_string <- paste0('arrow::schema(code_muni = int32(), code_state = int8(),abbrev_state = string(),name_state = string(),code_region = int8(),name_region = string(),code_weighting = string(),',
                          paste0(unlist(u$col_class), collapse = " "),
                          ')')

  # remove last comma
  schema_string <- gsub(",)$", ")", schema_string)

  # Define the dataset
  ds <- arrow::open_dataset(
    sources = parqt_files,
    schema = eval(str2lang(schema_string))
    )


  ## 3.4) save single parquet tile ----------------------------------------------
  # AT |> collect() |>
  arrow::write_parquet(ds, './data/microdata_sample/2010/2010_households_uINT3.parquet')

  arrow::write_parquet(
    x = ds,
    sink = './data/microdata_sample/2010/2010_households.parquet',
    compression='zstd',
    compression_level = 22)







# 4) Population data ----------------------------------------------

  ## 4.1) Parse every file and covert them to parquet ----------------------------------------------

  # read guide to parse the data
  dic <- fread('./read_guides/readguide_2010_population.csv')
  head(dic)

  # list all files
  txt_files <- list.files('R:/Dropbox/bases_de_dados/censo_demografico/censo_2010/data/dados_txt2010/Microdados',
                          pattern = 'Pessoas_[[:digit:]]',
                          recursive = TRUE,
                          full.names = TRUE)
  # parse and save
  pbapply::pblapply(X=txt_files, FUN = convert_raw_to_parquet, year=2010, dic=dic)


  ## 4.2) read all files and pile them up ----------------------------------------------
  parqt_files <- list.files('./data/microdata_sample/2010/',
                            pattern = 'Pessoas_[[:digit:]]',
                            recursive = TRUE,
                            full.names = TRUE)

  # building schema: unite columns
  dic[, col_class := fcase(decimal_places>0, 'numeric(),',
                           between(length, 1, 2) & is.na(decimal_places), 'int8(),',
                           between(length, 3, 4) & is.na(decimal_places), 'int16(),',
                           between(length, 5, 9) & is.na(decimal_places), 'int32(),',
                           length > 9 & is.na(decimal_places), 'int64(),',
                           default= 'string(),')]

  schema_tbl <- dic[,. (var_name, col_class)] |> unique()
  u <- tidyr::unite(schema_tbl, col = 'col_class', sep = ' = ')

  # build text expression
  schema_string <- paste0('arrow::schema(code_muni = int32(), code_state = int8(),abbrev_state = string(),name_state = string(),code_region = int8(),name_region = string(),code_weighting = string(),',
                          paste0(unlist(u$col_class), collapse = " "),
                          ')')

  # remove last comma
  schema_string <- gsub(",)$", ")", schema_string)


  # Define the dataset
  ds <- arrow::open_dataset(sources = parqt_files)

  ## 4.3) add geography variables ----------------------------------------------
  AT <- add_geography_cols(arrw = ds, year = 2010)

  # apply schema
  AT <- arrow::as_arrow_table(AT,
                              schema = eval(str2lang(schema_string))
  )


  schema(AT)

  ## 4.4) save single parquet tile ----------------------------------------------
  arrow::write_parquet(
    x = DS,
    sink = './data/microdata_sample/2010/2010_population.parquet',
    compression='zstd',
    compression_level = 22)



a <-   arrow::open_dataset('./data/microdata_sample/2010/2010_population_v0.3.0.parquet'
                          # , schema = s
                           )

schema(a)



 b<-  arrow::open_dataset('./data/microdata_sample/2010/2010_population_INT.parquet')

schema(b)


# 5) Mortality data ----------------------------------------------

  ## 5.1) Parse every file and covert them to parquet ----------------------------------------------

  # read guide to parse the data
  dic <- fread('./read_guides/readguide_2010_mortality.csv')
  head(dic)

  # list all files
  txt_files <- list.files('R:/Dropbox/bases_de_dados/censo_demografico/censo_2010/data/dados_txt2010/Microdados',
                          pattern = 'Mortalidade_[[:digit:]]',
                          recursive = TRUE,
                          full.names = TRUE)
  # parse and save
  pbapply::pblapply(X=txt_files, FUN = convert_raw_to_parquet, year=2010, dic=dic)



  ## 5.2) read all files and pile them up ----------------------------------------------
  parqt_files <- list.files('./data/microdata_sample/2010/',
                            pattern = 'Mortalidade_[[:digit:]]',
                            recursive = TRUE,
                            full.names = TRUE)

  # Define the dataset
  DS <- arrow::open_dataset(sources = parqt_files)
  # # Create a scanner
  # SO <- Scanner$create(DS)
  # # Load it as n Arrow Table in memory
  # AT <- SO$ToTable()
  # rm(DS, SO); gc(T)
  #
  #
  # ## 5.3) add geography variables ----------------------------------------------
  # AT <- add_geography_cols(arrw = AT, year = 2010)
  #
  # head(AT) |> collect()

  ## 5.4) save single parquet tile ----------------------------------------------
  arrow::write_parquet(
    x = DS,
    sink = './data/microdata_sample/2010/2010_mortality.parquet',
    compression='zstd',
    compression_level = 22)

a <- read_parquet('./data/microdata_sample/2010/2010_mortality.parquet')


# 6) Emigration data ----------------------------------------------

  ## 5.1) read all files and pile them up ----------------------------------------------

  # read guide to parse the data
  dic <- fread('./read_guides/readguide_2010_emigration.csv')
  head(dic)

  # list all files
  txt_files <- list.files('R:/Dropbox/bases_de_dados/censo_demografico/censo_2010/data/dados_txt2010/Microdados',
                          pattern = 'Emigracao_[[:digit:]]',
                          recursive = TRUE,
                          full.names = TRUE)
  # parse and save
  pbapply::pblapply(X=txt_files, FUN = convert_raw_to_parquet, year=2010, dic=dic)


  ## 3.2) read all files and pile them up ----------------------------------------------
  parqt_files <- list.files('./data/microdata_sample/2010/',
                            pattern = 'Emigracao_[[:digit:]]',
                            recursive = TRUE,
                            full.names = TRUE)

  # Define the dataset
  DS <- arrow::open_dataset(sources = parqt_files)

  ## 6.4) save single parquet tile ----------------------------------------------
  arrow::write_parquet(
    x = DS,
    sink = './data/microdata_sample/2010/2010_emigration.parquet',
    compression='zstd',
    compression_level = 22)


a <- read_parquet('./data/microdata_sample/2010/2010_emigration.parquet')
head(a)
