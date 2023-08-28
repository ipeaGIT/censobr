context("read_families")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()


# Reading the data -----------------------

test_that("read_families", {

  # (default) arrow table
  test1 <- read_families()
  testthat::expect_true(is(test1, "ArrowObject"))
  testthat::expect_true(is(test1, "FileSystemDataset"))
  testthat::expect_true(nrow(test1) >0 )

  # # data.frame
  # test2 <- read_families(as_data_frame = TRUE)
  # testthat::expect_true(is(test2, "data.frame"))

  # select columns
  cols <- c('V0102')
  test3 <- read_families(columns = cols)
  testthat::expect_true(names(test3) %in% cols)

})


# ERRORS and messages  -----------------------
test_that("read_families", {

  # Wrong date 4 digits
  testthat::expect_error(read_families(year=999))
  testthat::expect_error(read_families(year='999'))
  testthat::expect_error(read_families(columns = 'banana'))
  testthat::expect_error(read_families(as_data_frame = 'banana'))
  testthat::expect_error(read_families(showProgress = 'banana' ))
  testthat::expect_error(read_families(cache = 'banana'))


})
