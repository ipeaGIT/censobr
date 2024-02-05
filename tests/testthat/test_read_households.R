context("read_households")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()
testthat::skip_if_not_installed("arrow")


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

  # year 1991
  # (default) arrow table
  test2 <- read_households(year = 1991)
  testthat::expect_true(is(test2, "ArrowObject"))
  testthat::expect_true(is(test2, "FileSystemDataset"))
  testthat::expect_true(nrow(test2) >0 )

  # year 1980
  # (default) arrow table
  test2 <- read_households(year = 1980)
  testthat::expect_true(is(test2, "ArrowObject"))
  testthat::expect_true(is(test2, "FileSystemDataset"))
  testthat::expect_true(nrow(test2) >0 )

  # year 1970
  # (default) arrow table
  test2 <- read_households(year = 1970)
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
  test4 <- test4 |> dplyr::filter(abbrev_state == 'CE') |> as.data.frame()
  testthat::expect_true(paste('\u00c1rea urbanizada') %in% test4$V1005)

  test5 <- read_households(year=2000, add_labels = 'pt', columns = c('abbrev_state', 'V1005'))
  test5 <- test5 |> dplyr::filter(abbrev_state == 'CE') |> as.data.frame()
  testthat::expect_true(paste('\u00c1rea urbanizada de vila ou cidade') %in% test5$V1005)

})





# check totals -----------------------

test_that("read_households", {


  # 2010
  dfh <- read_households(year = 2010)
  total_2010_p <- summarise(dfh, total = sum(V0010)) |> collect()
  expect_equal(total_2010_p$total, 58051449)


  # 2000
  dfh <- read_households(year = 2000)
  total_2000_p <- summarise(dfh, total = sum(PESO_DOMIC, na.rm=T)) |> collect()
  expect_equal(total_2000_p$total, 45507516)


  # 1991
  dfh <- read_households(year = 1991)
  total_1991_p <- summarise(dfh, total = sum(V7300, na.rm=T)) |> collect()
  expect_equal(total_1991_p$total, 35435725)


  # 1980
  dfh <- read_households(year = 1980)
  total_1980_p <- summarise(dfh, total = sum(V603, na.rm=T)) |> collect()
  expect_equal(total_1980_p$total, 25210639)


  # 1970
  dfh <- read_households(year = 1970)
  total_1970_p <- summarise(dfh, total = sum(weight_household, na.rm=T)) |> collect()
  expect_equal(total_1970_p$total, 17682112)

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
