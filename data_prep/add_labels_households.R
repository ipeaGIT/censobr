# Add basic geography variables
#' @keywords internal
add_geography_cols <- function(arrw){


  # code_muni
  arrw <- mutate(arrw,
                 V0011 = as.character(V0011),
                 code_muni = substr(V0011 , 1, 7))

  # state name
  arrw <- mutate(arrw,
                 code_state = V0001,
                 name_state = case_when(
                   V0001 == 11 ~'Rondônia',
                   V0001 == 12 ~'Acre',
                   V0001 == 13 ~'Amazonas',
                   V0001 == 14 ~'Roraima',
                   V0001 == 15 ~'Pará',
                   V0001 == 16 ~'Amapá',
                   V0001 == 17 ~'Tocantins',
                   V0001 == 21 ~'Maranhão',
                   V0001 == 22 ~'Piauí',
                   V0001 == 23 ~'Ceará',
                   V0001 == 24 ~'Rio Grande do Norte',
                   V0001 == 25 ~'Paraíba',
                   V0001 == 26 ~'Pernambuco',
                   V0001 == 27 ~'Alagoas',
                   V0001 == 28 ~'Sergipe',
                   V0001 == 29 ~'Bahia',
                   V0001 == 31 ~'Minas Gerais',
                   V0001 == 32 ~'Espírito Santo',
                   V0001 == 33 ~'Rio de Janeiro',
                   V0001 == 35 ~'São Paulo',
                   V0001 == 41 ~'Paraná',
                   V0001 == 42 ~'Santa Catarina',
                   V0001 == 43 ~'Rio Grande do Sul',
                   V0001 == 50 ~'Mato Grosso do Sul',
                   V0001 == 51 ~'Mato Grosso',
                   V0001 == 52 ~'Goiás',
                   V0001 == 53 ~'Distrito Federal'))
  # abbrev name
  arrw <- mutate(arrw,
                 abbrev_state = case_when(
                   V0001 == 11 ~'Rondônia',
                   V0001 == 12 ~'Acre',
                   V0001 == 13 ~'Amazonas',
                   V0001 == 14 ~'Roraima',
                   V0001 == 15 ~'Pará',
                   V0001 == 16 ~'Amapá',
                   V0001 == 17 ~'Tocantins',
                   V0001 == 21 ~'Maranhão',
                   V0001 == 22 ~'Piauí',
                   V0001 == 23 ~'Ceará',
                   V0001 == 24 ~'Rio Grande do Norte',
                   V0001 == 25 ~'Paraíba',
                   V0001 == 26 ~'Pernambuco',
                   V0001 == 27 ~'Alagoas',
                   V0001 == 28 ~'Sergipe',
                   V0001 == 29 ~'Bahia',
                   V0001 == 31 ~'Minas Gerais',
                   V0001 == 32 ~'Espírito Santo',
                   V0001 == 33 ~'Rio de Janeiro',
                   V0001 == 35 ~'São Paulo',
                   V0001 == 41 ~'Paraná',
                   V0001 == 42 ~'Santa Catarina',
                   V0001 == 43 ~'Rio Grande do Sul',
                   V0001 == 50 ~'Mato Grosso do Sul',
                   V0001 == 51 ~'Mato Grosso',
                   V0001 == 52 ~'Goiás',
                   V0001 == 53 ~'Distrito Federal'))

  # region name
  arrw <- mutate(arrw,
                 code_region = V1001,
                 name_region = case_when(
                   V1001 == 1 ~'Norte',
                   V1001 == 2 ~'Nordeste',
                   V1001 == 3 ~'Sudeste',
                   V1001 == 4 ~'Sul',
                   V1001 == 5 ~'Centro-oeste'))

  # reoder columns
  arrw <- relocate(arrw, c(code_muni, code_state, name_state, code_region, name_region))

  return(arrw)
  }


add_labels_households <- function(arrw, lang = 'PT'){

  # names of columns present in the data
  cols <- names(arrw)

  # urban vs rural
  if ('V1006' %in% cols) {
    arrw <- arrw |> mutate(V1006 = case_when(
      V1006 == 1 ~'Urbana',
      V1006 == 2 ~'Rural'))
  }

  # Private vs collective household
  if ('V4001' %in% cols) {
    arrw <- arrw |> mutate(V4001 = case_when(
      V4001 == 1 ~'Domicílio particular permanente ocupado',
      V4001 == 2 ~'Domicílio particular permanente ocupado sem entrevista realizada',
      V4001 == 5 ~'Domicílio particular improvisado ocupado',
      V4001 == 6 ~'Domicílio coletivo com morador'))
  }

  # household type
  if ('V4002' %in% cols) {
    arrw <- arrw |> mutate(V4002 = case_when(
      V4002 == 11 ~ 'Casa',
      V4002 == 12 ~ 'Casa de vila ou em condomínio',
      V4002 == 13 ~ 'Apartamento',
      V4002 == 14 ~ 'Habitação em: casa de cômodos, cortiço ou cabeça de porco',
      V4002 == 15 ~ 'Oca ou maloca ',
      V4002 == 51 ~ 'Tenda ou barraca',
      V4002 == 52 ~ 'Dentro de estabelecimento',
      V4002 == 53 ~ 'Outro (vagão, trailer, gruta, etc)',
      V4002 == 61 ~ 'Asilo, orfanato e similares  com morador',
      V4002 == 62 ~ 'Hotel, pensão e similares com morador',
      V4002 == 63 ~ 'Alojamento de trabalhadores com morador',
      V4002 == 64 ~ 'Penitenciária, presídio ou casa de detenção com morador'))
  }

  # household tenure / occupancy status
  if ('V0201' %in% cols) {
    arrw <- arrw |> mutate(V0201 = case_when(
      V0201 == 1 ~ 'Próprio de algum morador - já pago',
      V0201 == 2 ~ 'Próprio de algum morador - ainda pagando',
      V0201 == 3 ~ 'Alugado',
      V0201 == 4 ~ 'Cedido por empregador',
      V0201 == 5 ~ 'Cedido de outra forma',
      V0201 == 6 ~ 'Outra condição'))
  }

  # V0202
  # V0205 Number of bathrooms
  # V0206
  # V0207
  # V0208
  # V0209
  # V0210
  # V0211
  # V0212
  # V0701
  # V0402
  # V6600
  # V6210

  # ### Yes (1) or No (2)
  # vars_sim_nao <- c( 'V0213', 'V0214', 'V0215', 'V0216', 'V0217', 'V0218',
  #                    'V0219', 'V0220', 'V0221', 'V0222', 'V0301')
  #
  #
  # add_sim_nao_labels(data = arrw, column_names = vars_sim_nao)

  # census tract type
  if ('V1005' %in% cols) {
    arrw <- arrw |> mutate(V1005 = case_when(
      V1005 == 1 ~ 'Área urbanizada',
      V1005 == 2 ~ 'Área não urbanizada',
      V1005 == 3 ~ 'Área urbanizada isolada',
      V1005 == 4 ~ 'Área rural de extensão urbana',
      V1005 == 5 ~ 'Aglomerado rural (povoado)',
      V1005 == 6 ~ 'Aglomerado rural (núcleo)',
      V1005 == 7 ~ 'Aglomerado rural (outros)',
      V1005 == 8 ~ 'Área rural exclusive aglomerado rural'))
  }

  return(arrw)
}


df1 <- add_labels_households(arrw = df, lang = 'PT')
df2 <- as.data.frame(df1)

df1 <- add_sim_nao_labels(arrw = df, column_names = vars_sim_nao)

df2 <- as.data.frame(df)
table(df2$V0221 )

# Add labels "Sim", "Nao"
#' @keywords internal
add_sim_nao_labels <- function(arrw, column_names) {

  # names of columns present in the data
  cols_present <- names(arrw)

  for (col in column_names) {
    if (col %in% cols_present) {
      arrw <- arrw |> mutate( {{col}} := case_when(
        {{col}} == 1 ~ 'Sim',
        {{col}} == 2 ~ 'N\u00e3o'))
    }
  }
  return(arrw)
}

