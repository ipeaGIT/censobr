# https://github.com/cboettig/minioclient

library(arrow)
library(dplyr)

minio <- arrow::S3FileSystem$create(
  access_key = "CC10HvyOMmynA1bG12CD",
  secret_key = "vKpyxfbKFDiR9aV23hHD832thlFDJXzYiobKwHdl",
  scheme = "https",
#  endpoint_override = "minioapi-teste.ipea.gov.br:443",  # Or public DNS
 endpoint_override = "minio.ipea.gov.br:443",  # Or public DNS
)


Sys.setenv(
  AWS_REGION = "us-east-1",
  AWS_EC2_METADATA_DISABLED = "TRUE"
)

df <- arrow::open_dataset(
  'censobr/2010_tracts_Pessoa_v0.5.0.parquet',
  filesystem=minio, format="parquet"
)

nrow(df)

# carrega pra memoria a base completa (310,114 observacoes)
# pico de 66% de rede
df2 <- df|> collect()

# carrega pra memoria soh estado do acre (2,346 observacoes)
# pico de 34% de rede
df3 <- df |>
  filter(code_state=='11') |>
  collect()



# https://github.com/cboettig/minioclient
library(minioclient)

mc_alias_set("censobr", "minioapi-teste.ipea.gov.br:443",
             access_key = "CC10HvyOMmynA1bG12CD",
             secret_key = "vKpyxfbKFDiR9aV23hHD832thlFDJXzYiobKwHdl"
             )



# ---------------------------------------------------------------------------------
# https://cboettig.github.io/duckdbfs/

a <- "https://github.com/ipeaGIT/censobr/releases/download/v0.5.0/1960_households_v0.5.0.parquet"

a <- "http://minio.ipea.gov.br/censobr/2010_tracts_Pessoa_v0.5.0.parquet"

library(duckdbfs)

ds <- duckdbfs::open_dataset(a)
nrow(ds)

ds2 <- duckdbfs::open_dataset(a, mode = "TABLE")
class(ds2)
nrow(ds2)
ds2

url <- "https://github.com/ipeaGIT/geobr/releases/download/v1.7.0/amazonia_legal.gpkg"

countries_meta <- duckdbfs::st_read_meta(url )
countries_meta

g <- duckdbfs::open_dataset(url,format = "sf")
in_mem <- g |> to_sf(crs = countries_meta$wkt)

