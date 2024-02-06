library(arrow)
library(dplyr)
library(readr)
library(data.table)
library(pbapply)

data.table::setDTthreads(percent = 100)
source('./R/add_geography_cols.R')


# 1) Households data -----------------------------------------------------------

# # convert csv to parquet
# df <- arrow::read_csv_arrow('./data_raw/microdata/1991/Censo.1991.brasil.domicilios.amostra.10porcento.csv',
#                             as_data_frame = FALSE)
#
# gc(T)
# f_parquet <- './data_raw/microdata/1991/Censo.1991.brasil.domicilios.amostra.10porcento.parquet'
# arrow::write_parquet(df, f_parquet)


# read guide to parse the data
f_parquet <- './data_raw/microdata/1991/Censo.1991.brasil.domicilios.amostra.10porcento.parquet'
df <- arrow::open_dataset(f_parquet)

head(df) |> collect()

head(select(df, V1101, V1102)) |> collect()


# make all columns as character
df <- mutate(df, across(everything(), as.character))


# add trailing zeros to municipality column
df <- collect(df)
df <- mutate(df, V1102 = stringi::stri_pad_left(V1102, 4, 0))


##  add geography variables ----------------------------------------------

# add code_muni 7 digits
muni_geobr <- geobr::read_municipality(year = 1991)
muni_geobr <- mutate(muni_geobr,
                     code_muni6 = substr(code_muni, 1, 6)) |>
              select(code_muni,code_muni6)

muni_geobr$geom <- NULL
muni_geobr$code_muni <- as.character(muni_geobr$code_muni)
muni_geobr$code_muni6 <- as.character(muni_geobr$code_muni6)
head(muni_geobr)

df <- mutate(df, code_muni6 = paste0(V1101, V1102))

df <- left_join(df, muni_geobr, by='code_muni6')

df <- select(df, -code_muni6)




df <- add_geography_cols(arrw = df, year = 1991)


head(df) |> collect()

# make variables as numeric
num_vars <- c('V0102', 'V0098', 'V0109', 'V0111', 'V0112', 'V2012',
              'V0209', 'V0211', 'V2111', 'V0212', 'V2121', 'V7300')

df <- mutate(df, across(all_of(num_vars),
                        ~ as.numeric(.x)))


# fix weight variable
df <- mutate(df, V7300 = V7300 /10^8)

head(df) |> collect()

gc(T)

## save single parquet tile ----------------------------------------------
arrow::write_parquet(df, './data/microdata_sample/1991/1991_households.parquet')



rm(list=ls())
gc(T)




# 2) Population data -----------------------------------------------------------

# temp <- fread('./data_raw/microdata/1991/Censo.1991.brasil.pessoas.amostra.10porcento.csv', select = 'V7301')
# class(temp$V7301)
# sum(temp$V7301)
#
# temp[ , V7301_w := V7301 /10^8]
# sum(temp$V7301_w )
146815212

# # get colnames
# temp <- fread('./data_raw/microdata/1991/Censo.1991.brasil.pessoas.amostra.10porcento.csv', nrows = 10)
# colnames <- names(temp)
#
# # create arrow schema
# chosen_schema <- schema(
#   purrr::map(colnames, ~Field$create(name = .x, type = string()))
# )
#
# # convert csv to parquet
# df <- arrow::read_csv_arrow('./data_raw/microdata/1991/Censo.1991.brasil.pessoas.amostra.10porcento.csv',
#                           schema = chosen_schema,
#                           skip = 1,
#                           as_data_frame = FALSE
#                           )
#
# gc(T)
# f_parquet <- './data_raw/microdata/1991/Censo.1991.brasil.pessoas.amostra.10porcento.parquet'
# arrow::write_parquet(df, f_parquet)


# read guide to parse the data
f_parquet <- './data_raw/microdata/1991/Censo.1991.brasil.pessoas.amostra.10porcento.parquet'
df <- arrow::open_dataset(f_parquet)


# df |>
#   mutate(V7301 = as.numeric(V7301)/10^8) |>
#   summarise(total = sum(V7301)) |>
#   collect()


head(df) |> collect()

# rename vars to upper case
df <- rename_with(df, toupper, starts_with("v"))

names(df)

# # make all columns as character
# df <- mutate(df, across(everything(), as.character))


# add trailing zeros to municipality column
gc(T)
df <- collect(df)
df <- mutate(df, V1102 = stringi::stri_pad_left(V1102, 4, 0))
gc(T)
gc(T)

##  add geography variables ----------------------------------------------

# add code_muni 7 digits
muni_geobr <- geobr::read_municipality(year = 1991)
muni_geobr <- mutate(muni_geobr,
                     code_muni6 = substr(code_muni, 1, 6)) |>
  select(code_muni,code_muni6)

muni_geobr$geom <- NULL
muni_geobr$code_muni <- as.character(muni_geobr$code_muni)
muni_geobr$code_muni6 <- as.character(muni_geobr$code_muni6)
head(muni_geobr)

names(df)
df <- mutate(df, code_muni6 = paste0(V1101, V1102))

#df <- left_join(df, muni_geobr, by='code_muni6')
setDT(muni_geobr)
setDT(df)
data.table::setkey(muni_geobr, code_muni6)
data.table::setkey(df, code_muni6)
gc(T)
df[muni_geobr, on = 'code_muni6', code_muni := i.code_muni]
gc()

df <- select(df, -code_muni6)


df <- add_geography_cols(arrw = df, year = 1991)



# make variables as numeric
num_vars <- c('V3041', 'V3042', 'V3043', 'V3045', 'V3072', 'V3073',
              'V3152', 'V0317', 'V0318', 'V3311', 'V3312', 'V3341', 'V0354',
              'V0355', 'V3561', 'V0357', 'V0360', 'V0361', 'V3351', 'V3352',
              'V3353', 'V3354', 'V3355', 'V3356', 'V3360', 'V3361', 'V3362',
              'V0335', 'V0336', 'V0340', 'V3357', 'V3443', 'V7301')

df <- mutate(df, across(all_of(num_vars),
                        ~ as.numeric(.x)))


# fix weight variable
df <- mutate(df, V7301 = V7301 /10^8)

df |>
  summarise(total = sum(V7301)) |>
  collect()

head(df) |> collect()





gc(T)


## save single parquet tile ----------------------------------------------
arrow::write_parquet(df, './data/microdata_sample/1991/1991_population.parquet')
