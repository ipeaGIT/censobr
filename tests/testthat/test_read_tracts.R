context("read_tracts")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()
testthat::skip_if_not_installed("arrow")



tester <- function(year = 2010,
                   dataset = NULL,
                   as_data_frame = FALSE,
                   showProgress = FALSE,
                   cache = TRUE) {
  read_tracts(
    year,
    dataset,
    as_data_frame,
    showProgress,
    cache
  )
}


# Reading the data -----------------------

test_that("read_tracts", {

  # arrow table
  test1 <- tester(year = 2010, dataset = 'Basico')
  testthat::expect_true(is(test1, "ArrowObject"))
  testthat::expect_true(is(test1, "Table"))
  testthat::expect_true(nrow(test1) >0 )

  # data.frame
  test2 <- tester(year = 2010, dataset = 'Basico', as_data_frame = TRUE)
  testthat::expect_true(is(test2, "data.frame"))

  # 2010 different data sets
  ## check if file have been downloaded
  tbls <- c('Basico', 'Domicilio', 'DomicilioRenda', 'Entorno',
             'ResponsavelRenda', 'Responsavel', 'PessoaRenda', 'Pessoa')

  lapply(X=tbls, FUN = function(y){ # y = 'Pessoa'     y = 'Basico'  y = 'Entorno'
    tmp_d <- tester(year = 2010, dataset = y)
    testthat::expect_true( nrow(tmp_d) >= 303000)
  } )

  # 2022 different data sets
  ## check if file has been downloaded
  tbls <- c('Preliminares')
  lapply(X=tbls, FUN = function(y){ # y = 'Preliminares'
    tmp_d <- tester(year = 2022, dataset = y)
    testthat::expect_true( nrow(tmp_d) == 452340)
  } )


  # check whether cache argument is working
  time_first <- system.time(
    t1 <- tester(year = 2010, dataset = 'Basico'))

  time_cache_true <- system.time(
    t2 <- tester(year = 2010, dataset = 'Basico', cache = TRUE))

  time_cache_false <- system.time(
    t3 <- tester(year = 2010, dataset = 'Basico', cache = FALSE))

  testthat::expect_true( time_cache_true[['elapsed']] < time_cache_false[['elapsed']] )

 })


# ERRORS and messages  -----------------------
test_that("read_tracts", {

  # Wrong date 4 digits )
  testthat::expect_error(tester())
  testthat::expect_error(tester(year=999, dataset='Basico'))
  testthat::expect_error(tester(year=999, dataset='Basico'))
  testthat::expect_error(tester(year=2010, dataset='banana'))
  testthat::expect_error(tester(year=2022, dataset='banana'))

  testthat::expect_error(tester(year=2010, dataset='Basico', showProgress = 'banana' ))
  testthat::expect_error(tester(year=2010, dataset='Basico', cache = 'banana' ))
})

# # clean cache
# censobr_cache(delete_file = 'all')
