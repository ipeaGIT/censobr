# devtools::install_github("ipeaGIT/r5r", subdir = "r-package", force=T)
library(censobr)
library(dplyr)

### add labels

df <- read_deaths()

ds2 <- df |> mutate(V0001 = case_when(
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

ds2 <- ds2 |> collect()
head(ds2)



add_labels_households <- function(columns=NULL, arrw){

  cols <- names(arrw)

  if ('V0001' %in% cols) {
    arrw <- arrw |> mutate(name_state = case_when(
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
    }

  return(arrw)
}

a <- 'C:/Users/user/AppData/Roaming/R/data/R/censobr_v0.1.0/2010_households.parquet'
b <- open_dataset(a)
c <- read_parquet(a, as_data_frame = F)

df <- d |> collect()

d |>
  filter(V0001 ==11)

##### Coverage ------------------------
# usethis::use_coverage()
# usethis::use_github_action("test-coverage")

library(censobr)
library(testthat)
library(covr)
Sys.setenv(NOT_CRAN = "true")


# each function separately
t1 <- covr::function_coverage(fun=read_deaths, test_file("tests/testthat/test_read_deaths.R"))
t1

# nocov start

# nocov end

# the whole package
Sys.setenv(NOT_CRAN = "true")
cov <- covr::package_coverage(path = ".", type = "tests", clean = FALSE)
cov

rep <- covr::report()

x <- as.data.frame(cov)
covr::codecov( coverage = cov, token ='aaaaa' )


# checks spelling ----------------
library(spelling)
devtools::spell_check(pkg = ".", vignettes = TRUE, use_wordlist = TRUE)


### Check URL's ----------------

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




###
library(pkgdown)
library(usethis)
# usethis::use_pkgdown_github_pages() # only once
## coverage
usethis::use_coverage()
usethis::use_github_action("test-coverage")

pkgdown::build_site()
#
#
# ### cache
# tigris
# https://github.com/walkerke/tigris/blob/0f0d7992e0208b4c55a9fe8ac6c52f9e438a3b0c/R/helpers.R#L78
#
# https://github.com/walkerke/tigris/blob/0f0d7992e0208b4c55a9fe8ac6c52f9e438a3b0c/R/helpers.R#L78
#
# tidycensus
# https://github.com/walkerke/tidycensus/blob/master/R/search_variables.R


