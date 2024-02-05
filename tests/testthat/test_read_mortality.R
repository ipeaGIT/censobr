context("read_mortality")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()


# Reading the data -----------------------

test_that("read_mortality", {

  # (default) arrow table
  test1 <- read_mortality()
  testthat::expect_true(is(test1, "ArrowObject"))
  testthat::expect_true(is(test1, "FileSystemDataset"))
  testthat::expect_true(nrow(test1) >0 )

  # data.frame
  test2 <- read_mortality(as_data_frame = TRUE)
  testthat::expect_true(is(test2, "data.frame"))

  # select columns
  cols <- c('V0001')
  test3 <- read_mortality(columns = cols)
  testthat::expect_true(names(test3) %in% cols)

  # add labels
  test4 <- read_mortality(add_labels = 'pt', columns = c('abbrev_state', 'V1005'))
  test4 <- test4 |> filter(abbrev_state == 'CE') |> as.data.frame()
  testthat::expect_true(paste('\u00c1rea urbanizada') %in% test4$V1005)


  # # merge households
  # df_main <- read_mortality(year = 2010, merge_households = FALSE)
  # df_hous <- read_mortality(year = 2010, merge_households = TRUE)
  #
  # nrow(df_main) == nrow(df_hous)




  # check whether cache argument is working
  time_first <- system.time(
    t1 <- read_mortality(year = 2010))

  time_cache_true <- system.time(
    t2 <- read_mortality(year = 2010, cache = TRUE))

  time_cache_false <- system.time(
    t3 <- read_mortality(year = 2010, cache = FALSE))

  testthat::expect_true( time_cache_true[['elapsed']] < time_cache_false[['elapsed']] )

 })


# ERRORS and messages  -----------------------
test_that("read_mortality", {

  # Wrong date 4 digits
  testthat::expect_error(read_mortality(year=999))
  testthat::expect_error(read_mortality(year='999'))
  testthat::expect_error(read_mortality(columns = 'banana'))
  testthat::expect_error(read_mortality(as_data_frame = 'banana'))
  testthat::expect_error(read_mortality(showProgress = 'banana' ))
  testthat::expect_error(read_mortality(cache = 'banana'))
  testthat::expect_error(read_mortality(add_labels = 'banana'))

  # missing labels
  testthat::expect_error(read_mortality(year=2000, add_labels = 'pt'))

})

# # clean cache
# censobr_cache(delete_file = 'all')
