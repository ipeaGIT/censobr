library(arrow)
library(dplyr)
library(fst)

source('./R/add_geography_cols.R')

hh <- fst::read_fst('R:/Dropbox/censoBR/1960/microdados/Censo.1960.brasil.domicilios.amostraCompilada.censobr.fst')
pop <- arrow::open_dataset('R:/Dropbox/censoBR/1960/microdados/Censo.1960.brasil.pessoas.amostraCompilada.censobr.parquet')
pop <- collect(pop)

gc(T)


names(hh)
names(pop)


# rename columns
pop <- pop |>
  rename_with(~ ifelse(startsWith(., "v"), sub("^v", "V", .), .))


hh <- hh |>
  rename_with(~ ifelse(startsWith(., "v"), sub("^v", "V", .), .))


names(pop)
names(hh)



arrow::write_parquet(pop, '../../censobr_data_prep/data/microdata_sample/1960/1960_population_v0.3.0.parquet')
arrow::write_parquet(hh, '../../censobr_data_prep/data/microdata_sample/1960/1960_households_v0.3.0.parquet')
