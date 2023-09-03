# Add labels to categorical variables of family data set
#' @keywords internal
add_labels_families <- function(arrw, year, lang = 'pt'){

  # names of columns present in the data
  cols <- names(arrw)

  if(year == 2000 & lang == 'pt'){
  ### YEAR 2010

    # REGIÃO METROPOLITANA
    if ('V1004' %in% cols) {
      arrw <- arrw |> mutate(V1004 = case_when(
        V1004 == '01' ~ 'Belém',
        V1004 == '02' ~ 'Grande São Luís',
        V1004 == '03' ~ 'Fortaleza',
        V1004 == '04' ~ 'Natal',
        V1004 == '05' ~ 'Recife',
        V1004 == '06' ~ 'Maceió',
        V1004 == '07' ~ 'Salvador',
        V1004 == '08' ~ 'Belo Horizonte',
        V1004 == '09' ~ 'Colar Metropolitano da RM de Belo Horizonte',
        V1004 == '10' ~ 'Vale do Aço',
        V1004 == '11' ~ 'Colar Metropolitano da RM do Vale do Aço',
        V1004 == '12' ~ 'Grande Vitória',
        V1004 == '13' ~ 'Rio de Janeiro',
        V1004 == '14' ~ 'São Paulo',
        V1004 == '15' ~ 'Baixada Santista',
        V1004 == '16' ~ 'Campinas',
        V1004 == '17' ~ 'Curitiba',
        V1004 == '18' ~ 'Londrina',
        V1004 == '19' ~ 'Maringá',
        V1004 == '20' ~ 'Florianópolis',
        V1004 == '21' ~ 'Área de Expansão Metropolitana da RM de Florianópolis',
        V1004 == '22' ~ 'Núcleo Metropolitano da RM Vale do Itajaí',
        V1004 == '23' ~ 'Área de Expansão Metropolitana da RM Vale do Itajaí',
        V1004 == '24' ~ 'Norte/Nordeste Catarinense',
        V1004 == '25' ~ 'Área de Expansão Metropolitana da RM Norte/Nordeste Catarinense',
        V1004 == '26' ~ 'Porto Alegre',
        V1004 == '27' ~ 'Goiânia',
        V1004 == '28' ~ 'RIDE (Região Integrada de Desenvolvimento do Distrito Federal e Entorno)'))
      }

    # TIPO DE FAMÍLIA (1)
    if ('CODV0404' %in% cols) {
      arrw <- arrw |> mutate(CODV0404 = case_when(
        CODV0404 == '0' ~ 'Única (uma só família vive no domicílio)',
        CODV0404 == '1' ~ 'Famílias conviventes: 1ª família',
        CODV0404 == '2' ~ 'Famílias conviventes: 2ª família',
        CODV0404 == '3' ~ 'Famílias conviventes: 3ª família',
        CODV0404 == '4' ~ 'Famílias conviventes: 4ª família',
        CODV0404 == '5' ~ 'Famílias conviventes: 5ª família e mais',
        CODV0404 == '9' ~ 'Morador individual'))
      }

    # TIPO DE FAMÍLIA (2)
    if ('CODV0404_2' %in% cols) {
      arrw <- arrw |> mutate(CODV0404_2 = case_when(
        CODV0404_2 == '01' ~ 'Casal sem filhos',
        CODV0404_2 == '02' ~ 'Casal com filhos menores de 14 anos',
        CODV0404_2 == '03' ~ 'Casal com filhos de 14 anos ou mais',
        CODV0404_2 == '04' ~ 'Casal com filhos de idades variadas',
        CODV0404_2 == '05' ~ 'Mãe com filhos menores de 14 anos',
        CODV0404_2 == '06' ~ 'Mãe com filhos de 14 anos ou mais',
        CODV0404_2 == '07' ~ 'Mãe com filhos de idades variadas',
        CODV0404_2 == '08' ~ 'Pai com filhos menores de 14 anos',
        CODV0404_2 == '09' ~ 'Pai com filhos de 14 anos ou mais',
        CODV0404_2 == '10' ~ 'Pai com filhos de idades variadas',
        CODV0404_2 == '11' ~ 'Outros tipos de famílias',
        CODV0404_2 == '12' ~ 'Morador individual'))
      }

    # CLASSE DE RENDIMENTO NOMINAL FAMILIAR
    if ('CODV4615B' %in% cols) {
      arrw <- arrw |> mutate(CODV4615B = case_when(
        CODV4615B == '01' ~ 'Até 0,25 salário mínimo',
        CODV4615B == '02' ~ 'Mais de 0,25 a 0,5 salário mínimo',
        CODV4615B == '03' ~ 'Mais de 0,5 a 1 salário mínimo',
        CODV4615B == '04' ~ 'Mais de 1 a 2 salários mínimos',
        CODV4615B == '05' ~ 'Mais de 2 a 3 salários mínimos',
        CODV4615B == '06' ~ 'Mais de 3 a 5 salários mínimos',
        CODV4615B == '07' ~ 'Mais de 5 a 10 salários mínimos',
        CODV4615B == '08' ~ 'Mais de 10 a 15 salários mínimos',
        CODV4615B == '09' ~ 'Mais de 15 a 20 salários mínimos',
        CODV4615B == '10' ~ 'Mais de 20 a 30 salários mínimos',
        CODV4615B == '11' ~ 'Mais de 30 salários mínimos',
        CODV4615B == '12' ~ 'Sem rendimento'))
    }

    # CLASSE DE RENDIMENTO NOMINAL, RESPONSAVEL/CASAL
    if ('CODV4615C' %in% cols) {
      arrw <- arrw |> mutate(CODV4615C = case_when(
        CODV4615C == '01' ~ 'Até 0,25 salário mínimo',
        CODV4615C == '02' ~ 'Mais de 0,25 a 0,5 salário mínimo',
        CODV4615C == '03' ~ 'Mais de 0,5 a 0,75 salário mínimo',
        CODV4615C == '04' ~ 'Mais de 0,75 a 1 salário mínimo',
        CODV4615C == '05' ~ 'Mais de 1 a 1,25 salários mínimos',
        CODV4615C == '06' ~ 'Mais de 1,25 a 1,5 salários mínimos',
        CODV4615C == '07' ~ 'Mais de 1,5 a 2 salários mínimos',
        CODV4615C == '08' ~ 'Mais de 2 a 3 salários mínimos',
        CODV4615C == '09' ~ 'Mais de 3 a 5 salários mínimos',
        CODV4615C == '10' ~ 'Mais de 5 a 10 salários mínimos',
        CODV4615C == '11' ~ 'Mais de 10 a 15 salários mínimos',
        CODV4615C == '12' ~ 'Mais de 15 a 20 salários mínimos',
        CODV4615C == '13' ~ 'Mais de 20 a 30 salários mínimos',
        CODV4615C == '14' ~ 'Mais de 30 salários mínimos',
        CODV4615C == '15' ~ 'Sem rendimento'))
    }

  # CLASSE DE RENDIMENTO NOMINAL FAMILIAR PER-CAPITA
  if ('CODV4615_7400' %in% cols) {
    arrw <- arrw |> mutate(CODV4615_7400 = case_when(
      CODV4615_7400 == '01' ~ 'Até 0,25 salário mínimo',
      CODV4615_7400 == '02' ~ 'Mais de 0,25 a 0,5 salário mínimo',
      CODV4615_7400 == '03' ~ 'Mais de 0,5 a 1 salário mínimo',
      CODV4615_7400 == '04' ~ 'Mais de 1 a 2 salários mínimos',
      CODV4615_7400 == '05' ~ 'Mais de 2 a 3 salários mínimos',
      CODV4615_7400 == '06' ~ 'Mais de 3 a 5 salários mínimos',
      CODV4615_7400 == '07' ~ 'Mais de 5 a 10 salários mínimos',
      CODV4615_7400 == '08' ~ 'Mais de 10 a 15 salários mínimos',
      CODV4615_7400 == '09' ~ 'Mais de 15 a 20 salários mínimos',
      CODV4615_7400 == '10' ~ 'Mais de 20 a 30 salários mínimos',
      CODV4615_7400 == '11' ~ 'Mais de 30 salários mínimos',
      CODV4615_7400 == '12' ~ 'Sem rendimento'))
    }
  }

  return(arrw)
}
