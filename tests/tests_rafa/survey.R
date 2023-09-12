# https://djalmapessoa.github.io/adac/


library(censobr)
library(survey)
library(srvyr)
# https://cran.r-project.org/web/packages/srvyr/vignettes/srvyr-vs-survey.html

library(censobr)
library(dplyr)
library(tictoc)

df <- read_population(year = 2010) |> filter(name_region  == "Norte")

df2 <- as.data.frame(df)


srs_design_srvyr <- df2 %>% as_survey_design(ids = 1, fpc = V0010)

srs_design_survey <- svydesign(ids = ~1, fpc = ~fpc, data = apisrs)



tic()
censo_designD <-
  survey::svrepdesign(
    weight = ~ V0010 ,
    repweights = ~ V0010 ,
   # type = "bootstrap",
    combined.weights = FALSE ,
  #  scale = censo_wgts$scale ,
  #  rscales = v0010 ,
    data = df2
  )
toc()

tic()
censo_designP <-
  survey::svrepdesign(
    weight = ~ V0010 ,
    repweights = ~ V0010 ,
    # type = "bootstrap",
    combined.weights = FALSE ,
    #  scale = censo_wgts$scale ,
    #  rscales = v0010 ,
    data = df
  )
toc()


arrow::write_parquet(df, 'pop.parquet')

saveRDS(censo_designD, 'pop.rds', compress = T)

saveRDS(censo_designD, 'censo_designD.rds', compress = T)
saveRDS(censo_designP, 'censo_designP.rds', compress = T)

svymean( ~ V6033 , censo_designD )
svymean( ~ V6033 , censo_designP )
svymean( ~ V6033 , censo_designP2 )


censo_designD |> summarise(srvyr::survey_mean(x = V6033))

censo_designP2$variables <- df2
svymean( ~ V6033 , censo_designP2 )

#' velocidade de OPERACOES
#' operacoes de design sao MUITO mais rapidas quando design construido com df


#' espaço em disco
#' df e design ocupam mesmo espaço em RDS
#' deisgn parquet é quase 10x menor que data parquet
#'
#' espaço em ram
#' design parquet é apenas 4% to tamando do design df
#'
#'

censo_designD$variables
censo_designP2 <- censo_designP
censo_designP2$variables <- NULL

saveRDS(censo_designP2, 'censo_designP2_novar.rds', compress = T)
