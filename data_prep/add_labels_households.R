# Add labels to categorical variables of household datasets
#' @keywords internal
add_labels_households <- function(arrw, year, lang = 'pt'){

  # check languate input
  checkmate::assert_string(lang, pattern = 'pt', na.ok = TRUE)

  # names of columns present in the data
  cols <- names(arrw)

  # ALL YEARS ------------------------------------------------------------------

  # urban vs rural
  if ('V1006' %in% cols) {
    arrw <- mutate(arrw, V1006 = case_when(
      V1006 == '1' ~'Urbana',
      V1006 == '2' ~'Rural'))
  }


  # YEAR 2010 ------------------------------------------------------------------
    if (year == 2010 & lang == 'pt') {

      # Private vs collective household
      if ('V4001' %in% cols) {
        arrw <- mutate(arrw, V4001 = case_when(
          V4001 == '1' ~'Domicílio particular permanente ocupado',
          V4001 == '2' ~'Domicílio particular permanente ocupado sem entrevista realizada',
          V4001 == '5' ~'Domicílio particular improvisado ocupado',
          V4001 == '6' ~'Domicílio coletivo com morador'))
      }

      # household type
      if ('V4002' %in% cols) {
        arrw <- mutate(arrw, V4002 = case_when(
          V4002 == '11' ~ 'Casa',
          V4002 == '12' ~ 'Casa de vila ou em condomínio',
          V4002 == '13' ~ 'Apartamento',
          V4002 == '14' ~ 'Habitação em: casa de cômodos, cortiço ou cabeça de porco',
          V4002 == '15' ~ 'Oca ou maloca ',
          V4002 == '51' ~ 'Tenda ou barraca',
          V4002 == '52' ~ 'Dentro de estabelecimento',
          V4002 == '53' ~ 'Outro (vagão, trailer, gruta, etc)',
          V4002 == '61' ~ 'Asilo, orfanato e similares  com morador',
          V4002 == '62' ~ 'Hotel, pensão e similares com morador',
          V4002 == '63' ~ 'Alojamento de trabalhadores com morador',
          V4002 == '64' ~ 'Penitenciária, presídio ou casa de detenção com morador'))
      }

      # household tenure / occupancy status
      if ('V0201' %in% cols) {
        arrw <- mutate(arrw, V0201 = case_when(
          V0201 == '1' ~ 'Próprio de algum morador - já pago',
          V0201 == '2' ~ 'Próprio de algum morador - ainda pagando',
          V0201 == '3' ~ 'Alugado',
          V0201 == '4' ~ 'Cedido por empregador',
          V0201 == '5' ~ 'Cedido de outra forma',
          V0201 == '6' ~ 'Outra condição'))
      }

      # material used to build household wall
      if ('V0202' %in% cols) {
        arrw <- mutate(arrw, V0202 = case_when(
          V0202 == '1' ~ 'Alvenaria com revestimento',
          V0202 == '2' ~ 'Alvenaria sem revestimento',
          V0202 == '3' ~ 'Madeira apropriada para construção (aparelhada)',
          V0202 == '4' ~ 'Taipa revestida',
          V0202 == '5' ~ 'Taipa não revestida',
          V0202 == '6' ~ 'Madeira aproveitada',
          V0202 == '7' ~ 'Palha',
          V0202 == '8' ~ 'Outro material',
          V0202 == '9' ~ 'Sem parede'))
        }


      # type of sanitation connection
      if ('V0207' %in% cols) {
        arrw <- mutate(arrw, V0207 = case_when(
          V0207 == '1' ~ 'Rede geral de esgoto ou pluvial',
          V0207 == '2' ~ 'Fossa séptica',
          V0207 == '3' ~ 'Fossa rudimentar',
          V0207 == '4' ~ 'Vala',
          V0207 == '5' ~ 'Rio, lago ou mar',
          V0207 == '6' ~ 'Outro'))
      }

      # access to water
        if ('V0208' %in% cols) {
          arrw <- mutate(arrw, V0208 = case_when(
            V0208 == '01' ~ 'Rede geral de distribuição',
            V0208 == '02' ~ 'Poço ou nascente na propriedade',
            V0208 == '03' ~ 'Poço ou nascente fora da propriedade',
            V0208 == '04' ~ 'Carro-pipa',
            V0208 == '05' ~ 'Água da chuva armazenada em cisterna',
            V0208 == '06' ~ 'Água da chuva armazenada de outra forma',
            V0208 == '07' ~ 'Rios, açudes, lagos e igarapés',
            V0208 == '08' ~ 'Outra',
            V0208 == '09' ~ 'Poço ou nascente na aldeia',
            V0208 == '10' ~ 'Poço ou nascente fora da aldeia'))
          }

      # water connection
      if ('V0209' %in% cols) {
        arrw <- mutate(arrw, V0209 = case_when(
          V0209 == '1' ~ 'Sim, em pelo menos um cômodo',
          V0209 == '2' ~ 'Sim, só na propriedade ou terreno',
          V0209 == '3' ~ 'Não'))
        }

      # waste treatment
      if ('V0210' %in% cols) {
        arrw <- mutate(arrw, V0210 = case_when(
          V0210 == '1' ~ 'Coletado diretamente por serviço de limpeza',
          V0210 == '2' ~ 'Colocado em caçamba de serviço de limpeza',
          V0210 == '3' ~ 'Queimado (na propriedade)',
          V0210 == '4' ~ 'Enterrado (na propriedade)',
          V0210 == '5' ~ 'Jogado em terreno baldio ou logradouro',
          V0210 == '6' ~ 'Jogado em rio, lago ou mar',
          V0210 == '7' ~ 'Tem outro destino'))
      }

      # eletricity
      if ('V0211' %in% cols) {
        arrw <- mutate(arrw, V0211 = case_when(
          V0211 == '1' ~ 'Sim, de companhia distribuidora',
          V0211 == '2' ~ 'Sim, de outras fontes',
          V0211 == '3' ~ 'Não existe energia elétrica'))
      }

      # eletricity meter
      if ('V0212' %in% cols) {
        arrw <- mutate(arrw, V0212 = case_when(
          V0212 == '1' ~'Sim, de uso exclusivo',
          V0212 == '2' ~'Sim, de uso comum ',
          V0212 == '3' ~'Não tem medidor ou relógio'))
      }

      # shared household head
      if ('V0402' %in% cols) {
        arrw <- mutate(arrw, V0402 = case_when(
          V0402 == '1' ~ 'Apenas um morador',
          V0402 == '2' ~ 'Mais de um morador',
          V0402 == '9' ~ 'Ignorado'))
        }

      # type of domestic / family
      if ('V6600' %in% cols) {
        arrw <- mutate(arrw, V6600 = case_when(
          V6600 == '1' ~ 'Unipessoal',
          V6600 == '2' ~ 'Nuclear',
          V6600 == '3' ~ 'Estendida',
          V6600 == '4' ~ 'Composta'))
        }

      # adequate housing
      if ('V6210' %in% cols) {
        arrw <- mutate(arrw, V6210 = case_when(
          V6210 == '1' ~ 'Adequada',
          V6210 == '2' ~ 'Semi-adequada',
          V6210 == '3' ~ 'Inadequada'))
      }

      # census tract type
      if ('V1005' %in% cols) {
        arrw <- mutate(arrw, V1005 = case_when(
          V1005 == '1' ~ 'Área urbanizada',
          V1005 == '2' ~ 'Área não urbanizada',
          V1005 == '3' ~ 'Área urbanizada isolada',
          V1005 == '4' ~ 'Área rural de extensão urbana',
          V1005 == '5' ~ 'Aglomerado rural (povoado)',
          V1005 == '6' ~ 'Aglomerado rural (núcleo)',
          V1005 == '7' ~ 'Aglomerado rural (outros)',
          V1005 == '8' ~ 'Área rural exclusive aglomerado rural'))
      }

      ### Yes (1) or No (2) columns
      vars_sim_nao <- c('V0206', 'V0213', 'V0214', 'V0215', 'V0216', 'V0217', 'V0218',
                        'V0219', 'V0220', 'V0221', 'V0222', 'V0301', 'V0701')

      # mutate only colnames present
      vars_sim_nao_present <- vars_sim_nao[vars_sim_nao %in% cols]
      arrw <- dplyr::mutate(arrw, dplyr::across(all_of(vars_sim_nao_present),
                                                ~ if_else(.x == '1', 'Sim', 'N\u00e3o')
                                                ))
      # arrw <- mutate_at(arrw,
      #                   .vars = vars_sim_nao_present,
      #                   .funs = add_sim_nao_labels)
      ## mutate(mtcars, across(all_of(cols_to_change), fchange))

      # arrw <- add_sim_nao_labels2(arrw, column_names = vars_sim_nao)
    }

  # YEAR 2000----------------------------------------------------------------
  if(year == 2000 & lang == 'pt'){

      # REGIÃO METROPOLITANA
      if ('V1004' %in% cols) {
        arrw <- mutate(arrw, V1004 = case_when(
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

      # SITUAÇÃO DO SETOR
      if ('V1005' %in% cols) {
        arrw <- mutate(arrw, V1005 = case_when(
          V1005 == '1' ~ 'Área urbanizada de vila ou cidade',
          V1005 == '2' ~ 'Área não urbanizada de vila ou cidade',
          V1005 == '3' ~ 'Área urbanizada isolada',
          V1005 == '4' ~ 'Rural - extensão urbana',
          V1005 == '5' ~ 'Rural - povoado',
          V1005 == '6' ~ 'Rural - núcleo',
          V1005 == '7' ~ 'Rural - outros aglomerados',
          V1005 == '8' ~ 'Rural - exclusive os aglomerados rurais'))
        }

      # TIPO DO SETOR
      if ('V1007' %in% cols) {
        arrw <- mutate(arrw, V1007 = case_when(
          V1007 == '0' ~ 'Setor comum ou não especial',
          V1007 == '1' ~ 'Setor especial de aglomerado subnormal',
          V1007 == '2' ~ 'Setor especial de quartéis, bases militares, etc.',
          V1007 == '3' ~ 'Setor especial de alojamento, acampamentos, etc.',
          V1007 == '4' ~ 'Setor especial de embarcações, barcos, navios, etc.',
          V1007 == '5' ~ 'Setor especial de aldeia indígena',
          V1007 == '6' ~ 'Setor especial de penitenciárias, colônias penais, presídios, cadeias, etc.',
          V1007 == '7' ~ 'Setor especial de asilos, orfanatos, conventos, hospitais, etc.'))
        }

      # ESPÉCIE DE DOMICILIO
      if ('V0201' %in% cols) {
        arrw <- mutate(arrw, V0201 = case_when(
          V0201 == '1' ~ 'Particular permanente',
          V0201 == '2' ~ 'Particular improvisado',
          V0201 == '3' ~ 'Coletivo'))
        }

      # TIPO DO DOMICÍLIO
      if ('V0202' %in% cols) {
        arrw <- mutate(arrw, V0202 = case_when(
          V0202 == '1' ~ 'Casa',
          V0202 == '2' ~ 'Apartamento',
          V0202 == '3' ~ 'Cômodo'))
        }

      # CONDIÇÃO DO DOMICÍLIO
      if ('V0205' %in% cols) {
        arrw <- mutate(arrw, V0205 = case_when(
          V0205 == '1' ~ 'Próprio, já pago',
          V0205 == '2' ~ 'Próprio, ainda pagando',
          V0205 == '3' ~ 'Alugado',
          V0205 == '4' ~ 'Cedido por empregador',
          V0205 == '5' ~ 'Cedido de outra forma',
          V0205 == '6' ~ 'Outra Condição'))
        }

      # CONDIÇÃO DO TERRENO
      if ('V0206' %in% cols) {
        arrw <- mutate(arrw, V0206 = case_when(
          V0206 == '1' ~ 'Próprio',
          V0206 == '2' ~ 'Cedido',
          V0206 == '3' ~ 'Outra condição'))
        }

      # FORMA DE ABASTECIMENTO DE ÁGUA
      if ('V0207' %in% cols) {
        arrw <- mutate(arrw, V0207 = case_when(
          V0207 == '1' ~ 'Rede geral',
          V0207 == '2' ~ 'Poço ou nascente (na propriedade)',
          V0207 == '3' ~ 'Outra'))
        }

      # TIPO DE CANALIZAÇÃO
      if ('V0208' %in% cols) {
        arrw <- mutate(arrw, V0208 = case_when(
          V0208 == '1' ~ 'Canalizada em pelo menos um cômodo',
          V0208 == '2' ~ 'Canalizada só na propriedade ou terreno',
          V0208 == '3' ~ 'Não canalizada'))
      }

      # TIPO DE ESCOADOURO
      if ('V0211' %in% cols) {
        arrw <- mutate(arrw, V0211 = case_when(
          V0211 == '1' ~ 'Rede geral de esgoto ou pluvial',
          V0211 == '2' ~ 'Fossa séptica',
          V0211 == '3' ~ 'Fossa rudimentar',
          V0211 == '4' ~ 'Vala',
          V0211 == '5' ~ 'Rio, lago ou mar',
          V0211 == '6' ~ 'Outro escoadouro'))
        }

      # COLETA DE LIXO
      if ('V0212' %in% cols) {
        arrw <- mutate(arrw, V0212 = case_when(
          V0212 == '1' ~ 'Coletado por serviço de limpeza',
          V0212 == '2' ~ 'Colocado em caçamba de serviço de limpeza',
          V0212 == '3' ~ 'Queimado (na propriedade)',
          V0212 == '4' ~ 'Enterrado (na propriedade)',
          V0212 == '5' ~ 'Jogado em terreno baldio ou logradouro',
          V0212 == '6' ~ 'Jogado em rio, lago ou mar',
          V0212 == '7' ~ 'Tem outro destino'))
        }

      # EXISTÊNCIA DE CALÇAMENTO/PAVIMENTAÇÃO
      if ('V1113' %in% cols) {
        arrw <- mutate(arrw, V1113 = case_when(
          V1113 == '1' ~ 'Total',
          V1113 == '2' ~ 'Parcial',
          V1113 == '3' ~ 'Não Existe'))
        }


      ### Yes (1) or No (2) columns
      vars_sim_nao <- c('V0210', 'V0213', 'V0214', 'V0215', 'V0216', 'V0217',
                        'V0218', 'V0219', 'V0220', 'V1111', 'V1112')

      # mutate only colnames present
      vars_sim_nao_present <- vars_sim_nao[vars_sim_nao %in% cols]
      arrw <- dplyr::mutate(arrw, dplyr::across(all_of(vars_sim_nao_present),
                                                ~ if_else(.x == '1', 'Sim', 'N\u00e3o')
                                                ))
  }

  return(arrw)
}
