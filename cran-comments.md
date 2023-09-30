## R CMD check results

── R CMD check results ──────────────────────────────────────────── censobr 0.2.0 ────
Duration: 36m 37s

* Major changes
  * New function `read_tracts()` to read  Census tract-level aggregate data.
  * New function `data_dictionary()` opens on a browser the data dictionary of Brazil's census data.
  * New function `questionnaire()` opens on a browser the questionnaire used in the data collection of Brazil's censuses.
  * New function `interview_manual()` opens on a browser the interview manual of the data collection of Brazil's censuses.
    * New function `set_censobr_cache_dir()` that allows users to set custom directory for caching files from the censobr package.
  * New data sets of 1970, 1980 and 1991 censuses: microdata of population and households PLUS Census tract-level aggregate data for 2010. Closes [#6](https://github.com/ipeaGIT/censobr/issues/6), [#7](https://github.com/ipeaGIT/censobr/issues/7), [#8](https://github.com/ipeaGIT/censobr/issues/8) and [1#8](https://github.com/ipeaGIT/censobr/issues/18) 
  * New vignette on Census tract-level aggregate data for 2010.
  * New vignette covering functions about census documentation and dictionary of variables. Closes [#2](https://github.com/ipeaGIT/censobr/issues/2).

* Minor changes
  * Running `censobr_cache(delete_file = 'all')` now removes all data and directories related from censobr.
  * censobr now uses suggested package {geobr} conditionally

* Data included in this version:
  * 1970 census [*New*]
    * Microdata of population, households 
  * 1980 census [*New*]
    * Microdata of population, households 
  * 1991 census [*New*]
    * Microdata of population, households 
  * 2000 Census
    * Microdata of population, households and families.
  * 2010 Census
    * Microdata of population, households, deaths and emigration.
    * Census tract-level aggregate data  [*New*]

