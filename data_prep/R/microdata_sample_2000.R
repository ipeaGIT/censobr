library(arrow)
library(dplyr)
library(readr)
library(data.table)
library(pbapply)

data.table::setDTthreads(percent = 100)
source('./R/convert_raw_to_parquet.R')
source('./R/add_geography_cols.R')


# 1) download raw data from IBGE ftp ----------------------------------------------

# 2) unzip all files ----------------------------------------------

data_dir <- 'R:/Dropbox/bases_de_dados/censo_demografico/censo_2000/microdados_txt'
txt_files <- list.files(path = data_dir,
                        pattern = '.zip',
                        recursive = TRUE,
                        full.names = TRUE)

lapply(X=txt_files,
       FUN = function(x){ unzip(zipfile = x, exdir = data_dir)}
       )

# 3) Households data ----------------------------------------------

    ## 3.1) Parse every file and covert them to parquet --------------------------

  # read guide to parse the data
  dic <- fread('./read_guides/readguide_2000_households.csv')
  head(dic)

  # list all files
  txt_files <- list.files('R:/Dropbox/bases_de_dados/censo_demografico/censo_2000/microdados_txt',
                          pattern = 'Dom[[:digit:]]|DOM',
                          recursive = TRUE,
                          full.names = TRUE)
  # parse and save
  pbapply::pblapply(X=txt_files, FUN = convert_raw_to_parquet, year=2000, dic=dic)


  ## 3.2) read all files and pile them up --------------------------------------
  parqt_files <- list.files('./data/microdata_sample/2000/',
                            pattern = 'Dom[[:digit:]]|DOM',
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

  # # drop row if all columns are NA
  AT <- filter(AT, !is.na(PESO_DOMIC))

  AT <- add_geography_cols(arrw = AT, year = 2000)

  head(AT) |> collect()

  ## 3.4) save single parquet tile ----------------------------------------------
  arrow::write_parquet(AT, './data/microdata_sample/2000/2000_households.parquet')






# 4) Prep population data ----------------------------------------------

  ## 4.1) Parse every file and covert them to parquet --------------------------

  # read guide to parse the data
  dic <- fread('./read_guides/readguide_2000_population.csv')
  head(dic)

  # list all files
  txt_files <- list.files('R:/Dropbox/bases_de_dados/censo_demografico/censo_2000/microdados_txt',
                          pattern = 'Pes[[:digit:]]|PES|pes',
                          recursive = TRUE,
                          full.names = TRUE)
  # parse and save
  pbapply::pblapply(X=txt_files, FUN = convert_raw_to_parquet, year=2000, dic=dic)


  ## 4.2) read all files and pile them up --------------------------------------
  parqt_files <- list.files('./data/microdata_sample/2000/',
                            pattern = 'Pes[[:digit:]]|PES|pes',
                            recursive = TRUE,
                            full.names = TRUE)

  # Define the dataset
  DS <- arrow::open_dataset(sources = parqt_files)
  # Create a scanner
  SO <- arrow::Scanner$create(DS)
  # Load it as n Arrow Table in memory
  AT <- SO$ToTable()
  rm(DS, SO, parqt_files); gc(T)


  gc()
  AT <- collect(AT)

  # due to memory limit, I had to first save it to csv, and then convert it to parquet
  data.table::fwrite(AT, './data/microdata_sample/2000/2000_population.csv')

  ## 4.3) add geography variables ----------------------------------------------

  df <- arrow::open_csv_dataset('./data/microdata_sample/1991/1991_population.csv')

  # # # drop row if all columns are NA
  # AT <- filter(AT, !is.na(PES_PESSOA))
  # gc(T)

  AT <- add_geography_cols(arrw = AT, year = 2000)

  head(AT) |> collect()

  ## 4.4) save single parquet tile ----------------------------------------------
  AT <- AT |> collect()
  gc(T)
  gc(T)
  gc(T)
  gc(T)
  arrow::write_parquet(AT, './data/microdata_sample/2000/2000_population.parquet')











# 5) Families data ----------------------------------------------

  ## 5.1) Parse every file and covert them to parquet --------------------------

  # read guide to parse the data
  dic <- fread('./read_guides/readguide_2000_families.csv')
  head(dic)

  # list all files
  txt_files <- list.files('R:/Dropbox/bases_de_dados/censo_demografico/censo_2000/microdados_txt',
                          pattern = 'FAMI[[:digit:]]',
                          recursive = TRUE,
                          full.names = TRUE)
  # parse and save
  pbapply::pblapply(X=txt_files, FUN = convert_raw_to_parquet, year=2000, dic=dic)


  ## 5.2) read all files and pile them up --------------------------------------
  parqt_files <- list.files('./data/microdata_sample/2000/',
                            pattern = 'FAMI[[:digit:]]',
                            recursive = TRUE,
                            full.names = TRUE)

  # Define the dataset
  DS <- arrow::open_dataset(sources = parqt_files)
  # Create a scanner
  SO <- arrow::Scanner$create(DS)
  # Load it as n Arrow Table in memory
  AT <- SO$ToTable()
  rm(DS, SO); gc(T)

  ## 5.3) add geography variables ----------------------------------------------

  # # drop row if all columns are NA
  AT <- filter(AT, !is.na(P001))

  AT <- add_geography_cols(arrw = AT, year = 2000)

  head(AT) |> collect()

  ## 5.4) save single parquet tile ----------------------------------------------
  arrow::write_parquet(AT, './data/microdata_sample/2000/2000_families.parquet')



