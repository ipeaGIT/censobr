library(dplyr)
library(data.table)
library(arrow)

df <- data.table::fread('C:/Users/user/Downloads/Agregados_preliminares_por_setores_censitarios_BR/Agregados_preliminares_por_setores_censitarios_BR.csv')
head(df)


# remove P from code tract
df[, CD_SETOR := gsub("P","", CD_SETOR)]
head(df)


# make all columns as character
df <- mutate(df, across(everything(), as.character))

names(df) <- toupper(names(df))

df2 <- dplyr::rename(df,
              code_tract = CD_SETOR,
              code_muni = CD_MUN,
              name_muni = NM_MUN,
              code_subdistrict = CD_SUBDIST,
              name_subdistrict = NM_SUBDIST,
              code_district = CD_DIST,
              name_district = NM_DIST,
              code_urban_concentration = CD_CONCURB,
              name_urban_concentration = NM_CONCURB,
              code_state = CD_UF,
              name_state = NM_UF,
              code_micro = CD_MICRO,
              name_micro = NM_MICRO,
              code_meso = CD_MESO,
              name_meso = NM_MESO,
              code_immediate = CD_RGI,
              name_immediate = NM_RGI,
              code_intermediate = CD_RGINT,
              name_intermediate = NM_RGINT,
              code_region = CD_REGIAO,
              name_region = NM_REGIAO,
              area_km2 = AREA_KM2
              )
head(df2)


# save
dir.create('./data/tracts/2022/', recursive = T)

dest_file <- paste0('2022_tracts_Preliminares.parquet')
arrow::write_parquet(df2, paste0('./data/tracts/2022/', dest_file))

arrow::write_parquet(df2, 'd2.parquet')


