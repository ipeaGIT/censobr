# devtools::install_github("ipeaGIT/r5r", subdir = "r-package", force=T)
library(flightsbr)

a <- read_aircrafts()

https://www.anac.gov.br/dadosabertos/estatistica/tarifasaereas

dput(classes)

head(dt$HH_CALCO)

registro aeronautico
aircrafts
https://www.gov.br/anac/pt-br/assuntos/regulados/aeronaves

aeronaves
https://dados.gov.br/dataset/aeronaves-registradas-no-registro-aeronautico-brasileiro-rab/resource/19dfbc2d-abb5-4565-b0b8-763cf6437b43

operacoes
https://dados.gov.br/dataset/aeronaves-registradas-no-registro-aeronautico-brasileiro-rab




##### tarifas aereas  ------------------------
https://www.gov.br/anac/pt-br/pt-br/assuntos/dados-e-estatisticas/mercado-do-transporte-aereo

domesticas
https://www.gov.br/anac/pt-br/assuntos/regulados/empresas-aereas/envio-de-informacoes/relatorio-de-tarifas-aereas-domesticas

internacionais
https://www.gov.br/anac/pt-br/assuntos/regulados/empresas-aereas/envio-de-informacoes/tarifas-aereas-internacionais-1

microdads
https://sistemas.anac.gov.br/sas/tarifainternacional/

microdados
https://sistemas.anac.gov.br/sas/downloads/

library(flightsbr)

a <- read_airfares(date = 2011, domestic=F)
head(a)

b <- read_airfares(date = 2020, domestic=F)
head(b)
table(b$`Mês de Referência`)

c <- read_airfares(date = 2018, domestic=F)
head(c)
table(b$`Mês de Referência`)

##### ASCII characters  ------------------------



# I find ?stringi::stri_escape_unicode to be extremely useful for generating \uxxxx escapes, for example:

# stringi::stri_escape_unicode("°") |> cat("\n")
\u00b0

# stringi::stri_escape_unicode("Â") |> cat("\n")


Which can be reversed (for checking) using:

# stringi::stri_unescape_unicode("\u00b0") |> cat("\n")
# °
# stringi::stri_unescape_unicode("\ub0") |> cat("\n")


This also works with non-ASCII characters embedded in longer sentences:

  # > stringi::stri_escape_unicode("Åv — mærkelige tegn!") |> cat("\n")
\u00c5v \u2014 m\u00e6rkelige tegn!

  # > stringi::stri_unescape_unicode("\u00c5v \u2014 m\u00e6rkelige tegn!") |> cat("\n")
Åv — mærkelige tegn!

  Big thanks to the authors of the stringi package if they are reading this!


##### Coverage ------------------------
# usethis::use_coverage()
# usethis::use_github_action("test-coverage")

library(flightsbr)
library(testthat)
library(covr)
Sys.setenv(NOT_CRAN = "true")


# each function separately
t1 <- covr::function_coverage(fun=read_aircrafts, test_file("tests/testthat/test_read_aircrafts.R"))
t2 <- covr::function_coverage(fun=read_airports, test_file("tests/testthat/test_read_airports.R"))
t3 <- covr::function_coverage(fun=read_flights, test_file("tests/testthat/test_read_flights.R"))
t4 <- covr::function_coverage(fun=read_airport_movements, test_file("tests/testthat/test_read_airport_movements.R"))
t5 <- covr::function_coverage(fun=check_date, test_file("tests/testthat/test_check_date.R"))
t6 <- covr::function_coverage(fun=get_flight_dates_available, test_file("tests/testthat/test_get_flight_dates_available.R"))
t7 <- covr::function_coverage(fun=get_airport_movement_dates_available, test_file("tests/testthat/test_get_airport_movement_dates_available.R"))
t8 <- covr::function_coverage(fun=latest_flights_date, test_file("tests/testthat/test_latest_flights_date.R"))

t1
t2
t3
t4
t5
t6
t7
t8



# nocov start

# nocov end

# the whole package
Sys.setenv(NOT_CRAN = "true")
cov <- covr::package_coverage(path = ".", type = "tests", clean = FALSE)
cov

rep <- covr::report()

x <- as.data.frame(cov)
covr::codecov( coverage = cov, token ='aaaaa' )


#####  ftp dirs and files ------------------------

library(RCurl)

url <- "ftp://geoftp.ibge.gov.br/organizacao_do_territorio/estrutura_territorial/evolucao_da_divisao_territorial_do_brasil/evolucao_da_divisao_territorial_do_brasil_1872_2010/municipios_1872_1991/divisao_territorial_1872_1991/"

url <- 'https://www.gov.br/anac/pt-br/assuntos/regulados/empresas-aereas/envio-de-informacoes/microdados/basica2020-01.zip'
url <- 'https://www.gov.br/anac/pt-br/assuntos/regulados/empresas-aereas/envio-de-informacoes/microdados/'


## Retrieve from ANAC website all dates available
# read html table
url <- 'https://www.gov.br/anac/pt-br/assuntos/regulados/empresas-aereas/envio-de-informacoes/microdados/'
h <- rvest::read_html(url)
elements <- rvest::html_elements(h, "a")

# filter elements of basica data
basica_urls <- elements[elements %like% '/basica']
basica_urls <- lapply(X=basica_urls, FUN=function(i){rvest::html_attr(i,"href")})

# get dates
all_dates <- substr(basica_urls, (nchar(basica_urls) + 1) -11, nchar(basica_urls)-4 )
all_dates <- gsub("[-]", "", all_dates)



##### Profiling function ------------------------
# p <-   profvis( update_newstoptimes("T2-1@1#2146") )
#
# p <-   profvis( b <- corefun("T2-1") )





# checks spelling
library(spelling)
devtools::spell_check(pkg = ".", vignettes = TRUE, use_wordlist = TRUE)

# Update documentation
# devtools::document(pkg = ".")


# Write package manual.pdf
system("R CMD Rd2pdf --title=Package gtfs2gps --output=./gtfs2gps/manual.pdf")
# system("R CMD Rd2pdf gtfs2gps")


# checks spelling
library(spelling)
devtools::spell_check(pkg = ".", vignettes = TRUE, use_wordlist = TRUE)


### Check URL's----------------

urlchecker::url_update()


### CMD Check ----------------
# Check package errors

# LOCAL
Sys.setenv(NOT_CRAN = "true")
devtools::check(pkg = ".",  cran = FALSE, env_vars = c(NOT_CRAN = "true"))

# CRAN
Sys.setenv(NOT_CRAN = "false")
devtools::check(pkg = ".",  cran = TRUE, env_vars = c(NOT_CRAN = "false"))



# quick no vignettes
devtools::check(pkg = ".",  cran = TRUE, env_vars = c(NOT_CRAN = "false"),vignettes = F)

devtools::check_win_release(pkg = ".")

# devtools::check_win_oldrelease()
# devtools::check_win_devel()


beepr::beep()



tictoc::tic()
devtools::check(pkg = ".",  cran = TRUE, env_vars = c(NOT_CRAN = "false"))
tictoc::toc()


# submit to CRAN -----------------
usethis::use_cran_comments('teste 2222, , asdadsad')


devtools::submit_cran()


# build binary -----------------
system("R CMD build . --resave-data") # build tar.gz



library(geobr)
library(igraph)
library(ggforce)
library(flightsbr)
library(edgebundle)
# https://github.com/schochastics/edgebundle
library(ggplot2)
library(janitor)

# https://mwallinger-tu.github.io/edge-path-bundling/

options(scipen = 999)
# download data -----------------
br <- read_country()

airports <- read_airports(type = 'all')
flights <- read_flights(date = 201901)

# clean names
airports <- janitor::clean_names(airports)
flights <- janitor::clean_names(flights)


# filter -----------------
head(flights$id_aerodromo_origem)
head(flights$sg_icao_destino)
head(flights$sg_iata_destino)

flights2 <- subset(flights, sg_icao_origem %in% airports$codigo_oaci)
flights2 <- subset(flights2, sg_icao_destino %in% airports$codigo_oaci)



edges <- flights2[, .(sg_icao_origem, sg_icao_destino, 'n_passengers'=nr_passag_pagos)]

# summary flows -----------------
edges <- flights2[, .(n_flights = .N,
             n_passengers = sum(nr_passag_pagos)),
         by = .(sg_icao_origem, sg_icao_destino)]

head(edges)
# add spatial coordinates -----------------
edges[ airports, on=c('sg_icao_origem'='codigo_oaci'),
    c('lat_orig', 'lon_orig') := list(i.latitude , i.longitude)
    ]

edges[ airports, on=c('sg_icao_destino'='codigo_oaci'),
    c('lat_dest', 'lon_dest') := list(i.latitude , i.longitude)
    ]

head(edges)
edges <- subset(edges, sg_icao_origem != '')
edges <- subset(edges, sg_icao_destino  != '')
edges <- na.omit(edges)

### build network -----------------
vert <- airports[,.(codigo_oaci, longitude, latitude)]
vert <- subset(vert, codigo_oaci != '')
vert <- unique(vert)


g <- igraph::graph_from_data_frame(d = edges,
                                   directed = T,
                                   vertices = vert)



xy <- cbind(V(g)$longitude, V(g)$latitude)



# Force Directed Edge Bundling
fbundle <- edge_bundle_force(g, xy, compatibility_threshold = 0.001, P=10)
beepr::beep()
# ! sbundle <- edge_bundle_stub(g, xy)
# ! hbundle <- edge_bundle_hammer(g, xy, bw = 0.7, decay = 0.5)

#f <-
  ggplot() +
  geom_sf(data=br , fill='gray10', color=NA) +
  geom_path(data = fbundle, aes(x, y, group = group),
            col = "#9d0191", size = 0.05, alpha=.5) +
  geom_path(data = fbundle, aes(x, y, group = group),
            col = "white", size = 0.005, alpha=.5) +
  theme_classic() +
  theme(axis.line=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        axis.title=element_blank())


ggsave(f, file='f.png')
beepr::beep()


# Edge-Path Bundling
pbundle <- edge_bundle_path(g, xy,
                            max_distortion = 12,
                            weight_fac = 2, # E(g)$n_passengers,
                            segments = 50)
p <-
  ggplot() +
        geom_sf(data=br , fill='gray10', color=NA) +
        geom_path(data = pbundle, aes(x, y, group = group),
                  col = "#9d0191", size = 0.05, alpha=.1) +
        geom_path(data = pbundle, aes(x, y, group = group),
                  col = "white", size = 0.005, alpha=.1) +
        theme_classic() +
        theme(axis.line=element_blank(),
              axis.text=element_blank(),
              axis.ticks=element_blank(),
              axis.title=element_blank())



ggsave(p, file='pall_2_501.png')
beepr::beep()






