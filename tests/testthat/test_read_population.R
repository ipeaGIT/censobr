context("read_population")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()


# Reading the data -----------------------

test_that("read_population", {


  # (default) arrow table
  test1 <- read_population()
  testthat::expect_true(is(test1, "ArrowTabular"))
  testthat::expect_true(nrow(test1) >0 )

  # # data.frame
  # test2 <- read_population(as_data_frame = TRUE)
  # testthat::expect_true(is(test2, "data.frame"))

  # select columns
  cols <- c('V0001')
  test3 <- read_population(columns = cols)
  testthat::expect_true(names(test3) %in% cols)

  # check whether cache argument is working
  time_first <- system.time(
    t1 <- read_population(year = 2010))

  time_cache_true <- system.time(
    t2 <- read_population(year = 2010, cache = TRUE))

  time_cache_false <- system.time(
    t3 <- read_population(year = 2010, cache = FALSE))

  testthat::expect_true( time_cache_true[['elapsed']] < time_cache_false[['elapsed']] )

 })


# ERRORS and messages  -----------------------
test_that("read_population", {

  # Wrong date 4 digits
  testthat::expect_error(read_population(year=999))
  testthat::expect_error(read_population(year='999'))
  testthat::expect_error(read_population(columns = 'banana'))
  testthat::expect_error(read_population(as_data_frame = 'banana'))
  testthat::expect_error(read_population(showProgress = 'banana' ))
  testthat::expect_error(read_population(cache = 'banana'))


})