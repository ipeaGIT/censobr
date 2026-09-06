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

test_that("apply_label_config stays lazy for Arrow queries", {
	testthat::skip_if_not_installed("arrow")

	root <- testthat::test_path("fixtures", "labels")
	config <- censobr:::load_label_config("population", 2010, "pt", root = root)
	input <- arrow::arrow_table(data.frame(
		V0601 = c("1", "2", "9", NA_character_, "7"),
		V0617 = c("1", "0", "2", NA_character_, ""),
		untouched = 1:5
	))

	query <- censobr:::apply_label_config(input, config)
	output <- dplyr::collect(query)

	testthat::expect_s3_class(query, "arrow_dplyr_query")
	testthat::expect_identical(
		output$V0601,
		c("Masculino", "Feminino", "Ignorado", NA_character_, NA_character_)
	)
	testthat::expect_type(output$V0601, "character")
	testthat::expect_type(output$V0617, "character")
})

test_that("population pilot configuration preserves published labels", {
	config <- censobr:::load_label_config(
		"population", 2010, "pt",
		root = system.file("labels", package = "censobr")
	)
	input <- data.frame(
		V1006 = c("1", "2", NA_character_, "3"),
		V0502 = c("01", "19", "20", "99"),
		V0601 = c("1", "2", "9", "7")
	)

	output <- censobr:::apply_label_config(input, config)

	testthat::expect_identical(output$V1006, c("Urbana", "Rural", NA_character_, NA_character_))
	testthat::expect_identical(
		output$V0502,
		c("Pessoa responsável pelo domicílio ",
			"Parente do(a) empregado(a)  doméstico(a)",
			"Individual em domicílio coletivo", NA_character_)
	)
	testthat::expect_identical(output$V0601, c("Masculino", "Feminino", "Ignorado", NA_character_))
})

test_that("add_labels_population applies the YAML pilot lazily", {
	testthat::skip_if_not_installed("arrow")
	input <- arrow::arrow_table(data.frame(
		V1006 = c("1", "2", "3"),
		V0502 = c("01", "19", "99"),
		V0601 = c("1", "9", "7")
	))

	query <- censobr:::add_labels_population(input, year = 2010, lang = "pt")
	output <- dplyr::collect(query)

	testthat::expect_s3_class(query, "arrow_dplyr_query")
	testthat::expect_identical(output$V1006, c("Urbana", "Rural", NA_character_))
	testthat::expect_identical(
		output$V0502,
		c("Pessoa responsável pelo domicílio ",
			"Parente do(a) empregado(a)  doméstico(a)", NA_character_)
	)
	testthat::expect_identical(output$V0601, c("Masculino", "Ignorado", NA_character_))
})
