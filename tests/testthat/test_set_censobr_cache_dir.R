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
  fname <- paste0('2010_emigration_',data_release, '.parquet')
  testthat::expect_true( file.exists(fname_full) )
  testthat::expect_true( file.exists(paste0(tempd,'/',fname)) )

 })


# ERRORS and messages  -----------------------
test_that("set_censobr_cache_dir", {

  # Wrong date 4 digits
  testthat::expect_error(set_censobr_cache_dir(path = 999))
  testthat::expect_error(set_censobr_cache_dir(path = '999'))
})

