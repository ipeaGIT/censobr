test_that("load_label_config validates and caches a YAML configuration", {
	censobr:::clear_label_config_cache()
	root <- testthat::test_path("fixtures", "labels")

	config <- censobr:::load_label_config("population", 2010, "pt", root = root)
	cached <- censobr:::load_label_config("population", 2010, "pt", root = root)

	testthat::expect_identical(config, cached)
	testthat::expect_identical(config$mappings[[1]]$levels[[1]]$code, "1")
	testthat::expect_identical(config$mappings[[2]]$unmatched, "Não")
})

test_that("label configuration rejects invalid mappings", {
	config <- list(
		schema_version = 1L,
		dataset = "population",
		year = 2010,
		language = "pt",
		mappings = list(list(
			variables = c("V0601", "V0601"),
			unmatched = NULL,
			levels = list(list(code = "1", label = "Masculino"))
		))
	)

	testthat::expect_error(
		censobr:::validate_label_config(config),
		"variables"
	)
})

test_that("apply_label_config generates character labels in one mutation", {
	root <- testthat::test_path("fixtures", "labels")
	config <- censobr:::load_label_config("population", 2010, "pt", root = root)
	input <- data.frame(
		V0601 = c("1", "2", "9", NA_character_, "7"),
		V0617 = c("1", "0", "2", NA_character_, ""),
		untouched = 1:5
	)

	output <- censobr:::apply_label_config(input, config)

	testthat::expect_identical(
		output$V0601,
		c("Masculino", "Feminino", "Ignorado", NA_character_, NA_character_)
	)
	testthat::expect_identical(
		output$V0617,
		c("Sim", "Não", "Não", NA_character_, "Não")
	)
	testthat::expect_identical(output$untouched, input$untouched)
	testthat::expect_identical(vapply(output, typeof, character(1)),
														 c(V0601 = "character", V0617 = "character", untouched = "integer"))
})

test_that("label_config_mutations only includes present columns", {
	root <- testthat::test_path("fixtures", "labels")
	config <- censobr:::load_label_config("population", 2010, "pt", root = root)

	mutations <- censobr:::label_config_mutations(config, c("V0617", "other"))

	testthat::expect_identical(names(mutations), "V0617")
})
