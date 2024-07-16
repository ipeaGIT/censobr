# integer
# 1980
# 1970
# 2000

# Add basic geography variables
#' @keywords internal
add_geography_cols <- function(arrw, year){


  # get code_muni
  col <- case_when(year == 1970 ~ 'code_muni',
                   year == 1980 ~ 'code_muni',
                   year == 1991 ~ 'code_muni',
                   year == 2010 ~ 'V0002',
                   year == 2022 ~ 'CD_MUN',
                   year == 2000 ~ 'V1103')

  if(year %in% c(2000, 2010)){
    arrw <- mutate(arrw,
                   code_muni = get(col))
  }

  # weighting area
  # get code_weighting
  col <- case_when(year == 2010 ~ 'V0011',
                   year == 2000 ~ 'AREAP')

  if(year %in% c(2000, 2010)){
  arrw <- mutate(arrw,
                 code_weighting = get(col))
  }

  # state name
  col <- case_when(year == 1970 ~ 'code_state',
                   year == 1980 ~ 'V2',
                   year == 1991 ~ 'V1101',
                   year == 2010 ~ 'V0001',
                   year == 2000 ~ 'V0102')
  arrw <- mutate(arrw,
                 code_state = get(col))

  arrw <- mutate(arrw,
                 name_state = case_when(
                   code_state == 11 ~'Rondônia',
                   code_state == 12 ~'Acre',
                   code_state == 13 ~'Amazonas',
                   code_state == 14 ~'Roraima',
                   code_state == 15 ~'Pará',
                   code_state == 16 ~'Amapá',
                   code_state == 17 ~'Tocantins',
                   code_state == 21 ~'Maranhão',
                   code_state == 22 ~'Piauí',
                   code_state == 23 ~'Ceará',
                   code_state == 24 ~'Rio Grande do Norte',
                   code_state == 25 ~'Paraíba',
                   code_state == 26 ~'Pernambuco',
                   code_state == 27 ~'Alagoas',
                   code_state == 28 ~'Sergipe',
                   code_state == 29 ~'Bahia',
                   code_state == 31 ~'Minas Gerais',
                   code_state == 32 ~'Espírito Santo',
                   code_state == 33 ~'Rio de Janeiro',
                   code_state == 35 ~'São Paulo',
                   code_state == 41 ~'Paraná',
                   code_state == 42 ~'Santa Catarina',
                   code_state == 43 ~'Rio Grande do Sul',
                   code_state == 50 ~'Mato Grosso do Sul',
                   code_state == 51 ~'Mato Grosso',
                   code_state == 52 ~'Goiás',
                   code_state == 53 ~'Distrito Federal'))
  # abbrev name
  arrw <- mutate(arrw,
                 abbrev_state = case_when(
                   code_state == 11 ~'RO',
                   code_state == 12 ~'AC',
                   code_state == 13 ~'AM',
                   code_state == 14 ~'RR',
                   code_state == 15 ~'PA',
                   code_state == 16 ~'AP',
                   code_state == 17 ~'TO',
                   code_state == 21 ~'MA',
                   code_state == 22 ~'PI',
                   code_state == 23 ~'CE',
                   code_state == 24 ~'RN',
                   code_state == 25 ~'PB',
                   code_state == 26 ~'PE',
                   code_state == 27 ~'AL',
                   code_state == 28 ~'SE',
                   code_state == 29 ~'BA',
                   code_state == 31 ~'MG',
                   code_state == 32 ~'ES',
                   code_state == 33 ~'RJ',
                   code_state == 35 ~'SP',
                   code_state == 41 ~'PR',
                   code_state == 42 ~'SC',
                   code_state == 43 ~'RS',
                   code_state == 50 ~'MS',
                   code_state == 51 ~'MT',
                   code_state == 52 ~'GO',
                   code_state == 53 ~'DF'))

  # region name
  arrw <- mutate(arrw,
                 code_region = substr(code_state, 1, 1),
                 name_region = case_when(
                   code_region == 1 ~'Norte',
                   code_region == 2 ~'Nordeste',
                   code_region == 3 ~'Sudeste',
                   code_region == 4 ~'Sul',
                   code_region == 5 ~'Centro-oeste')
                 )

  # other regions
  if(year %in% c(1991)){
    arrw <- mutate(arrw,
                   code_meso = V7001,
                   code_micro = V7002,
                   code_metro = V7003)
  }


  # other regions
  if(year %in% c(1980)){
    arrw <- mutate(arrw,
                   code_meso = V3,
                   code_micro = V3)
    }


  ## reoder columns

  if (year %in% c(2000, 2010)) {
      arrw <- relocate(arrw, c(code_muni, code_state, abbrev_state, name_state, code_region, name_region, code_weighting))
      }

  if (year %in% c(1991)) {
    arrw <- relocate(arrw, c(code_muni, code_state, abbrev_state, name_state, code_region, name_region, code_meso, code_micro, code_metro))
  }

  if (year %in% c(1980)) {
    arrw <- relocate(arrw, c(code_muni, code_muni_1980, code_state, abbrev_state, name_state, code_region, name_region, code_meso, code_micro))
  }

  if (year %in% c(1970)) {
      arrw <- relocate(arrw, c(code_muni, code_muni_1970, code_state, abbrev_state, name_state, code_region, name_region))
      }

  # all code columns to integer (except code_weighting)
  num_vars2 <- names(arrw)[names(arrw) %like% 'code_']
  num_vars2 <- num_vars2[!num_vars2 %like% 'code_weighting']

  arrw <- mutate(arrw, across(all_of(num_vars2),
                          ~ as.integer(as.numeric(.x))))

  return(arrw)
  }






# Add basic geography variables to census tract data
#' @keywords internal
add_geography_cols_tracts <- function(arrw, year){


  # get code_muni from weighting area
  col <- case_when(year == 2010 ~ 'code_muni')

  #
  # # weighting area
  # if(year %in% c(2000, 2010)){
  #   arrw <- mutate(arrw,
  #                  code_weighting = get(col))
  # }

  # state name
  arrw <- mutate(arrw,
                 code_state = as.character(substr(get(col), 1, 2)))

  arrw <- mutate(arrw,
                 name_state = case_when(
                   code_state == '11' ~'Rondônia',
                   code_state == '12' ~'Acre',
                   code_state == '13' ~'Amazonas',
                   code_state == '14' ~'Roraima',
                   code_state == '15' ~'Pará',
                   code_state == '16' ~'Amapá',
                   code_state == '17' ~'Tocantins',
                   code_state == '21' ~'Maranhão',
                   code_state == '22' ~'Piauí',
                   code_state == '23' ~'Ceará',
                   code_state == '24' ~'Rio Grande do Norte',
                   code_state == '25' ~'Paraíba',
                   code_state == '26' ~'Pernambuco',
                   code_state == '27' ~'Alagoas',
                   code_state == '28' ~'Sergipe',
                   code_state == '29' ~'Bahia',
                   code_state == '31' ~'Minas Gerais',
                   code_state == '32' ~'Espírito Santo',
                   code_state == '33' ~'Rio de Janeiro',
                   code_state == '35' ~'São Paulo',
                   code_state == '41' ~'Paraná',
                   code_state == '42' ~'Santa Catarina',
                   code_state == '43' ~'Rio Grande do Sul',
                   code_state == '50' ~'Mato Grosso do Sul',
                   code_state == '51' ~'Mato Grosso',
                   code_state == '52' ~'Goiás',
                   code_state == '53' ~'Distrito Federal'))
  # abbrev name
  arrw <- mutate(arrw,
                 abbrev_state = case_when(
                   code_state == '11' ~'RO',
                   code_state == '12' ~'AC',
                   code_state == '13' ~'AM',
                   code_state == '14' ~'RR',
                   code_state == '15' ~'PA',
                   code_state == '16' ~'AP',
                   code_state == '17' ~'TO',
                   code_state == '21' ~'MA',
                   code_state == '22' ~'PI',
                   code_state == '23' ~'CE',
                   code_state == '24' ~'RN',
                   code_state == '25' ~'PB',
                   code_state == '26' ~'PE',
                   code_state == '27' ~'AL',
                   code_state == '28' ~'SE',
                   code_state == '29' ~'BA',
                   code_state == '31' ~'MG',
                   code_state == '32' ~'ES',
                   code_state == '33' ~'RJ',
                   code_state == '35' ~'SP',
                   code_state == '41' ~'PR',
                   code_state == '42' ~'SC',
                   code_state == '43' ~'RS',
                   code_state == '50' ~'MS',
                   code_state == '51' ~'MT',
                   code_state == '52' ~'GO',
                   code_state == '53' ~'DF'))

  # region name
  arrw <- mutate(arrw,
                 code_region = substr(code_state, 1, 1),
                 name_region = case_when(
                   code_region == '1' ~'Norte',
                   code_region == '2' ~'Nordeste',
                   code_region == '3' ~'Sudeste',
                   code_region == '4' ~'Sul',
                   code_region == '5' ~'Centro-oeste'))




  ## reoder columns

  if (year %in% c(2010)) {
    arrw <- relocate(arrw, c(code_tract, code_weighting, code_muni, code_state, abbrev_state, name_state, code_region, name_region)) # code_weighting
  }

  return(arrw)
}

