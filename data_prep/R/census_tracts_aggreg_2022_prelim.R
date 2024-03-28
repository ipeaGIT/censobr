library(dplyr)
library(data.table)
library(arrow)

df <- data.table::fread('C:/Users/user/Downloads/Agregados_preliminares_por_setores_censitarios_BR/Agregados_preliminares_por_setores_censitarios_BR.csv')
head(df)


# remove P from code tract
df[, CD_SETOR := gsub("P","", CD_SETOR)]
head(df)


# rename columns
names(df) <- toupper(names(df))

df2 <- dplyr::select(df,
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
              V0001 = V0001,
              V0002 = V0002,
              V0003 = V0003,
              V0004 = V0004,
              V0005 = V0005,
              V0006 = V0006,
              V0007 = V0007,
              area_km2 = AREA_KM2
              )
head(df2)

# make all columns as character
character_cols <- names(df2)[names(df2) %like% 'code_|name_']
df2 <- mutate(df2, across(everything(character_cols), as.character))

sapply(df2, class)


# save
dir.create('./data/tracts/2022/', recursive = T)

dest_file <- paste0('2022_tracts_Preliminares.parquet')
arrow::write_parquet(df2, paste0('./data/tracts/2022/', dest_file))




