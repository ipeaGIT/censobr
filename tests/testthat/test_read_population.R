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
  rm(test1); gc(TRUE)
  gc(TRUE)

  # # data.frame
  # test2 <- read_population(as_data_frame = TRUE)
  # testthat::expect_true(is(test2, "data.frame"))

  # # select columns
  # cols <- c('V0001')
  # test2 <- censobr::read_population(columns = cols, as_data_frame = FALSE)
  # test2 <- test2[1:2,] |> dplyr::collect()
  # testthat::expect_true(names(test2) %in% cols)





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
