context("censobr_cache")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()
testthat::skip_if_not_installed("arrow")


# Reading the data -----------------------

test_that("censobr_cache", {

  # clean cache
  censobr_cache(delete_file = 'all')

  # simply list files
  testthat::expect_message( censobr_cache(list_files = TRUE) )

  # default cache dir
  censobr::set_censobr_cache_dir(path = NULL)
  cache_dir <- censobr::get_censobr_cache_dir()

  # download
  censobr::read_emigration(year = 2010, showProgress = FALSE, cache = TRUE)

  # list cached files
  files <- list.files(cache_dir, full.names = TRUE, recursive = TRUE)
  fname <- paste0('2010_emigration_',censobr_env$data_release, '.parquet')
  fname_full <- files[grepl(fname, files)]

  testthat::expect_true( file.exists(fname_full) )
  testthat::expect_message( censobr_cache(delete_file = fname) )
  testthat::expect_false( file.exists(fname_full) )

  ## delete ALL
  censobr::read_emigration(year = 2010, showProgress = FALSE, cache = TRUE)
  files <- list.files(cache_dir, full.names = TRUE, recursive = TRUE)
  fname <- paste0('2010_emigration_',censobr_env$data_release, '.parquet')
  fname_full <- files[grepl(fname, files)]
  testthat::expect_true( file.exists(fname_full) )
  testthat::expect_message( censobr_cache(delete_file = 'all') )
  censobr_cache(delete_file = 'all')
  testthat::expect_true(
    length(list.files(cache_dir, recursive = TRUE, full.names = TRUE)) ==0
  )

  # if file does not exist, simply print message
  testthat::expect_message( censobr_cache(delete_file ='aaa') )


  # check is output is "fs_path" when print_tree = TRUE
  censobr::read_emigration(year = 2010, showProgress = FALSE, cache = TRUE)
  testthat::expect_message(censobr_cache(list_files = TRUE, print_tree = TRUE))
  temp <- censobr_cache(list_files = TRUE, print_tree = TRUE)
  testthat::expect_is(temp, "fs_path")

  # get current cache dir
  testthat::expect_true(is.character(get_censobr_cache_dir()))

 })


# ERRORS and messages  -----------------------
test_that("censobr_cache", {

  # Wrong date 4 digits
  testthat::expect_error(censobr_cache(list_files= 999))
  testthat::expect_error(censobr_cache(print_tree = 999))
  testthat::expect_error(censobr_cache(delete_file = 999))

  # check is output is "fs_path" when print_tree = TRUE
  testthat::expect_error(censobr_cache(list_files = FALSE, print_tree = TRUE))

  # no messages
  testthat::expect_no_message(censobr_cache(list_files = FALSE, verbose = FALSE))

  })


# clean cache
censobr_cache(delete_file = 'all')
