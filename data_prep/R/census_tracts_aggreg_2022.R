rm(list = ls())

library(arrow)
library(dplyr)
library(readr)
library(data.table)
library(pbapply)
library(rvest)
library(purrr)
library(stringr)
library(readxl)

data.table::setDTthreads(percent = 100)
options(scipen = 999)

### 0) Useful functions --------------------------------------------------------


download_tract <- function(year,
                           overwrite = F,
                           dest_dir = paste0('./data_raw/tracts/', year)){ # year = 2010, 2022

  message(paste0("\nDownloading year: ", year, '\n'))

  dest_dir = paste0(dest_dir, "zip/")

  # create dir if it has not been created already
  if (isFALSE(dir.exists(dest_dir))) { dir.create(dest_dir,
                                                  recursive = T,
                                                  showWarnings = FALSE) }

  # get ftp
  if(year==2010){
    ftp   <- 'https://ftp.ibge.gov.br/Censos/Censo_Demografico_2010/Resultados_do_Universo/Agregados_por_Setores_Censitarios/'
    files <- NULL
  }

  if(year==2022){
    ftp   <- c('https://ftp.ibge.gov.br/Censos/Censo_Demografico_2022/Agregados_por_Setores_Censitarios/Agregados_por_Setor_csv/',
               'https://ftp.ibge.gov.br/Censos/Censo_Demografico_2022/Agregados_por_Setores_Censitarios_Caracteristicas_urbanisticas_do_entorno_dos_domicilios/Agregados_por_Setor_csv/')

    files <- c("https://ftp.ibge.gov.br/Censos/Censo_Demografico_2022/Agregados_por_Setores_Censitarios_Rendimento_do_Responsavel/Agregados_por_setores_renda_responsavel_BR_csv.zip")
  }

  # get file names

  h            <- lapply(ftp, rvest::read_html)
  elements     <- lapply(h, FUN = \(x) rvest::html_elements(x, "a"))
  listed_files <- lapply(elements, FUN = \(x) rvest::html_attr(x, "href"))

  # Organizing files in a data.frame
  files_df = lapply(1:length(listed_files),
                    \(i){
                      tibble(file    = listed_files[[i]],
                             ftp_dir = ftp[i]) |>
                        filter(grepl(x = file, pattern = '.zip$'))
                    }) %>%
    bind_rows()


  if(!is.null(files)){
    other_files_df = tibble(file    = last(str_split(files, pattern = "/")[[1]]),
                            ftp_dir = str_remove(files, pattern = file))

    files_df = bind_rows(files_df,
                         other_files_df)
  }


  # Removing existing files from the list of files to download (if overwrite == F)
  if(overwrite == F){
    existing_files = files_df$file %in% list.files(dest_dir)
    files_df <- files_df[!existing_files, ]
  }

  if(nrow(files_df) == 0){
    return()
  }

  # Download zipped files
  for (i in 1:nrow(files_df)){

    filename_i <- files_df$file[i]
    url_i      <- with(files_df[i, ], paste0(ftp_dir, file))
    destfile_i <- paste0(dest_dir, "/", filename_i)

    download.file(url = url_i,
                  destfile = destfile_i,
                  method = "curl",
                  mode = "wb",
                  quiet = F)
  }
}

# a function for recoding the list of datasets
recode_datasets = function(df){

  variants <- c("CD_SETOR", "SETOR", "COD_SETOR_M22FINAL")

  present = intersect(names(df), variants)

  if (present != "CD_setor") {
    df <- df |> rename("CD_setor" = !!sym(present))
  }

  df_recoded = df |>
    mutate(CD_setor  = as.numeric(CD_setor)) |>

    ### replace "X" "," "." with NA
    mutate_if(is.character, .funs = \(var){

      var = iconv(var, from = "latin1", to = "utf-8")
      var = str_squish(var)
      var = ifelse((nchar(var) %in% 1) & (var %in% c("X",",",".")), NA_character_, var)
      var

    }) |>

    ### replace "," with "."
    mutate_if(is.character, .funs = \(var) str_replace(string = var, pattern = ",", ".")) |>

    # convert to numeric those variables which do not present any letter
    mutate_if(.predicate = \(x) !any(grepl(x = str_to_lower(x), pattern = "[a-z]")),
              .funs      = \(x) suppressWarnings(as.numeric(x))) |>

    # replace "" with NA
    mutate_if(is.character, \(x) ifelse(x %in% "", NA_character_, x))

  test_missings = sapply(names(df), \(var){
    all((df[[var]] %in% c("X", ",", ".", "")) == is.na(df_recoded[[var]]))
  })

  if(!all(test_missings)){
    stop("Missing values foram criados onde provavelmente não deveriam ser")
  }

  df_recoded |> select(CD_setor, everything())
}


recode_basico = function(dataset_info){

  dataset_info_basico = dataset_info |>
    filter(theme %in% "Basico")

  datasets_basico = data.table::fread(file = dataset_info_basico$file, sep = ";", dec = ",")
  names(datasets_basico) = str_to_upper(names(datasets_basico))

  datasets_basico = recode_datasets(datasets_basico)

  datasets_basico_rec <- datasets_basico |>
    rename(code_tract               = CD_setor   ,
           situacao                 = SITUACAO   ,
           code_situacao            = CD_SIT     ,
           code_type                = CD_TIPO    ,
           area_km2                 = AREA_KM2   ,
           code_region              = CD_REGIAO  ,
           name_region              = NM_REGIAO  ,
           code_state               = CD_UF      ,
           name_state               = NM_UF      ,
           code_muni                = CD_MUN     ,
           name_muni                = NM_MUN     ,
           code_district            = CD_DIST    ,
           name_district            = NM_DIST    ,
           code_subdistrict         = CD_SUBDIST ,
           name_subdistrict         = NM_SUBDIST ,
           code_neighborhood        = CD_BAIRRO  ,
           name_neighborhood        = NM_BAIRRO  ,
           code_favela              = CD_FCU     ,
           name_favela              = NM_FCU     ,
           code_intermediate        = CD_RGINT   ,
           name_intermediate        = NM_RGINT   ,
           code_immediate           = CD_RGI     ,
           name_immediate           = NM_RGI     ,
           code_nucleo_urbano       = CD_NU      ,
           name_nucleo_urbano       = NM_NU      ,
           code_aglomerado          = CD_AGLOM   ,
           name_aglomerado          = NM_AGLOM   ,
           code_urban_concentration = CD_CONCURB ,
           name_urban_concentration = NM_CONCURB)

  datasets_basico_rec
}


make_theme_dataset <- function(theme_i, dataset_info, dataset_Basico){

  dataset_Basico_sub <- dataset_Basico |>
    select(-starts_with("V"))

  dataset_info_i = dataset_info |>
    filter(theme %in% theme_i)

  # creating list of datasets from the same theme
  datasets_i = lapply(dataset_info_i$file,
                      \(file) data.table::fread(file = file, sep = ";", dec = ","))
  gc(reset = T, full = T, verbose = T)

  datasets_i = lapply(datasets_i, \(x) setNames(x, str_to_upper(names(x))))

  # Recoding the dataset
  datasets_i = lapply(datasets_i, recode_datasets)

  # Adding prefixes to themes with more than one table
  if(nrow(dataset_info_i) > 1){
    for(i in 1:nrow(dataset_info_i)){

      prefix_i = dataset_info_i$prefix[i]
      names_to_change = setdiff(names(datasets_i[[i]]),  "CD_setor")

      if(any(grepl(x = names_to_change, pattern = prefix_i))) next

      newnames = c("code_tract", paste(prefix_i, names_to_change, sep = "_"))

      names(datasets_i[[i]]) <- newnames
    }
  }else{
    names(datasets_i[[1]])[1] <- "code_tract"
  }


  if(length(datasets_i) > 1){

    numberOfrows = unlist(lapply(datasets_i, nrow))
    variance_of_numberOfrows = var(numberOfrows)

    if(variance_of_numberOfrows > 0){
      warning("Datasets of the same theme do not have the same number of rows")
    }

    whichMaxRows = which.max(numberOfrows)
    data_join_i = datasets_i[[whichMaxRows]]

    for(dataset_j in datasets_i[-whichMaxRows]){

      data_join_i <- left_join(data_join_i,
                               dataset_j,
                               by = "code_tract")
    }

  }else{

    data_join_i = datasets_i[[1]]

  }

  # Adding geographic variables
  data_with_geoVariables = left_join(dataset_Basico_sub,
                                     data_join_i,
                                     by = "code_tract") |>
    filter(code_tract %in% data_join_i$code_tract)

  gc(T, T, T)

  data_with_geoVariables
}



### 1) download raw data from IBGE ftp -------------------------------------------

download_tract(2022, overwrite = F)

## 1.2) unzip all files ------
unzip = F

if(unzip == T){
  destdir_csv = "./data_raw/tracts/2022/csv/"


  zip_files = list.files(path = './data_raw/tracts/2022/zip/',
                         pattern = ".zip$",
                         full.names = T)

  if (isFALSE(dir.exists(destdir_csv))) {
    dir.create(destdir_csv,
               recursive = T,
               showWarnings = FALSE)
  }

  for(zip_file_i in zip_files){
    print(zip_file_i)

    unzip(zipfile = zip_file_i,
          exdir = destdir_csv,
          unzip = "unzip",
          overwrite = T)
  }
}

# 2) Checking files  -----------------------------------------------------------

# list all excel files
all_csv_files <- list.files(path = './data_raw/tracts/2022/csv/',
                            full.names = T,
                            recursive = T,
                            pattern = '.csv$',
                            ignore.case = T)



dataset_info = tribble(
  ~theme, ~prefix, ~file,
  "Alfabetizacao",           NA_character_,        "./data_raw/tracts/2022/csv/Agregados_por_setores_alfabetizacao_BR.csv"                       ,
  "Basico",                  NA_character_,        "./data_raw/tracts/2022/csv/Agregados_por_setores_basico_BR_20250417.csv"                     ,
  "Domicilio",               "domicilio01",        "./data_raw/tracts/2022/csv/Agregados_por_setores_caracteristicas_domicilio1_BR.csv"          ,
  "Domicilio",               "domicilio02",        "./data_raw/tracts/2022/csv/Agregados_por_setores_caracteristicas_domicilio2_BR_20250417.csv" ,
  "Domicilio",               "domicilio03",        "./data_raw/tracts/2022/csv/Agregados_por_setores_caracteristicas_domicilio3_BR_20250417.csv" ,
  "Cor_ou_raca",             NA_character_,        "./data_raw/tracts/2022/csv/Agregados_por_setores_cor_ou_raca_BR.csv"                         ,
  "Demografia",              NA_character_,        "./data_raw/tracts/2022/csv/Agregados_por_setores_demografia_BR.csv"                          ,
  "Domicilios_indigenas",    NA_character_,        "./data_raw/tracts/2022/csv/Agregados_por_setores_domicilios_indigenas_BR.csv"                ,
  "Domicilios_quilombolas",  NA_character_,        "./data_raw/tracts/2022/csv/Agregados_por_setores_domicilios_quilombolas_BR.csv"              ,
  "Entorno",                 "entorno_domicilio",  "./data_raw/tracts/2022/csv/Agregados_por_setores_entorno_domiclios_BR.csv"                  ,
  "Entorno",                 "entorno_faces",      "./data_raw/tracts/2022/csv/Agregados_por_setores_entorno_faces_BR.csv"                       ,
  "Entorno",                 "entorno_moradores",  "./data_raw/tracts/2022/csv/Agregados_por_setores_entorno_moradores_BR.csv"                   ,
  "Obitos",                  NA_character_,        "./data_raw/tracts/2022/csv/Agregados_por_setores_obitos_BR.csv"                              ,
  "Parentesco",              NA_character_,        "./data_raw/tracts/2022/csv/Agregados_por_setores_parentesco_BR.csv"                          ,
  "Pessoas_indigenas",       NA_character_,        "./data_raw/tracts/2022/csv/Agregados_por_setores_pessoas_indigenas_BR.csv"                   ,
  "Pessoas_quilombolas",     NA_character_,        "./data_raw/tracts/2022/csv/Agregados_por_setores_pessoas_quilombolas_BR.csv"                 ,
  "ResponsavelRenda",        NA_character_,        "./data_raw/tracts/2022/csv/Agregados_por_setores_renda_responsavel_BR.csv"
)


if(!all(all_csv_files %in% dataset_info$file)){
  stop("Not all csv files are listed in dataset_info")
}


# 3) Recoding and preparing the datasets ---------------------------------------


themes = dataset_info |> pull(theme) |> unique()
themes = setdiff(themes, "Basico")
#themes = themes[7:12]

dataset_Basico = recode_basico(dataset_info)

#theme_i = themes[1]
for(theme_i in themes){

  print(theme_i)

  assign(x = paste0("dataset_", theme_i),

         value = make_theme_dataset(theme_i        = theme_i,
                                    dataset_info   = dataset_info,
                                    dataset_Basico = dataset_Basico))
}

# 4) Saving --------------------------------------------------------------------

datasets = grep(ls(), pattern = "^dataset_", value = T)
datasets = setdiff(datasets, c("dataset_info", "dataset_info_i",  "dataset_Basico_sub", "dataset_i", "dataset_j"))


if(!dir.exists(paths = './data_processed/2022/parquet/')){
    dir.create(path = './data_processed/2022/parquet/', recursive = T)
}

#dataset_i = datasets[1]
for(dataset_i in datasets){


  print(dataset_i)

  theme_i = paste(unlist(str_split(dataset_i, pattern = "_"))[-1], collapse = "_")

  write_parquet(x = get(dataset_i),
                sink = paste0('./data_processed/2022/parquet/2022_tracts_', theme_i, ".parquet"))

}







