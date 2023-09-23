context("set_censobr_cache_dir")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()


# Reading the data -----------------------

test_that("set_censobr_cache_dir", {

  # default
  testthat::expect_message( set_censobr_cache_dir() )

  # Set custom cache directory
  tempd <- tempdir()
  testthat::expect_message( set_censobr_cache_dir(path = tempd) )

  # download
  t <- read_emigration(year = 2010)

  # check if file exists in custom dir
  files <- list.files(tempd, full.names = TRUE)
  fname <- paste0('2010_emigration_',data_release, '.parquet')
  fname_full <- files[grepl(fname, files)]
  testthat::expect_true( file.exists(fname_full) )

  # back to default path
  set_censobr_cache_dir(path = NULL)
 })


# ERRORS and messages  -----------------------
test_that("set_censobr_cache_dir", {

  # Wrong date 4 digits
  testthat::expect_error(set_censobr_cache_dir(path = 999))
  testthat::expect_error(set_censobr_cache_dir(path = '999'))
})

