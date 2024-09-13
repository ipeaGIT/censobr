library(arrow)
library(dplyr)

source('./R/add_geography_cols.R')



pop <- arrow::open_dataset('../../censobr_data_prep/data_raw/microdata/1960/1960_population.parquet')
hh <- arrow::open_dataset('../../censobr_data_prep/data_raw/microdata/1960/1960_households.parquet')

names(hh)



pop <- pop |>
  rename_with(~ ifelse(startsWith(., "v"), sub("^v", "V", .), .))


hh <- hh |>
  rename_with(~ ifelse(startsWith(., "v"), sub("^v", "V", .), .))


names(pop)
names(hh)



arrow::write_parquet(pop, '../../censobr_data_prep/data/microdata_sample/1960/1960_population_v0.3.0.parquet')
arrow::write_parquet(hh, '../../censobr_data_prep/data/microdata_sample/1960/1960_households_v0.3.0.parquet')
