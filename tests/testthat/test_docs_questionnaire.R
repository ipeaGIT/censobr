context("questionnaire")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()


# Reading the data -----------------------

test_that("questionnaire", {

  # download files
  testthat::expect_message( questionnaire(year = 2010, type = 'sample') )
  testthat::expect_message( questionnaire(year = 2000, type = 'sample') )
  testthat::expect_message( questionnaire(year = 1991, type = 'sample') )
  testthat::expect_message( questionnaire(year = 1980, type = 'sample') )
  testthat::expect_message( questionnaire(year = 1970, type = 'sample') )

  # cache dir
  pkgv <- paste0('censobr/data_release_', data_release)
  cache_dir <- tools::R_user_dir(pkgv, which = 'cache')

  ## check if file have been downloaded
  years <- c(1970, 1980, 1991, 2000, 2010)

  lapply(X=years, FUN = function(y){
    f_address <- paste0(cache_dir,'/',y, '_questionnaire_sample.pdf')
    testthat::expect_true(file.exists(f_address))
    } )

 })


# ERRORS and messages  -----------------------
test_that("questionnaire", {

  # Wrong date 4 digits
  testthat::expect_error(questionnaire(year = 9999))
  testthat::expect_error(questionnaire(year = 2000, showProgress = 'banana'))
  testthat::expect_error(questionnaire(year = 2000, cache = 'banana'))
  testthat::expect_error(questionnaire(year = 2000, type = 'banana'))
})

