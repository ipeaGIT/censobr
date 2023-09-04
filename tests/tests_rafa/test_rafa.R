# devtools::install_github("ipeaGIT/r5r", subdir = "r-package", force=T)
library(censobr)
library(dplyr)
library(arrow)

### add labels


# mortality
df <- censobr::read_population(year = 2010) |>
  filter(abbrev_state == 'CE')

df2 <- add_labels_population(df, year=2010, lang = 'pt')
head(df2) |> collect()


# mortality
df <- censobr::read_households(year = 2010) |>
  filter(abbrev_state == 'CE')

df2 <- add_labels_households(df, year=2010, lang = 'pt')
head(df2) |> collect()


df <- censobr::read_households(year = 2000) |>
  filter(abbrev_state == 'CE')

df2 <- add_labels_households(df, year=2000, lang = 'pt')
head(df2) |> collect()

# mortality
df <- censobr::read_deaths(year = 2010) |>
  filter(abbrev_state == 'CE')

df2 <- add_labels_mortality(df, year=2010, lang = 'pt')
head(df2) |> collect()



# families
df <- censobr::read_families(year = 2000) |>
  filter(abbrev_state == 'CE')

df2 <- add_labels_families(df, year=2000, lang = 'pt')
head(df2) |> collect()


### 666 --------------------------- se reclamaredm do defaul T







##### Coverage ------------------------
# usethis::use_coverage()
# usethis::use_github_action("test-coverage")

library(censobr)
library(testthat)
library(covr)
Sys.setenv(NOT_CRAN = "true")


# each function separately
t1 <- covr::function_coverage(fun=read_deaths, test_file("tests/testthat/test_read_deaths.R"))
t1 <- covr::function_coverage(fun=censobr_cache, test_file("tests/testthat/test_censobr_cache.R"))
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


# download firt time
message data being cached locally at

if (!file.exists(file)) {
  cache_mssg(file)



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
usethis::use_cran_comments()


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



library(geobr)
library(censobr)
library(dplyr)
library(ggplot2)

fort_df <- geobr::lookup_muni(name_muni = 'Sao Paulo')
fort_code <- fort_df$code_muni
fort_wa <- read_weighting_area(code_weighting = fort_code,
                               year = 2010,
                               simplified = FALSE)



ggplot() +
  geom_sf(data=fort_wa)


# download household data
hs <- read_households(year = 2010,
                      showProgress = FALSE)


rent <- hs |>
  mutate( V0011 = as.character(V0011)) |>
  filter(V0011 %in% fort_wa$code_weighting) |>
  collect() |>
  group_by(V0011) |>                                                 # (a)
  summarize(avgrent=weighted.mean(x=V2011, w=V0010, na.rm=TRUE)) |>  # (b)
  collect()                                                          # (c)

head(rent)


for_sf <- left_join(fort_wa, rent, by = c('code_weighting'='V0011'))


ggplot() +
  geom_sf(data=for_sf, aes(fill = avgrent), color=NA)

