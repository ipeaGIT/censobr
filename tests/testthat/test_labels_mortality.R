context("add_labels_mortality")

# skip tests because they take too much time
skip_if(Sys.getenv("TEST_ONE") != "")
testthat::skip_on_cran()


# Reading the data -----------------------

test_that("add_labels_mortality", {

  # sem labels
  test1a <- read_mortality(year = 2010, add_labels = NULL) |>
            filter(abbrev_state == 'RO')

  # com labels
  test1b <- censobr:::add_labels_mortality(arrw = test1a, year=2010, lang = 'pt') |>
            filter(abbrev_state == 'RO')

  test1a <- as.data.frame(test1a)
  test1b <- as.data.frame(test1b)
  # add labels
  testthat::expect_true('1' %in% test1a$V0704)
  testthat::expect_true('Feminino' %in% test1b$V0704)



 })


# ERRORS and messages  -----------------------
test_that("add_labels_mortality", {

  # missing labels
  testthat::expect_error(censobr:::add_labels_mortality(arrw = test1a, year=9999, lang = 'pt') )
  testthat::expect_error(censobr:::add_labels_mortality(arrw = test1a, year=2010, lang = 9999) )
  testthat::expect_error(censobr:::add_labels_mortality(arrw = test1a, year=2010, lang = 'banana') )

})
