library(arrow)
library(dplyr)
library(readr)
library(data.table)
library(pbapply)

data.table::setDTthreads(percent = 100)
source('./R/add_geography_cols.R')

cross_muni_code <- readxl::read_xlsx('./data_raw/microdata/1980/crosswalk_tocantins_ferNoronha_1980_2010.xlsx')

cross_muni_code$municCod1980 <- as.character(cross_muni_code$municCod1980)
cross_muni_code$municCod2010_6dig <- as.character(cross_muni_code$municCod2010_6dig)
head(cross_muni_code)

# 1) Households data -----------------------------------------------------------

# # get colnames
# temp <- fread('./data_raw/microdata/1980/Censo.1980.brasil.domicilios.amostra.25porcento.csv', nrows = 10)
# colnames <- names(temp)
#
# # create arrow schema
# chosen_schema <- schema(
#   purrr::map(colnames, ~Field$create(name = .x, type = string()))
# )
#
# # convert csv to parquet
# df <- arrow::read_csv_arrow('./data_raw/microdata/1980/Censo.1980.brasil.domicilios.amostra.25porcento.csv',
#                           skip = 1,
#                           schema = chosen_schema,
#                           as_data_frame = FALSE
#                           )
#
# gc(T)
# f_parquet <- './data_raw/microdata/1980/Censo.1980.brasil.domicilios.amostra.25porcento.parquet'
# arrow::write_parquet(df, f_parquet)






# read data
f_parquet <- './data_raw/microdata/1980/Censo.1980.brasil.domicilios.amostra.25porcento.parquet'
df <- arrow::open_dataset(f_parquet)

head(df) |> collect()

# # make all columns as character
# df <- mutate(df, across(everything(), as.character))



##  add geography variables ----------------------------------------------

# trailing zeros
df <- mutate(df, code_muni_1980 = as.character(as.numeric(V2) * 10000 + as.numeric(V5)))

# add cross walk of code_muni
df <- left_join(df, cross_muni_code, by=c('code_muni_1980'='municCod1980'))
df <- mutate(df, municCod2010_6dig = ifelse(is.na(municCod2010_6dig),  code_muni_1980, municCod2010_6dig))


# add code_muni 7 digits
muni_geobr <- geobr::read_municipality(year = 1980)
muni_geobr <- mutate(muni_geobr,
                     code_muni6 = substr(code_muni, 1, 6)) |>
  select(code_muni,code_muni6)

muni_geobr$geom <- NULL
muni_geobr$code_muni <- as.character(muni_geobr$code_muni)
head(muni_geobr)



df <- left_join(df, muni_geobr,  by=c('municCod2010_6dig'='code_muni6'))

df <- select(df, -c(municCod2010_6dig))

names(df)

df <- add_geography_cols(arrw = df, year = 1980)


names(df)

# make variables as numeric
num_vars <- c('V602', 'V211', 'V212', 'V213', 'V603')

df <- mutate(df, across(all_of(num_vars),
                        ~ as.numeric(.x)))

gc(T)

## save single parquet tile ----------------------------------------------
arrow::write_parquet(df, './data/microdata_sample/1980/1980_households.parquet')




rm(list=ls())
gc(T)



# 2) Population data -----------------------------------------------------------

# # get colnames
# temp <- fread('./data_raw/microdata/1980/Censo.1980.brasil.pessoas.amostra.25porcento.csv', nrows = 10)
# colnames <- names(temp)
#
# # create arrow schema
# chosen_schema <- schema(
#   purrr::map(colnames, ~Field$create(name = .x, type = string()))
# )
#
# # convert csv to parquet
# df <- arrow::read_csv_arrow('./data_raw/microdata/1980/Censo.1980.brasil.pessoas.amostra.25porcento.csv',
#                           schema = chosen_schema,
#                           skip = 1,
#                           as_data_frame = FALSE
#                           )
#
# gc(T)
# f_parquet <- './data_raw/microdata/1980/Censo.1980.brasil.pessoas.amostra.25porcento.parquet'
# arrow::write_parquet(df, f_parquet)
#


f_parquet <- './data_raw/microdata/1980/Censo.1980.brasil.pessoas.amostra.25porcento.parquet'
df <- arrow::open_dataset(f_parquet)

head(df) |> collect()

# # make all columns as character
# df <- mutate(df, across(everything(), as.character))

# rename vars to upper case
df <- rename_with(df, toupper, starts_with("v"))


  ##  add geography variables ----------------------------------------------

  # trailing zeros
  df <- mutate(df, code_muni_1980 = as.character(as.numeric(V2) * 10000 + as.numeric(V5)))

  # add cross walk of code_muni
  df <- left_join(df, cross_muni_code, by=c('code_muni_1980'='municCod1980'))
  df <- mutate(df, municCod2010_6dig = ifelse(is.na(municCod2010_6dig),  code_muni_1980, municCod2010_6dig))

  # add code_muni 7 digits
  muni_geobr <- geobr::read_municipality(year = 1980)
  muni_geobr <- mutate(muni_geobr,
                       code_muni6 = substr(code_muni, 1, 6)) |>
    select(code_muni,code_muni6)

  muni_geobr$geom <- NULL
  muni_geobr$code_muni <- as.character(muni_geobr$code_muni)
  head(muni_geobr)



  df <- left_join(df, muni_geobr,  by=c('municCod2010_6dig'='code_muni6'))
  names(df)

  df <- select(df, -c(municCod2010_6dig))

  names(df)

  df <- add_geography_cols(arrw = df, year = 1980)

  names(df)

  # make variables as numeric
  num_vars <- c('V602', 'V211', 'V212', 'V213', 'V603', 'V604', 'V606', 'V517',
                'V607', 'V608', 'V536', 'V609', 'V610', 'V611', 'V612', 'V613',
                'V557', 'V570')


  df <- mutate(df, across(all_of(num_vars),
                          ~ as.numeric(.x)))

  gc(T)

  ##  save single parquet tile ----------------------------------------------
  arrow::write_parquet(df, './data/microdata_sample/1980/1980_population.parquet')

