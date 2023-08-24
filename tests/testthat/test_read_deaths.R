context("read_deaths")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()


# Reading the data -----------------------

test_that("read_deaths", {

  # (default) arrow table
  test1 <- read_deaths()
  testthat::expect_true(is(test1, "ArrowTabular"))
  testthat::expect_true(nrow(test1) >0 )

  # data.frame
  test2 <- read_deaths(as_data_frame = TRUE)
  testthat::expect_true(is(test2, "data.frame"))

  # select columns
  cols <- c('V0001')
  test3 <- read_deaths(columns = cols)
  testthat::expect_true(names(test3) %in% cols)


  # check whether cache argument is working
  time_first <- system.time(
    t1 <- read_deaths(year = 2010))

  time_cache_true <- system.time(
    t2 <- read_deaths(year = 2010, cache = TRUE))

  time_cache_false <- system.time(
    t3 <- read_deaths(year = 2010, cache = FALSE))

  testthat::expect_true( time_cache_true[['elapsed']] < time_cache_false[['elapsed']] )

 })


# ERRORS and messages  -----------------------
test_that("read_deaths", {

  # Wrong date 4 digits
  testthat::expect_error(read_deaths(year=999))
  testthat::expect_error(read_deaths(year='999'))
  testthat::expect_error(read_deaths(columns = 'banana'))
  testthat::expect_error(read_deaths(as_data_frame = 'banana'))
  testthat::expect_error(read_deaths(showProgress = 'banana' ))
  testthat::expect_error(read_deaths(cache = 'banana'))


})
