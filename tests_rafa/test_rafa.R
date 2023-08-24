# devtools::install_github("ipeaGIT/r5r", subdir = "r-package", force=T)
library(censobr)


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




### Check URL's----------------

urlchecker::url_update()


df <- read_deaths(
  year,                 # year of reference
  columns,              # whether to return only selected columns
  as_data_frame,        # whether to return an Arrow table or a data.frame
  showProgress,         # whether to show a download progress bar
  cache                 # whether to cahce data suring R session
)

df |> group_by(V0001) |>
  summarize(mean_rent = weighted.mean(x=V2011, w=V0010, na.rm = TRUE))



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
pkgdown::build_site()


