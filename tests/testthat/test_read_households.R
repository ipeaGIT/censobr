context("read_households")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()


# Reading the data -----------------------

test_that("read_households", {

  # (default)
  test1 <- read_households()
  testthat::expect_true(is(test1, "data.frame"))
  testthat::expect_true(nrow(test1) >0 )
  testthat::expect_equal( class(test1$V0010), 'numeric')

  # select columns
  cols <- c('V0002')
  test2 <- read_households(columns = cols)
  testthat::expect_true(names(test2) %in% cols)

  # arrow table
  test3 <- read_households(as_data_frame = FALSE)
  testthat::expect_true(is(test3, "ArrowTabular"))

  # check whether cache argument is working
  time_first <- system.time(
    t1 <- read_households(year = 2010, as_data_frame = FALSE))

  time_cache_true <- system.time(
    t2 <- read_households(year = 2010, as_data_frame = FALSE, cache = TRUE))

  time_cache_false <- system.time(
    t3 <- read_households(year = 2010, as_data_frame = FALSE, cache = FALSE))

  testthat::expect_true( time_cache_true[['elapsed']] < time_cache_false[['elapsed']] )

 })


# ERRORS and messages  -----------------------
test_that("read_households", {

  # Wrong date 4 digits
  testthat::expect_error(read_households(year=999))
  testthat::expect_error(read_households(year='999'))
  testthat::expect_error(read_households(columns = 'banana'))
  testthat::expect_error(read_households(as_data_frame = 'banana'))
  testthat::expect_error(read_households(showProgress = 'banana' ))
  testthat::expect_error(read_households(cache = 'banana'))


})
