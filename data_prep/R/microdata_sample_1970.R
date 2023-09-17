library(arrow)
library(dplyr)
library(readr)
library(data.table)
library(pbapply)

data.table::setDTthreads(percent = 100)
source('./R/add_geography_cols.R')


# 1) Households data -----------------------------------------------------------


  # read guide to parse the data
  # df <- fread('./data_raw/microdata/1970/Censo.1970.brasil.domicilios.amostra.25porcento.csv')
  df <- arrow::read_csv_arrow('./data_raw/microdata/1970/Censo.1970.brasil.domicilios.amostra.25porcento.csv',
                              as_data_frame = FALSE,
                              col_types = schema(name = arrow::string()))
  head(df) |> collect()


  # # make all columns as character
  # df <- mutate(df, across(everything(), as.character))

  # rename columns
  df <- rename(df,
               code_muni = MunicCode2010,
               code_muni_1970 = MunicCode1970,
               V005 = CEM001, # TOTAL TOTAL DE PESSOAS NO DOMICÍLIO
               V041 = CEM003 # RENDA DOMICILIAR (mensal medio)
               )

  ## add geography variables ----------------------------------------------
  df <- mutate(df, code_state = substr(code_muni , 1, 2))
  df <- add_geography_cols(arrw = df, year = 1970)


  head(df) |> collect()

  # make variables as numeric
  num_vars <- c('V005', 'V020','V021', 'V041', 'V054')
  df <- mutate(df, across(all_of(num_vars),
                              ~ as.numeric(.x)))

 ## FALTANDO
 # V053	QUANTIDADE DE FILHOS QUE NASCERAM VIVOS E CONTINUAM VIVOS

  # drop CEM columns
  df <- select(df, -starts_with("CEM"))
  head(df) |> collect()


  ## save single parquet tile ----------------------------------------------
  arrow::write_parquet(df, './data/microdata_sample/1970/1970_households.parquet')


rm(list=ls())
gc(T)

# 2) Population data -----------------------------------------------------------

  # # read guide to parse the data
  # df <- arrow::read_csv_arrow('./data_raw/microdata/1970/Censo.1970.brasil.pessoas.amostra.25porcento.csv',
  #                             as_data_frame = FALSE,
  #                             col_types = schema(name = arrow::string()))
  #
  # gc(T)
  # f_parquet <- './data_raw/microdata/1970/Censo.1970.brasil.pessoas.amostra.25porcento.parquet'
  # arrow::write_parquet(df, f_parquet)

  f_parquet <- './data_raw/microdata/1970/Censo.1970.brasil.pessoas.amostra.25porcento.parquet'
  df <- arrow::open_dataset(f_parquet)

  head(df) |> collect()

  # make all columns as character
  df <- mutate(df, across(everything(), as.character))

  # rename columns
  df <- rename(df,
               code_muni = MunicCode2010,
               code_muni_1970 = MunicCode1970
              #  ,V005 = cem001, # TOTAL TOTAL DE PESSOAS NO DOMICÍLIO
              # V041 = cem003 # RENDA DOMICILIAR (mensal medio)
              )

  ##  add geography variables ----------------------------------------------
  df <- mutate(df, code_state = substr(code_muni , 1, 2))
  df <- add_geography_cols(arrw = df, year = 1970)


  head(df) |> collect()

  # make variables as numeric
  num_vars <- c('V005', 'V020','V021', 'V041', 'V053', 'V054')
  df <- mutate(df, across(all_of(num_vars),
                          ~ as.numeric(.x)))


  # drop CEM columns
  df <- select(df, -starts_with("CEM"))
  df <- select(df, -starts_with("cem"))
  head(df) |> collect()

  gc(T)

  ##  save single parquet tile ----------------------------------------------
  arrow::write_parquet(df, './data/microdata_sample/1970/1970_population.parquet')

