rm(list = ls())

library(arrow)
library(dplyr)
library(tidyr)
library(readr)
library(data.table)
library(pbapply)
library(rvest)
library(purrr)
library(stringr)
library(readxl)

data.table::setDTthreads(percent = 100)
options(scipen = 999)

# 0) Useful functions --------------------------------------------------------

download_tract <- function(year,
                           overwrite = F,
                           dest_dir = paste0('./data_raw/tracts/', year, "/")){ # year = 2000, 2010, 2022

  message(paste0("\nDownloading year: ", year, '\n'))

  dest_dir = paste0(dest_dir, "zip/")

  # create dir if it has not been created already
  if (isFALSE(dir.exists(dest_dir))) { dir.create(dest_dir,
                                                  recursive = T,
                                                  showWarnings = FALSE) }
  # get ftp
  if(year==2000){
    ftp   <- 'https://ftp.ibge.gov.br/Censos/Censo_Demografico_2000/Dados_do_Universo/Agregado_por_Setores_Censitarios/'
    files <- NULL
  }

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

unzip_census = function(year, filetype = "xls"){

  zipdir  = paste0("./data_raw/tracts/", year, "/zip/")
  destdir = paste0("./data_raw/tracts/", year, "/", filetype, "/")

  zip_files = list.files(path = zipdir,
                         pattern = ".zip$",
                         full.names = T)

  if (isFALSE(dir.exists(destdir))) {
    dir.create(destdir,
               recursive = T,
               showWarnings = FALSE)
  }

  for(zip_file_i in zip_files){
    print(zip_file_i)

    unzip(zipfile = zip_file_i,
          exdir = destdir,
          unzip = "unzip",
          overwrite = T)
  }
}

# a function for recoding the list of datasets
recode_datasets = function(df){

  variants <- c("CD_setor", "COD_SETOR", "CD_SETOR", "SETOR", "COD_SETOR_M22FINAL")

  present = intersect(names(df), variants)

  if (present != "CD_setor") {
    df <- df |> rename("CD_setor" = !!sym(present))
  }

  df_recoded = df |>
    mutate(CD_setor  = as.numeric(CD_setor)) |>

    ### replace "X" "," "." with NA
    mutate_if(is.character, .funs = \(var){

      var = iconv(var, to = "utf-8")
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
    all(
      (df[[var]] %in% c("X", ",", ".", "")) == is.na(df_recoded[[var]]) |

        (is.na(df[[var]]) == is.na(df_recoded[[var]]))
    )
  })

  if(!all(test_missings)){
    stop("Missing values foram criados onde provavelmente não deveriam ser")
  }

  df_recoded |> select(CD_setor, everything())
}


recode_basico = function(dataset_info){

  dataset_info_basico = dataset_info |>
    filter(theme %in% "Basico")

  # creating list of datasets
  datasets_i = lapply(dataset_info_basico$file,
                      \(file) readxl::read_excel(path = file))

  datasets_basico = do.call(bind_rows, datasets_i)

  names(datasets_basico) = str_to_upper(names(datasets_basico))

  #summary(datasets_basico)

  datasets_basico_rec = recode_datasets(datasets_basico)

  datasets_basico_renamed <- datasets_basico_rec |>
    rename(code_tract        = CD_setor,
           code_state        = COD_UF,
           name_state        = NOME_DA_UF,
           code_meso         = COD_MESO,
           name_meso         = NOME_DA_MESO,
           code_micro        = COD_MICRO,
           name_micro        = NOME_DA_MICRO,
           code_metro        = COD_RM,
           name_metro        = NOME_DA_RM,
           code_muni         = COD_MUNICIPIO,
           name_muni         = NOME_DO_MUNICIPIO,
           code_district     = COD_DISTRITO,
           name_district     = NOME_DO_DISTRITO,
           code_subdistrict  = COD_SUBDISTRITO,
           name_subdistrict  = NOME_DO_SUBDISTRITO,
           code_neighborhood = COD_BAIRRO,
           name_neighborhood = NOME_DO_BAIRRO,
           situacao          = SITUACAO,
           code_type         = TIPO_DO_SETOR)

  datasets_basico_renamed
}

make_theme_dataset <- function(theme_i, dataset_info, dataset_Basico){

  dataset_Basico_sub <- dataset_Basico |>
    select(-starts_with("V"))

  dataset_info_i = dataset_info |>
    filter(theme %in% theme_i)

  # creating list of datasets from the same theme

  # creating list of datasets
  prefixes = unique(dataset_info_i$prefix)


  datasets_i = lapply(prefixes,
                      FUN = \(prefix_j){

                        print(prefix_j)

                        # Identifica os bancos de dados de cada estado, dentro do subtema prefix_j
                        prefix_j_files    <- dataset_info_i |> filter(prefix == prefix_j) |> pull(file)

                        # abre os bancos de dados de cada estado
                        prefix_j_datasets <- lapply(prefix_j_files, \(file) readxl::read_excel(path = file))

                        # transformando todos os nomes de variáveis para maiúsculo
                        prefix_j_datasets = lapply(prefix_j_datasets, \(x) setNames(x, str_to_upper(names(x))))

                        # empilha
                        prefix_j_dataset_stacked  <- do.call(bind_rows, prefix_j_datasets)
                        gc()

                        prefix_j_dataset_stacked
                      })
  gc(reset = T, full = T, verbose = T)

  # Recoding the dataset
  datasets_i_rec = lapply(1:length(datasets_i),
                      FUN = \(j){
                        print(j)
                        recode_datasets(datasets_i[[j]])
                        })

  # Adding prefixes to themes with more than one table
  if(length(prefixes) > 1){
    for(j in 1:length(prefixes)){
      print(j)

      prefix_j = prefixes[j]

      datasets_i_rec[[j]]$SITUACAO      = NULL
      datasets_i_rec[[j]]$TIPO_DO_SETOR = NULL

      names_to_change = setdiff(names(datasets_i_rec[[j]]),  "CD_setor")

      if(any(grepl(x = names_to_change, pattern = prefix_j))) next

      data.table::setnames(x = datasets_i_rec[[j]],
                           old = "CD_setor",
                           new = "code_tract")

      datasets_i_rec[[j]] <- datasets_i_rec[[j]] |> select(code_tract, everything())

      newnames = paste(prefix_j, names_to_change, sep = "_")

      data.table::setnames(x = datasets_i_rec[[j]],
                           old = names_to_change,
                           new = newnames)
    }
  }else{
    datasets_i_rec[[1]]$SITUACAO      = NULL
    datasets_i_rec[[1]]$TIPO_DO_SETOR = NULL
    data.table::setnames(x = datasets_i_rec[[1]],
                         old = "CD_setor",
                         new = "code_tract")
    datasets_i_rec[[1]] <- datasets_i_rec[[1]] |> select(code_tract, everything())
  }


  if(length(datasets_i_rec) > 1){

    numberOfrows = unlist(lapply(datasets_i_rec, nrow))
    variance_of_numberOfrows = var(numberOfrows)

    if(variance_of_numberOfrows > 0){
      warning("Datasets of the same theme do not have the same number of rows")
    }

    whichMaxRows = which.max(numberOfrows)
    data_join_i = datasets_i_rec[[whichMaxRows]]

    for(dataset_j in datasets_i_rec[-whichMaxRows]){
      data_join_i <- full_join(data_join_i,
                               dataset_j,
                               by = "code_tract")
    }

  }else{
    data_join_i = datasets_i_rec[[1]]
  }

  # Adding geographic variables
  data_with_geoVariables = left_join(dataset_Basico_sub,
                                     data_join_i,
                                     by = "code_tract") |>
    filter(code_tract %in% data_join_i$code_tract)

  gc(T, T, T)

  data_with_geoVariables
}



# 1) download raw data from IBGE ftp -------------------------------------------

download_tract(2000, overwrite = F)

## 1.2) unzip all files ------
unzip = F
if(unzip == T){
  unzip_census(2000, filetype = "xls")
}

# 2) Checking files  -----------------------------------------------------------

# list all excel files
all_xls_files <- list.files(path = './data_raw/tracts/2000/xls/',
                            full.names = T,
                            recursive = T,
                            pattern = '.xls$',
                            ignore.case = T) %>%
  .[!grepl(x = ., pattern = "compatibiliza|descri|instalad", ignore.case = T)]

dataset_info = str_split(all_xls_files, pattern = "/") |>
  sapply(FUN = \(x) last(x)) |>
  str_remove(pattern = ".xls$|.XLS$") %>%
  tibble(tmp = .) |>
  separate(col = tmp, sep = "_", into = c("prefix", "uf")) |>
  mutate(theme  = str_remove_all(prefix, "[[:digit:]]"),
         prefix = tolower(prefix),
         file  = all_xls_files)

dataset_info |> janitor::tabyl(theme)


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


if(!dir.exists(paths = './data_processed/2000/parquet/')){
  dir.create(path = './data_processed/2000/parquet/', recursive = T)
}

#dataset_i = datasets[1]
for(dataset_i in datasets){

  print(dataset_i)

  theme_i = paste(unlist(str_split(dataset_i, pattern = "_"))[-1], collapse = "_")

  dataset_i <- get(dataset_i)
  dataset_i <- dataset_i |> mutate(code_tract = as.character(code_tract))

  write_parquet(x = dataset_i,
                sink = paste0('./data_processed/2000/parquet/2000_tracts_',
                              theme_i,
                              "_",
                              "v0.5.0", # censobr version
                              #censobr_env$data_release,
                              ".parquet"),
                compression='zstd',
                compression_level = 22)

}
