library(qpdf)


# manuals 2022 ------------------------------

input_manual <- c(
  './data_prep/data_raw/interview_manual/2022/Manual_de_Entrevista_CD_1.04_v_05.22.pdf',
  './data_prep/data_raw/interview_manual/2022/Manual_Recenseador_CD_1_09.pdf',
  './data_prep/data_raw/interview_manual/2022/MR_CD_1.09_ERRATA_v7_07_22.pdf',
  './data_prep/data_raw/interview_manual/2022/CD_1_18_Manual_Recenseador_PCT_ebook.pdf',
  './data_prep/data_raw/interview_manual/2022/CD_1_19_Guia_de_abordagem_ebook.pdf'
  )

qpdf::pdf_combine(input = input_manual,
                  output = './data_prep/data_raw/interview_manual/2022_interview_manual.pdf')

# questionnaires 2022 ------------------------------

# universe
input_quest_uni <- c(
  './data_prep/data_raw/questionnaire/2022/questionario_basico_completo_CD2022_atualizado_20220906.pdf',
  './data_prep/data_raw/questionnaire/2022/questionario_pesquisa_urbanistica_do_entorno_dos_domicilios.pdf'
    )

qpdf::pdf_combine(input = input_quest_uni,
                  output = './data_prep/data_raw/questionnaire/2022_questionnaire_universe.pdf')

# sample
input_quest_sample <- c(
  './data_prep/data_raw/questionnaire/2022/questionario_amostra_completo_CD2022_atualizado_20220906.pdf',
  './data_prep/data_raw/questionnaire/2022/questionario_abordagem_indigena.pdf'
  )

qpdf::pdf_combine(input = input_quest_sample,
                  output = './data_prep/data_raw/questionnaire/2022_questionnaire_sample.pdf')




