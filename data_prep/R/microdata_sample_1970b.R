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
  df <- arrow::read_csv_arrow('../../censobr_data_prep/data_raw/microdata/1970/Censo.1970.brasil.domicilios.amostra.25porcento.csv',
                              as_data_frame = FALSE,
                              col_types = arrow::schema(name = arrow::string()))
  #  head(df) |> collect()
  df <- collect(df)


  # # make all columns as character
  # df <- mutate(df, across(everything(), as.character))

  # rename columns
  df <- dplyr::rename(df,
               code_muni = municcode2010,
               code_muni_1970 = municcode1970,
               weight_household = wgthh,
               numb_dwellers = numberDwellers,
               numb_dwellers_hhincome = numberDwellers_hhIncome,
               hh_income = hhIncome,
               hh_income_per_cap = hhIncomePerCap
               )
  # rename cols
  df <- rename_with(df, toupper, starts_with("v"))


  # ## add geography variables ----------------------------------------------
  df <- mutate(df, code_state = substr(code_muni , 1, 2))
  df <- add_geography_cols(arrw = df, year = 1970)


  head(df) # |> collect()

  # make variables as numeric
  num_vars <- c('weight_household', 'hh_income', 'hh_income_per_cap')
  df <- mutate(df, across(all_of(num_vars),
                              ~ as.numeric(.x)))


  # drop CEM columns
  df <- select(df, -starts_with("CEM"))
  head(df) # |> collect()

  # rename id columns
  df <- dplyr::rename(df,
                      id_household = 'household_id')


  ## save single parquet tile ----------------------------------------------
  arrow::write_parquet(df, '../../censobr_data_prep/data/microdata_sample/1970/1970_households.parquet')


rm(list=ls())
gc(T)

# 2) Population data -----------------------------------------------------------

  # # read guide to parse the data
  # df <- arrow::read_csv_arrow('../../censobr_data_prep/data_raw/microdata/1970/Censo.1970.brasil.pessoas.amostra.25porcento.csv',
  #                             as_data_frame = FALSE,
  #                             col_types = schema(name = arrow::string()))
  #
  # gc(T)
  # f_parquet <- '../../censobr_data_prep/data_raw/microdata/1970/Censo.1970.brasil.pessoas.amostra.25porcento.parquet'
  # arrow::write_parquet(df, f_parquet)

  f_parquet <- '../../censobr_data_prep/data_raw/microdata/1970/Censo.1970.brasil.pessoas.amostra.25porcento_rogerioSetembro2024.csv'
  df <- arrow::open_csv_dataset(f_parquet)

  # read household ids
  df_ids <- arrow::read_csv_arrow('../../censobr_data_prep/data_raw/microdata/1970/crosswalk_personid_hhid.csv',
                              as_data_frame = FALSE,
                              col_types = schema(name = arrow::string()))

  # drop CEM columns
  df <- select(df, -starts_with("CEM"))
  df <- select(df, -starts_with("cem"))
  df <- select(df, -starts_with("iddomicilio"))
  names(df)


  # # make all columns as character
  # df <- mutate(df, across(everything(), as.character))
  # df_ids <- mutate(df_ids, across(everything(), as.character))

  # add household id
  df <- left_join(df, df_ids, by='idpessoa')
  df <- collect(df)

  # rename columns
  df <- rename(df,
               code_muni = MunicCode2010,
               code_muni_1970 = MunicCode1970
              )



  ##  add geography variables ----------------------------------------------
  df <- mutate(df, code_state = substr(code_muni , 1, 2))
  df <- add_geography_cols(arrw = df, year = 1970)


  head(df) # |> collect()

  # make variables as numeric
  num_vars <- c('V005', 'V020','V021', 'V041', 'V053', 'V054')
  df <- mutate(df, across(all_of(num_vars),
                          ~ as.numeric(.x)))


  # rename id columns
  df <- dplyr::rename(df,
                      id_person = 'idpessoa',
                      id_household = 'household_id')
  head(df) # |> collect()
  gc(T)


  ##  save single parquet tile ----------------------------------------------
  arrow::write_parquet(df, '../../censobr_data_prep/data/microdata_sample/1970/1970_population.parquet')

