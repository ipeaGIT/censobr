# Add labels to categorical variables of family datasets
#' @keywords internal
add_labels_families <- function(arrw,
                                year = parent.frame()$year,
                                lang = 'pt'){

  # check input
  checkmate::assert_string(lang, pattern = 'pt', na.ok = TRUE)
  if (!(year %in% c(2000, 2010))) {stop('Labels for this data are only available for the years c(2000, 2010)')}

  # names of columns present in the data
  cols <- names(arrw)

  if(year == 2000 & lang == 'pt'){ # nocov start
  ### YEAR 2010

    # REGIÃO METROPOLITANA
    if ('V1004' %in% cols) {
      arrw <- arrw |> mutate(V1004 = case_when(
        V1004 == '01' ~ 'Bel\u00e9m',
        V1004 == '02' ~ 'Grande S\u00e3o Lu\u00eds',
        V1004 == '03' ~ 'Fortaleza',
        V1004 == '04' ~ 'Natal',
        V1004 == '05' ~ 'Recife',
        V1004 == '06' ~ 'Macei\u00f3',
        V1004 == '07' ~ 'Salvador',
        V1004 == '08' ~ 'Belo Horizonte',
        V1004 == '09' ~ 'Colar Metropolitano da RM de Belo Horizonte',
        V1004 == '10' ~ 'Vale do A\u00e7o',
        V1004 == '11' ~ 'Colar Metropolitano da RM do Vale do A\u00e7o',
        V1004 == '12' ~ 'Grande Vit\u00f3ria',
        V1004 == '13' ~ 'Rio de Janeiro',
        V1004 == '14' ~ 'S\u00e3o Paulo',
        V1004 == '15' ~ 'Baixada Santista',
        V1004 == '16' ~ 'Campinas',
        V1004 == '17' ~ 'Curitiba',
        V1004 == '18' ~ 'Londrina',
        V1004 == '19' ~ 'Maring\u00e1',
        V1004 == '20' ~ 'Florian\u00f3polis',
        V1004 == '21' ~ '\u00c1rea de Expans\u00e3o Metropolitana da RM de Florian\u00f3polis',
        V1004 == '22' ~ 'N\u00facleo Metropolitano da RM Vale do Itaja\u00ed',
        V1004 == '23' ~ '\u00c1rea de Expans\u00e3o Metropolitana da RM Vale do Itaja\u00ed',
        V1004 == '24' ~ 'Norte/Nordeste Catarinense',
        V1004 == '25' ~ '\u00c1rea de Expans\u00e3o Metropolitana da RM Norte/Nordeste Catarinense',
        V1004 == '26' ~ 'Porto Alegre',
        V1004 == '27' ~ 'Goi\u00e2nia',
        V1004 == '28' ~ 'RIDE (Regi\u00e3o Integrada de Desenvolvimento do Distrito Federal e Entorno)'))
      }

    # TIPO DE FAMILIA (1)
    if ('CODV0404' %in% cols) {
      arrw <- arrw |> mutate(CODV0404 = case_when(
        CODV0404 == '0' ~ '\u00danica (uma s\u00f3 fam\u00edlia vive no domic\u00edlio)',
        CODV0404 == '1' ~ 'Fam\u00edlias conviventes: 1\u00aa fam\u00edlia',
        CODV0404 == '2' ~ 'Fam\u00edlias conviventes: 2\u00aa fam\u00edlia',
        CODV0404 == '3' ~ 'Fam\u00edlias conviventes: 3\u00aa fam\u00edlia',
        CODV0404 == '4' ~ 'Fam\u00edlias conviventes: 4\u00aa fam\u00edlia',
        CODV0404 == '5' ~ 'Fam\u00edlias conviventes: 5\u00aa fam\u00edlia e mais',
        CODV0404 == '9' ~ 'Morador individual'))
      }

    # TIPO DE FAMILIA (2)
    if ('CODV0404_2' %in% cols) {
      arrw <- arrw |> mutate(CODV0404_2 = case_when(
        CODV0404_2 == '01' ~ 'Casal sem filhos',
        CODV0404_2 == '02' ~ 'Casal com filhos menores de 14 anos',
        CODV0404_2 == '03' ~ 'Casal com filhos de 14 anos ou mais',
        CODV0404_2 == '04' ~ 'Casal com filhos de idades variadas',
        CODV0404_2 == '05' ~ 'M\u00e3e com filhos menores de 14 anos',
        CODV0404_2 == '06' ~ 'M\u00e3e com filhos de 14 anos ou mais',
        CODV0404_2 == '07' ~ 'M\u00e3e com filhos de idades variadas',
        CODV0404_2 == '08' ~ 'Pai com filhos menores de 14 anos',
        CODV0404_2 == '09' ~ 'Pai com filhos de 14 anos ou mais',
        CODV0404_2 == '10' ~ 'Pai com filhos de idades variadas',
        CODV0404_2 == '11' ~ 'Outros tipos de fam\u00edlias',
        CODV0404_2 == '12' ~ 'Morador individual'))
      }

    # CLASSE DE RENDIMENTO NOMINAL FAMILIAR
    if ('CODV4615B' %in% cols) {
      arrw <- arrw |> mutate(CODV4615B = case_when(
        CODV4615B == '01' ~ 'At\u00e9 0,25 sal\u00e1rio m\u00ednimo',
        CODV4615B == '02' ~ 'Mais de 0,25 a 0,5 sal\u00e1rio m\u00ednimo',
        CODV4615B == '03' ~ 'Mais de 0,5 a 1 sal\u00e1rio m\u00ednimo',
        CODV4615B == '04' ~ 'Mais de 1 a 2 sal\u00e1rios m\u00ednimos',
        CODV4615B == '05' ~ 'Mais de 2 a 3 sal\u00e1rios m\u00ednimos',
        CODV4615B == '06' ~ 'Mais de 3 a 5 sal\u00e1rios m\u00ednimos',
        CODV4615B == '07' ~ 'Mais de 5 a 10 sal\u00e1rios m\u00ednimos',
        CODV4615B == '08' ~ 'Mais de 10 a 15 sal\u00e1rios m\u00ednimos',
        CODV4615B == '09' ~ 'Mais de 15 a 20 sal\u00e1rios m\u00ednimos',
        CODV4615B == '10' ~ 'Mais de 20 a 30 sal\u00e1rios m\u00ednimos',
        CODV4615B == '11' ~ 'Mais de 30 sal\u00e1rios m\u00ednimos',
        CODV4615B == '12' ~ 'Sem rendimento'))
    }

    # CLASSE DE RENDIMENTO NOMINAL, RESPONSAVEL/CASAL
    if ('CODV4615C' %in% cols) {
      arrw <- arrw |> mutate(CODV4615C = case_when(
        CODV4615C == '01' ~ 'At\u00e9 0,25 sal\u00e1rio m\u00ednimo',
        CODV4615C == '02' ~ 'Mais de 0,25 a 0,5 sal\u00e1rio m\u00ednimo',
        CODV4615C == '03' ~ 'Mais de 0,5 a 0,75 sal\u00e1rio m\u00ednimo',
        CODV4615C == '04' ~ 'Mais de 0,75 a 1 sal\u00e1rio m\u00ednimo',
        CODV4615C == '05' ~ 'Mais de 1 a 1,25 sal\u00e1rios m\u00ednimos',
        CODV4615C == '06' ~ 'Mais de 1,25 a 1,5 sal\u00e1rios m\u00ednimos',
        CODV4615C == '07' ~ 'Mais de 1,5 a 2 sal\u00e1rios m\u00ednimos',
        CODV4615C == '08' ~ 'Mais de 2 a 3 sal\u00e1rios m\u00ednimos',
        CODV4615C == '09' ~ 'Mais de 3 a 5 sal\u00e1rios m\u00ednimos',
        CODV4615C == '10' ~ 'Mais de 5 a 10 sal\u00e1rios m\u00ednimos',
        CODV4615C == '11' ~ 'Mais de 10 a 15 sal\u00e1rios m\u00ednimos',
        CODV4615C == '12' ~ 'Mais de 15 a 20 sal\u00e1rios m\u00ednimos',
        CODV4615C == '13' ~ 'Mais de 20 a 30 sal\u00e1rios m\u00ednimos',
        CODV4615C == '14' ~ 'Mais de 30 sal\u00e1rios m\u00ednimos',
        CODV4615C == '15' ~ 'Sem rendimento'))
    }

  # CLASSE DE RENDIMENTO NOMINAL FAMILIAR PER-CAPITA
  if ('CODV4615_7400' %in% cols) {
    arrw <- arrw |> mutate(CODV4615_7400 = case_when(
      CODV4615_7400 == '01' ~ 'At\u00e9 0,25 sal\u00e1rio m\u00ednimo',
      CODV4615_7400 == '02' ~ 'Mais de 0,25 a 0,5 sal\u00e1rio m\u00ednimo',
      CODV4615_7400 == '03' ~ 'Mais de 0,5 a 1 sal\u00e1rio m\u00ednimo',
      CODV4615_7400 == '04' ~ 'Mais de 1 a 2 sal\u00e1rios m\u00ednimos',
      CODV4615_7400 == '05' ~ 'Mais de 2 a 3 sal\u00e1rios m\u00ednimos',
      CODV4615_7400 == '06' ~ 'Mais de 3 a 5 sal\u00e1rios m\u00ednimos',
      CODV4615_7400 == '07' ~ 'Mais de 5 a 10 sal\u00e1rios m\u00ednimos',
      CODV4615_7400 == '08' ~ 'Mais de 10 a 15 sal\u00e1rios m\u00ednimos',
      CODV4615_7400 == '09' ~ 'Mais de 15 a 20 sal\u00e1rios m\u00ednimos',
      CODV4615_7400 == '10' ~ 'Mais de 20 a 30 sal\u00e1rios m\u00ednimos',
      CODV4615_7400 == '11' ~ 'Mais de 30 sal\u00e1rios m\u00ednimos',
      CODV4615_7400 == '12' ~ 'Sem rendimento'))
    }
  } # nocov end

  return(arrw)
}
