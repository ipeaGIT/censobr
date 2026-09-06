# Read, validate, and compile declarative categorical-label configurations.
#
# Label configurations live in inst/labels/<dataset>/<year>-<language>.yml.
# They are intentionally kept as data: add_labels_*() can share this machinery
# while each configuration preserves the exact labels published by IBGE.

#' Clear the internal label-configuration cache
#'
#' @keywords internal
clear_label_config_cache <- function() {
	cache <- censobr_env$label_config_cache
	if (length(ls(cache, all.names = TRUE)) > 0L) {
		rm(list = ls(cache, all.names = TRUE), envir = cache)
	}
	invisible(NULL)
}

#' Validate one parsed label configuration
#'
#' @param config A list returned by yaml::read_yaml().
#' @param path Character scalar identifying the configuration source.
#' @keywords internal
validate_label_config <- function(config, path = "<configuration>") {
	fail <- function(message) {
		cli::cli_abort("Invalid label configuration {.file {path}}: {message}")
	}

	if (!is.list(config) || is.null(names(config))) { fail("it must be a named mapping") }

	required <- c("schema_version", "dataset", "year", "language", "mappings")
	missing <- setdiff(required, names(config))
	if (length(missing) > 0L) { fail("missing field{?s} {.field {missing}}") }

	if (!identical(config$schema_version, 1L) && !identical(config$schema_version, 1)) {
		fail("{.field schema_version} must be 1")
	}
	if (!is.character(config$dataset) || length(config$dataset) != 1L ||
			is.na(config$dataset) || !nzchar(config$dataset)) {
		fail("{.field dataset} must be one non-empty string")
	}
	if (!is.numeric(config$year) || length(config$year) != 1L || is.na(config$year) ||
			config$year != as.integer(config$year)) {
		fail("{.field year} must be one integer")
	}
	if (!is.character(config$language) || length(config$language) != 1L ||
			is.na(config$language) || !nzchar(config$language)) {
		fail("{.field language} must be one non-empty string")
	}
	if (!is.list(config$mappings) || length(config$mappings) == 0L) {
		fail("{.field mappings} must be a non-empty list")
	}

	variables_seen <- character()
	for (index in seq_along(config$mappings)) {
		mapping <- config$mappings[[index]]
		prefix <- paste0("mapping ", index, "")

		if (!is.list(mapping) || is.null(names(mapping))) { fail("{prefix} must be a named mapping") }
		needed <- c("variables", "unmatched", "levels")
		absent <- setdiff(needed, names(mapping))
		if (length(absent) > 0L) { fail("{prefix} missing field{?s} {.field {absent}}") }

		variables <- mapping$variables
		if (!is.character(variables) || length(variables) == 0L || anyNA(variables) ||
				any(!nzchar(variables)) || anyDuplicated(variables)) {
			fail("{prefix} {.field variables} must be unique non-empty strings")
		}
		duplicate_variables <- intersect(variables_seen, variables)
		if (length(duplicate_variables) > 0L) {
			fail("variable{?s} {.field {duplicate_variables}} appear in more than one mapping")
		}
		variables_seen <- c(variables_seen, variables)

		# YAML null means that unmatched, non-missing source values become NA.
		if (!is.null(mapping$unmatched) &&
				(!is.character(mapping$unmatched) || length(mapping$unmatched) != 1L ||
				 is.na(mapping$unmatched))) {
			fail("{prefix} {.field unmatched} must be null or one string")
		}

		levels <- mapping$levels
		if (!is.list(levels) || length(levels) == 0L) {
			fail("{prefix} {.field levels} must be a non-empty list")
		}

		codes_seen <- character()
		for (level_index in seq_along(levels)) {
			level <- levels[[level_index]]
			if (!is.list(level) || is.null(names(level)) ||
					!all(c("code", "label") %in% names(level))) {
				fail("{prefix} level {level_index} must contain {.field code} and {.field label}")
			}
			if (!is.character(level$code) || length(level$code) != 1L || is.na(level$code)) {
				fail("{prefix} level {level_index} {.field code} must be one string")
			}
			if (!is.character(level$label) || length(level$label) != 1L || is.na(level$label)) {
				fail("{prefix} level {level_index} {.field label} must be one string")
			}
			if (level$code %in% codes_seen) {
				fail("{prefix} repeats code {.val {level$code}}")
			}
			codes_seen <- c(codes_seen, level$code)
		}
	}

	invisible(config)
}

#' Load a validated label configuration
#'
#' @param dataset Character scalar.
#' @param year Numeric scalar.
#' @param lang Character scalar.
#' @param root Root directory containing dataset label directories.
#' @keywords internal
load_label_config <- function(dataset, year, lang = "pt",
															root = system.file("labels", package = "censobr")) {
	checkmate::assert_string(dataset)
	checkmate::assert_number(year, lower = 0, finite = TRUE)
	checkmate::assert_string(lang)
	checkmate::assert_string(root)

	path <- file.path(root, dataset, paste0(as.integer(year), "-", lang, ".yml"))
	if (!file.exists(path)) {
		cli::cli_abort("No label configuration for {.val {dataset}}, year {.val {year}}, language {.val {lang}}.")
	}

	cache_key <- paste(normalizePath(path, mustWork = TRUE), collapse = "")
	cache <- censobr_env$label_config_cache
	if (exists(cache_key, envir = cache, inherits = FALSE)) {
		return(get(cache_key, envir = cache, inherits = FALSE))
	}

	config <- yaml::read_yaml(path)
	validate_label_config(config, path)

	if (!identical(config$dataset, dataset) || config$year != as.integer(year) ||
			!identical(config$language, lang)) {
		cli::cli_abort("Label configuration {.file {path}} does not match its requested dataset, year, and language.")
	}

	assign(cache_key, config, envir = cache)
	config
}

#' Build a case_when expression for one configured variable
#'
#' @keywords internal
label_mapping_expression <- function(variable, mapping) {
	column <- rlang::sym(variable)
	clauses <- lapply(mapping$levels, function(level) {
		rlang::expr(!!column == !!level$code ~ !!level$label)
	})

	# `unmatched: null` is equivalent to the current case_when() calls without
	# a default. A string default preserves the current yes/no if_else() rules,
	# while the explicit is.na() guard leaves source nulls untouched.
	if (!is.null(mapping$unmatched)) {
		clauses <- c(clauses, list(
			rlang::expr(!is.na(!!column) ~ !!mapping$unmatched)
		))
	}

	rlang::expr(dplyr::case_when(!!!clauses))
}

#' Compile configured label mutations
#'
#' @param config A validated label configuration.
#' @param columns Character vector of columns available in the data.
#' @keywords internal
label_config_mutations <- function(config, columns) {
	validate_label_config(config)
	checkmate::assert_character(columns, any.missing = FALSE)

	mutations <- list()
	for (mapping in config$mappings) {
		available <- intersect(mapping$variables, columns)
		for (variable in available) {
			mutations[[variable]] <- label_mapping_expression(variable, mapping)
		}
	}
	mutations
}

#' Apply configured categorical labels in one dplyr mutation
#'
#' @param arrw An Arrow dplyr query, Arrow table, or data frame.
#' @param config A validated label configuration.
#' @return `arrw` with configured columns replaced by character labels.
#' @keywords internal
apply_label_config <- function(arrw, config) {
	mutations <- label_config_mutations(config, names(arrw))
	if (length(mutations) == 0L) { return(arrw) }
	dplyr::mutate(arrw, !!!mutations)
}
