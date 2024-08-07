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
  data_dir <- 'R:/Dropbox/bases_de_dados/censo_demografico/censo_2000/microdados_txt'
  txt_files <- list.files(path = data_dir,
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

  # # drop row if all columns are NA
  AT <- filter(DS, !is.na(P001))

  ## 3.4) save single parquet tile ----------------------------------------------
  arrow::write_parquet(AT, './data/microdata_sample/2000/2000_households_new.parquet')






# 4) Prep population data ----------------------------------------------

  ## 4.1) Parse every file and covert them to parquet --------------------------

  # read guide to parse the data
  dic <- fread('./read_guides/readguide_2000_population.csv')
  head(dic)

  # list all files
  data_dir <- 'R:/Dropbox/bases_de_dados/censo_demografico/censo_2000/microdados_txt'
  txt_files <- list.files(data_dir,
                          pattern = 'Pes|PES|pes',
                          recursive = TRUE,
                          full.names = TRUE)
  # parse and save
  pbapply::pblapply(X=txt_files, FUN = convert_raw_to_parquet, year=2000, dic=dic)


  ## 4.2) read all files and pile them up --------------------------------------
  parqt_files <- list.files('./data/microdata_sample/2000/',
                            pattern = 'Pes[[:digit:]]|PES|pes',
                            recursive = TRUE,
                            full.names = TRUE)

  # open all files as a single dataset
  DS <- arrow::open_dataset(sources = parqt_files)

  ## 4.4) save single parquet tile ----------------------------------------------

  arrow::write_parquet(DS, './data/microdata_sample/2000/2000_population_new.parquet')


  old <-  arrow::open_dataset( './data/microdata_sample/2000/2000_population_v0.3.0_OLD.parquet')
 new <-  arrow::open_dataset( './data/microdata_sample/2000/2000_population.parquet')



 ncol(old)
 ncol(new)





# 5) Families data ----------------------------------------------

  ## 5.1) Parse every file and covert them to parquet --------------------------

  # read guide to parse the data
  dic <- fread('./read_guides/readguide_2000_families.csv')
  head(dic)

  # list all files
  data_dir <- 'R:/Dropbox/bases_de_dados/censo_demografico/censo_2000/microdados_txt'
  txt_files <- list.files(data_dir,
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

  # # drop row if all columns are NA
  AT <- filter(AT, !is.na(P001))


  ## 5.4) save single parquet tile ----------------------------------------------
  arrow::write_parquet(AT, './data/microdata_sample/2000/2000_families_new.parquet')



