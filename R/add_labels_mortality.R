# Add labels to categorical variables of mortality datasets
#' @keywords internal
add_labels_mortality <- function(arrw,
                                 year = parent.frame()$year,
                                 lang = 'pt'){

  # check input
  checkmate::assert_string(lang, pattern = 'pt', na.ok = TRUE)
  if (!(year %in% c(2010))) {stop('Labels for this data are only available for the year c(2010)')}

  # names of columns present in the data
  cols <- names(arrw)

  ### YEAR 2010
  if(year == 2010 & lang == 'pt'){
    # urban vs rural
    if ('V1006' %in% cols) {
      arrw <- arrw |> mutate(V1006 = case_when(
        V1006 == '1' ~'Urbana',
        V1006 == '2' ~'Rural'))
    }

    # sex of deceased person
    if ('V0704' %in% cols) {
      arrw <- arrw |> mutate(V0704 = case_when(
        V0704 == '1' ~ 'Masculino',
        V0704 == '2' ~ 'Feminino',
        V0704==  '9' ~ 'Ignorado'))
    }

    # month and year of death
    if ('V0703' %in% cols) {
      arrw <- arrw |> mutate(V0703 = case_when(
        V0703 == '01' ~ 'Agosto de 2009',
        V0703 == '02' ~ 'Setembro de 2009',
        V0703 == '03' ~ 'Outubro de 2009',
        V0703 == '04' ~ 'Novembro de 2009',
        V0703 == '05' ~ 'Dezembro de 2009',
        V0703 == '06' ~ 'Janeiro de 2010',
        V0703 == '07' ~ 'Fevereiro de 2010',
        V0703 == '08' ~ 'Mar\u00e7o de 2010',
        V0703 == '09' ~ 'Abril de 2010',
        V0703 == '10' ~ 'Maio de 2010',
        V0703 == '11' ~ 'Junho de 2010',
        V0703 == '12' ~ 'Julho de 2010',
        V0703 == '99' ~ 'Ignorado'))
      }

    # census tract type
    if ('V1005' %in% cols) {
      arrw <- arrw |> mutate(V1005 = case_when(
        V1005 == '1' ~ paste0('\u00c1rea urbanizada'),
        V1005 == '2' ~ paste0('\u00c1rea n\u00e3o urbanizada'),
        V1005 == '3' ~ paste0('\u00c1rea urbanizada isolada'),
        V1005 == '4' ~ paste0('\u00c1rea rural de extens\u00e3o urbana'),
        V1005 == '5' ~ 'Aglomerado rural (povoado)',
        V1005 == '6' ~ paste0('Aglomerado rural (n\u00facleo)'),
        V1005 == '7' ~ 'Aglomerado rural (outros)',
        V1005 == '8' ~ paste0('\u00c1rea rural exclusive aglomerado rural')))
    }
  }

  return(arrw)
}
