# Add labels to categorical variables of population datasets
#' @keywords internal
add_labels_population <- function(arrw, year, lang = 'pt'){

  # check languate input
  checkmate::assert_string(lang, pattern = 'pt')

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

      # RELAÇÃO DE PARENTESCO OU DE CONVIVÊNCIA COM A PESSOA RESPONSÁVEL PELO DOMICÍLIO
      if ('V0502' %in% cols) {
        arrw <- mutate(arrw, V0502 = case_when(
          V0502 == '01' ~ 'Pessoa responsável pelo domicílio ',
          V0502 == '02' ~ 'Cônjuge ou companheiro(a) de sexo diferente',
          V0502 == '03' ~ 'Cônjuge ou companheiro(a) do mesmo sexo',
          V0502 == '04' ~ 'Filho(a) do responsável e do cônjuge',
          V0502 == '05' ~ 'Filho(a) somente do responsável',
          V0502 == '06' ~ 'Enteado(a)',
          V0502 == '07' ~ 'Genro ou nora',
          V0502 == '08' ~ 'Pai, mãe, padrasto ou madrasta',
          V0502 == '09' ~ 'Sogro(a)',
          V0502 == '10' ~ 'Neto(a)',
          V0502 == '11' ~ 'Bisneto(a)',
          V0502 == '12' ~ 'Irmão ou irmã',
          V0502 == '13' ~ 'Avô ou avó',
          V0502 == '14' ~ 'Outro parente',
          V0502 == '15' ~ 'Agregado(a)',
          V0502 == '16' ~ 'Convivente',
          V0502 == '17' ~ 'Pensionista',
          V0502 == '18' ~ 'Empregado(a) doméstico(a)',
          V0502 == '19' ~ 'Parente do(a) empregado(a)  doméstico(a)',
          V0502 == '20' ~ 'Individual em domicílio coletivo'))
          }

      # sex
      if ('V0601' %in% cols) {
        arrw <- arrw |> mutate(V0601 = case_when(
          V0601 == '1' ~ 'Masculino',
          V0601 == '2' ~ 'Feminino',
          V0601==  '9' ~ 'Ignorado'))
      }

      # FORMA DE DECLARAÇÃO DA IDADE:
      if ('V6040' %in% cols) {
        arrw <- arrw |> mutate(V6040 = case_when(
          V6040 == '1' ~ 'Data de nascimento',
          V6040 == '2' ~ 'Idade declarada'))
      }

      # COR OU RAÇA
      if ('V0606' %in% cols) {
        arrw <- mutate(arrw, V0606 = case_when(
          V0606 == '1' ~ 'Branca',
          V0606 == '2' ~ 'Preta',
          V0606 == '3' ~ 'Amarela',
          V0606 == '4' ~ 'Parda',
          V0606 == '5' ~ 'Indígena',
          V0606 == '9' ~ 'Ignorado'))
        }

      # REGISTRO DE NASCIMENTO
      if ('V0613' %in% cols) {
        arrw <- mutate(arrw, V0613 = case_when(
          V0613 == '1' ~ 'Do cartório',
          V0613 == '2' ~ 'Declaração de nascido vivo (DNV) do hospital ou da maternidade',
          V0613 == '3' ~ 'Registro administrativo de nascimento indígena (RANI)',
          V0613 == '4' ~ 'Não tem',
          V0613 == '5' ~ 'Não sabe',
          V0613 == '9' ~ 'Ignorado'))
        }

      # physical disabilities
      pd_vars <- c('V0614', 'V0615', 'V0616')
      pd_vars <- pd_vars[pd_vars %in% cols]
      arrw <- dplyr::mutate(arrw, dplyr::across(all_of(pd_vars),
                                                ~ case_when(
                                                  .x == '1' ~ 'Sim, não consegue de modo algum',
                                                  .x == '2' ~ 'Sim, grande dificuldade',
                                                  .x == '3' ~ 'Sim, alguma dificuldade',
                                                  .x == '4' ~ 'Não, nenhuma dificuldade')))

      # NASCEU NESTE MUNICÍPIO
      if ('V0618' %in% cols) {
        arrw <- mutate(arrw, V0618 = case_when(
          V0618 == '1' ~ 'Sim, e sempre morou',
          V0618 == '2' ~ 'Sim mas morou em outro município ou país estrangeiro',
          V0618 == '3' ~ 'Não'))
        }

      # NASCEU NESTA UNIDADE DA FEDERAÇÃO
      if ('V0619' %in% cols) {
        arrw <- mutate(arrw, V0619 = case_when(
          V0619 == '1' ~ 'Sim, e sempre morou',
          V0619 == '2' ~ 'Sim, mas morou em outra UF ou país estrangeiro',
          V0619 == '3' ~ 'Não'))
        }

      # NACIONALIDADE
      if ('V0620' %in% cols) {
        arrw <- mutate(arrw, V0620 = case_when(
          V0620 == '1' ~ 'Brasileiro nato',
          V0620 == '2' ~ 'Naturalizado brasileiro',
          V0620 == '3' ~ 'Estrangeiro'))
        }

      ## migration block
      # V6222 UF de nascimento
      # V6224 pais de nascimento
      # V0625
      # V6252
      # V6254
      # V6256
      # V0626
      # V6262
      # V6264
      # V6266

      # FREQUENTA ESCOLA OU CRECHE
      if ('V0628' %in% cols) {
        arrw <- mutate(arrw, V0628 = case_when(
          V0628 == '1' ~ 'Sim, pública ',
          V0628 == '2' ~ 'Sim, particular',
          V0628 == '3' ~ 'Não, já frequentou',
          V0628 == '4' ~ 'Não, nunca frequentou'))
        }

      # CURSO QUE FREQUENTA
      if ('V0629' %in% cols) {
        arrw <- mutate(arrw, V0629 = case_when(
          V0629 == '01' ~ "Creche",
          V0629 == '02' ~ "Pré-escolar (maternal e jardim da infância)",
          V0629 == '03' ~ "Classe de alfabetização - CA",
          V0629 == '04' ~ "Alfabetização de jovens e adultos",
          V0629 == '05' ~ "Regular do ensino fundamental",
          V0629 == '06' ~ "Educação de jovens e adultos - EJA - ou supletivo do ensino fundamental",
          V0629 == '07' ~ "Regular do ensino médio",
          V0629 == '08' ~ "Educação de jovens e adultos - EJA - ou supletivo do ensino médio",
          V0629 == '09' ~ "Superior de graduação",
          V0629 == '10' ~ "Especialização de nível superior ( mínimo de 360 horas )",
          V0629 == '11' ~ "Mestrado",
          V0629 == '12' ~ "Doutorado"))
        }

      # SÉRIE / ANO QUE FREQUENTA
      if ('V0630' %in% cols) {
        arrw <- mutate(arrw, V0630 = case_when(
          V0630 == '01' ~ 'Primeiro ano',
          V0630 == '02' ~ 'Primeira série - Segundo ano',
          V0630 == '03' ~ 'Segunda série - Terceiro ano',
          V0630 == '04' ~ 'Terceira série - Quarto ano',
          V0630 == '05' ~ 'Quarta série - Quinto ano',
          V0630 == '06' ~ 'Quinta série - Sexto ano',
          V0630 == '07' ~ 'Sexta série - Sétimo ano',
          V0630 == '08' ~ 'Sétima série - Oitavo ano',
          V0630 == '09' ~ 'Oitava série - Nono ano',
          V0630 == '10' ~ 'Não seriado'))
        }

      # SÉRIE QUE FREQUENTA
      if ('V0631' %in% cols) {
        arrw <- mutate(arrw, V0631 = case_when(
          V0631 == '1' ~ 'Primeira série',
          V0631 == '2' ~ 'Segunda série',
          V0631 == '3' ~ 'Terceira série',
          V0631 == '4' ~ 'Quarta série',
          V0631 == '5' ~ 'Não seriado'))
        }

      # CURSO MAIS ELEVADO QUE FREQUENTOU
      if ('V0633' %in% cols) {
        arrw <- mutate(arrw, V0633 = case_when(
          V0633 == '01' ~ "Creche, pré-escolar (maternal e jardim de infância), classe de alfabetização - CA",
          V0633 == '02' ~ "Alfabetização de jovens e adultos",
          V0633 == '03' ~ "Antigo primário (elementar)",
          V0633 == '04' ~ "Antigo ginásio (médio 1º ciclo)",
          V0633 == '05' ~ "Ensino fundamental ou 1º grau (da 1ª a 3ª série/ do 1º ao 4º ano)",
          V0633 == '06' ~ "Ensino fundamental ou 1º grau (4ª série/ 5º ano)",
          V0633 == '07' ~ "Ensino fundamental ou 1º grau (da 5ª a 8ª série/ 6º ao 9º ano)",
          V0633 == '08' ~ "Supletivo do ensino fundamental ou do 1º grau",
          V0633 == '09' ~ "Antigo científico, clássico, etc.....(médio 2º ciclo)",
          V0633 == '10' ~ "Regular ou supletivo do ensino médio ou do 2º grau",
          V0633 == '11' ~ "Superior de graduação",
          V0633 == '12' ~ "Especialização de nível superior ( mínimo de 360 horas )",
          V0633 == '13' ~ "Mestrado",
          V0633 == '14' ~ "Doutorado"))
        }

      # ESPÉCIE DO CURSO MAIS ELEVADO CONCLUÍDO
      if ('V0635' %in% cols) {
        arrw <- mutate(arrw, V0635 = case_when(
          V0635 == '1' ~ 'Superior de graduação',
          V0635 == '2' ~ 'Mestrado',
          V0635 == '3' ~ 'Doutorado'))
        }

      # NÍVEL DE INSTRUÇÃO
      if ('V6400' %in% cols) {
        arrw <- mutate(arrw, V6400 = case_when(
          V6400 == '1' ~ "Sem instrução e fundamental incompleto",
          V6400 == '2' ~ "Fundamental completo e médio incompleto",
          V6400 == '3' ~ "Médio completo e superior incompleto",
          V6400 == '4' ~ "Superior completo"))
        }

      # V6352 curso superior de graduacao
      # V6354 curso superior de mestrado
      # V6356 curso superior de doutorado

      # MUNICÍPIO E UNIDADE DA FEDERAÇÃO OU PAÍS ESTRANGEIRO QUE FREQUENTAVA ESCOLA (OU CRECHE):
      if ('V0636' %in% cols) {
        arrw <- mutate(arrw, V0636 = case_when(
          V0636 == '1' ~ 'Neste município',
          V0636 == '2' ~ 'Em outro município',
          V0636 == '3' ~ 'Em país estrangeiro'))
        }

      # V6362 municipio q frequenta escola
      # V6364 uf q frequenta escola
      # V6366 pais q frequenta escola

      # VIVE EM COMPANHIA DE CÔNJUGE OU COMPANHEIRO(A):
      if ('V0637' %in% cols) {
        arrw <- mutate(arrw, V0637 = case_when(
          V0637 == '1' ~ 'Sim',
          V0637 == '2' ~ 'Não, mas viveu',
          V0637 == '3' ~ 'Não, nunca viveu'))
        }


      # NATUREZA DA UNIÃO
      if ('V0639' %in% cols) {
        arrw <- mutate(arrw, V0639 = case_when(
          V0639 == '1' ~ 'Casamento civil e religioso',
          V0639 == '2' ~ 'Só casamento civil',
          V0639 == '3' ~ 'Só casamento religioso',
          V0639 == '4' ~ 'União consensual'))
        }

      # ESTADO CIVIL
      if ('V0640' %in% cols) {
        arrw <- mutate(arrw, V0640 = case_when(
          V0640 == '1' ~ 'Casado(a)',
          V0640 == '2' ~ 'Desquitado(a) ou separado(a) judicialmente',
          V0640 == '3' ~ 'Divorciado(a)',
          V0640 == '4' ~ 'Viúvo(a)',
          V0640 == '5' ~ 'Solteiro(a)'))
        }

      # QUANTOS TRABALHOS TINHA
      if ('V0645' %in% cols) {
        arrw <- mutate(arrw, V0645 = case_when(
          V0645 == '1' ~ 'Um',
          V0645 == '2' ~ 'Dois ou mais'))
        }

      # V6461 codigo ocupacao
      # V6471 codigo atividade

      # NESSE TRABALHO ERA
      if ('V0648' %in% cols) {
        arrw <- mutate(arrw, V0648 = case_when(
          V0648 == '1' ~ "Empregado com carteira de trabalho assinada ",
          V0648 == '2' ~ "Militar do exército, marinha, aeronáutica, policia militar ou corpo de bombeiros",
          V0648 == '3' ~ "Empregado pelo regime jurídico dos funcionários públicos",
          V0648 == '4' ~ "Empregado sem carteira de trabalho assinada",
          V0648 == '5' ~ "Conta própria",
          V0648 == '6' ~ "Empregador",
          V0648 == '7' ~ "Não remunerado"))
        }

      # QUANTAS PESSOAS EMPREGAVA NESSE TRABALHO
      if ('V0649' %in% cols) {
        arrw <- mutate(arrw, V0649 = case_when(
          V0649 == '1' ~ "1 a 5 pessoas",
          V0649 == '2' ~ "6 ou mais pessoas"))
        }

      # ERA CONTRIBUINTE DE INSTITUTO DE PREVIDÊNCIA
      if ('V0650' %in% cols) {
        arrw <- mutate(arrw, V0650 = case_when(
          V0650 == '1' ~ "Sim, no trabalho principal",
          V0650 == '2' ~ "Sim, em outro trabalho",
          V0650 == '3' ~ "Não"))
        }

      # V0651
      # V0652

      # EM QUE MUNICÍPIO E UNIDADE DA FEDERAÇÃO OU PAÍS ESTRANGEIRO TRABALHA:
      if ('V0660' %in% cols) {
        arrw <- mutate(arrw, V0660 = case_when(
          V0660 == '1' ~ "No próprio domicílio",
          V0660 == '2' ~ "Apenas neste município, mas não no próprio domicílio",
          V0660 == '3' ~ "Em outro município",
          V0660 == '4' ~ "Em país estrangeiro",
          V0660 == '5' ~ "Em mais de um município ou país"))
        }

      # V6602 em que municipio trbalhava
      # V6604 em que uf trbalhava
      # V6606 em que pais trbalhava

      # QUAL É O TEMPO HABITUAL GASTO DE DESLOCAMENTO DE SUA CASA ATÉ O TRABALHO
      if ('V0662' %in% cols) {
        arrw <- mutate(arrw, V0662 = case_when(
          V0662 == '1' ~ "Até 05 minutos",
          V0662 == '2' ~ "De 06 minutos até meia hora",
          V0662 == '3' ~ "Mais de meia hora até uma hora",
          V0662 == '4' ~ "Mais de uma hora até duas horas",
          V0662 == '5' ~ "Mais de duas horas"))
        }

      ## fertility block
        # V0663
        # V0664
        # V0665
        # V0667
        # V0668
        # V0669

      # ASSINALE QUEM PRESTOU AS INFORMAÇÕES DESTA PESSOA
      if ('V0670' %in% cols) {
        arrw <- mutate(arrw, V0670 = case_when(
          V0670 == '1' ~ "A própria pessoa",
          V0670 == '2' ~ "Outro morador",
          V0670 == '3' ~ "Não morador"))
        }

      # CONDIÇÃO DE OCUPAÇÃO NA SEMANA DE REFERÊNCIA
      if ('V6910' %in% cols) {
        arrw <- mutate(arrw, V6910 = case_when(
          V6910 == '1' ~ "Ocupadas",
          V6910 == '2' ~ "Desocupadas"))
        }

      # SITUAÇÃO DE OCUPAÇÃO NA SEMANA DE REFERÊNCIA
      if ('V6920' %in% cols) {
        arrw <- mutate(arrw, V6920 = case_when(
          V6920 == '1' ~ "Ocupadas",
          V6920 == '2' ~ "Desocupadas"))
      }

      # POSIÇÃO NA OCUPAÇÃO E CATEGORIA DO EMPREGO NO TRABALHO PRINCIPAL
      if ('V6930' %in% cols) {
        arrw <- mutate(arrw, V6930 = case_when(
          V6930 == '1' ~ "Empregados com carteira de trabalho assinada",
          V6930 == '2' ~ "Militares e funcionários públicos estatutários",
          V6930 == '3' ~ "Empregados sem carteira de trabalho assinada",
          V6930 == '4' ~ "Conta própria",
          V6930 == '5' ~ "Empregadores",
          V6930 == '6' ~ "Não remunerados",
          V6930 == '7' ~ "Trabalhadores na produção para o próprio consumo"))
        }

      # SUBGRUPO E CATEGORIA DO EMPREGO NO TRABALHO PRINCIPAL
      if ('V6940' %in% cols) {
        arrw <- mutate(arrw, V6940 = case_when(
          V6940 == '1' ~ "Trabalhadores domésticos com carteira de trabalho assinada",
          V6940 == '2' ~ "Trabalhadores domésticos sem carteira de trabalho assinada",
          V6940 == '3' ~ "Demais empregados com carteira de trabalho assinada",
          V6940 == '4' ~ "Militares e funcionários públicos estatutários",
          V6940 == '5' ~ "Demais empregados sem carteira de trabalho assinada"))
        }

      # V6121 religiao ou culto

      # TEM MÃE VIVA
      if ('V0604' %in% cols) {
        arrw <- mutate(arrw, V0604 = case_when(
          V0604 == '1' ~ "Sim e mora neste domicílio",
          V0604 == '2' ~ "Sim e mora em outro domicílio",
          V0604 == '3' ~ "Não",
          V0604 == '4' ~ "Não sabe"))
        }

      # V6462 ocupacao
      # V6472 atividade


      # TIPO DE UNIDADE DOMÉSTICA
      if ('V5030' %in% cols) {
        arrw <- mutate(arrw, V5030 = case_when(
          V5030 == '1' ~ "Unipessoal",
          V5030 == '2' ~ "Duas pessoas ou mais sem parentesco",
          V5030 == '3' ~ "Duas pessoas ou mais com parentesco"))
        }

      ## family block
      # V5040
      # V5090
      # V5100


      ### Yes (1) or No (2) columns
      vars_sim_nao <- c('V0617', 'V0627', 'V0632', 'V0634', 'V0641', 'V0642',
                        'V0643', 'V0644', 'V0654', 'V0655', 'V0661', 'V6664',

                        # 1 (yes), (0) no, (9) ignored
                        'V0656', 'V0657', 'V0658', 'V0659')

      # mutate only colnames present
      vars_sim_nao_present <- vars_sim_nao[vars_sim_nao %in% cols]
      arrw <- dplyr::mutate(arrw, dplyr::across(all_of(vars_sim_nao_present),
                                                ~ if_else(.x == '1', 'Sim', 'N\u00e3o')
                                                ))

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

    }

  # YEAR 2000----------------------------------------------------------------

  # to be done.....

  return(arrw)
}
