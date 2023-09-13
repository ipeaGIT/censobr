context("read_households")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()


# Reading the data -----------------------

test_that("read_households", {

  # (default) arrow table
  test1 <- read_households()
  testthat::expect_true(is(test1, "ArrowObject"))
  testthat::expect_true(is(test1, "FileSystemDataset"))
  testthat::expect_true(nrow(test1) >0 )

  # year 2000
  # (default) arrow table
  test2 <- read_households(year = 2000)
  testthat::expect_true(is(test2, "ArrowObject"))
  testthat::expect_true(is(test2, "FileSystemDataset"))
  testthat::expect_true(nrow(test2) >0 )

  # # data.frame
  # test2 <- read_households(as_data_frame = TRUE)
  # testthat::expect_true(is(test2, "data.frame"))

  # select columns
  cols <- c('V0001')
  test3 <- read_households(columns = cols)
  testthat::expect_true(names(test3) %in% cols)

  # add labels
  test4 <- read_households(year=2010, add_labels = 'pt', columns = c('abbrev_state', 'V1005'))
  test4 <- test4 |> filter(abbrev_state == 'CE') |> as.data.frame()
  testthat::expect_true(paste('\u00c1rea urbanizada') %in% test4$V1005)

  test5 <- read_households(year=2000, add_labels = 'pt', columns = c('abbrev_state', 'V1005'))
  test5 <- test5 |> filter(abbrev_state == 'CE') |> as.data.frame()
  testthat::expect_true(paste('\u00c1rea urbanizada de vila ou cidade') %in% test5$V1005)

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
  testthat::expect_error(read_households(add_labels = 'banana'))

  # missing labels


})

# # clean cache
# censobr_cache(delete_file = 'all')
