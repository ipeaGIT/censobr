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

  # Define the dataset
  DS <- arrow::open_dataset(sources = parqt_files)
  # Create a scanner
  SO <- Scanner$create(DS)
  # Load it as n Arrow Table in memory
  AT <- SO$ToTable()
  rm(DS, SO); gc(T)

  ## 3.3) add geography variables ----------------------------------------------
  AT <- add_geography_cols(arrw = AT, year = 2010)

  head(AT) |> collect()

  ## 3.4) save single parquet tile ----------------------------------------------
  arrow::write_parquet(AT, './data/microdata_sample/2010/2010_households.parquet')






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

  # Define the dataset
  DS <- arrow::open_dataset(sources = parqt_files)
  # Create a scanner
  SO <- Scanner$create(DS)
  # Load it as n Arrow Table in memory
  AT <- SO$ToTable()
  rm(DS, SO); gc(T)

  ## 4.3) add geography variables ----------------------------------------------
  AT <- add_geography_cols(arrw = AT, year = 2010)

  head(AT) |> collect()

  ## 4.4) save single parquet tile ----------------------------------------------
  arrow::write_parquet(AT, './data/microdata_sample/2010/2010_population.parquet')









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
  # Create a scanner
  SO <- Scanner$create(DS)
  # Load it as n Arrow Table in memory
  AT <- SO$ToTable()
  rm(DS, SO); gc(T)


  ## 5.3) add geography variables ----------------------------------------------
  AT <- add_geography_cols(arrw = AT, year = 2010)

  head(AT) |> collect()

  ## 5.4) save single parquet tile ----------------------------------------------
  arrow::write_parquet(AT, './data/microdata_sample/2010/2010_mortality.parquet')





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
  # Create a scanner
  SO <- Scanner$create(DS)
  # Load it as n Arrow Table in memory
  AT <- SO$ToTable()
  rm(DS, SO); gc(T)

  ## 6.3) add geography variables ----------------------------------------------
  AT <- add_geography_cols(arrw = AT, year = 2010)

  head(AT) |> collect()

  ## 6.4) save single parquet tile ----------------------------------------------
  arrow::write_parquet(AT, './data/microdata_sample/2010/2010_emigration.parquet')



