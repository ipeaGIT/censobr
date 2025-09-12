library(censobr)
library(dplyr)
library(data.table)

go <- censobr::read_tracts(year = 2010, dataset = "Pessoa") |>
  filter(abbrev_state=="GO")

cols_pessoa2 <- names(go)[names(go) %like% "pessoa02_"]

go <- go |>
  select(c(code_tract, cols_pessoa2 )) |>
  collect()

head(go)



cols_pessoa2 <- names(AT)[names(AT) %like% "pessoa02_"]

gogo <- AT |>
  select(c(code_tract, cols_pessoa2 )) |>
  collect()



go_csv <- fread("data_raw/tracts/2010/GO_20231030/Base informaçoes setores2010 universo GO/CSV/Pessoa02_GO.csv")
mg_csv <- fread("data_raw/tracts/2010/MG_20231030/Base informaçoes setores2010 universo MG/CSV/Pessoa02_MG.csv")
al_csv <- fread("data_raw/tracts/2010/AL_20231030/Base informaçoes setores2010 universo AL/CSV/Pessoa02_AL.csv")
names(go_csv)
names(mg_csv)
names(al_csv)
all(ncol(go_csv) == ncol(mg_csv))
all(ncol(al_csv) == ncol(mg_csv))

go_xls <- readxl::read_xls("data_raw/tracts/2010/GO_20231030/Base informaçoes setores2010 universo GO/EXCEL/Pessoa02_GO.xls")
mg_xls <- readxl::read_xls("data_raw/tracts/2010/MG_20231030/Base informaçoes setores2010 universo MG/EXCEL/Pessoa02_MG.xls")
al_xls <- readxl::read_xls("data_raw/tracts/2010/AL_20231030/Base informaçoes setores2010 universo AL/EXCEL/Pessoa02_AL.xls")
names(go_xls)
names(mg_xls)
names(al_xls)

ncol(go_xls) == ncol(mg_xls)
all(ncol(go_xls) == ncol(mg_xls))
all(ncol(al_xls) == ncol(mg_xls))

all(names(go_xls) == names(mg_xls))
all(names(al_xls) == names(mg_xls))

col_names <- names(go_xls)




