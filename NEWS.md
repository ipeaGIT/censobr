# censobr v0.1.1999 dev

* Major changes
  * New function `data_dictionary()` opens on a browser the data dictionary of Brazil's census data.
  * New function `questionnaire()` opens on a browser the questionnaire used in the data collection of Brazil's censuses.
  * New function `interview_manual()` opens on a browser the interview manual of the data collection of Brazil's censuses.
  * New data sets of 1970, 1980 and 1991 censuses: microdata of population and households. Closes [#6](https://github.com/ipeaGIT/censobr/issues/6), [#7](https://github.com/ipeaGIT/censobr/issues/7) and [#8](https://github.com/ipeaGIT/censobr/issues/8).
  * New vignettes with the data dictionary of censos 2010 and 2000.
  * New vignette covering functions about census documentation and dictionary of variables. Closes [#2](https://github.com/ipeaGIT/censobr/issues/2).

* Minor changes
  * Running `censobr_cache(delete_file = 'all')` now removes all data and directories related from censobr.

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


# censobr v0.1.1

* Minor changes
  * Using cache_dir and data_release as global variables. Closes [#13](https://github.com/ipeaGIT/censobr/issues/13)
  * Running `censobr_cache(delete_file = 'all')`now also remove data from old data releases. Closes [#14](https://github.com/ipeaGIT/censobr/issues/14).
  * Large improvement in code coverage 

* Changes requested by CRAN team
  * Changed location of cached data to directory inside tools::R_user_dir("censobr", which = "cache"). 
  * The package now automatically deletes cached data from previous data releases that might exist from previous versions of the package
  * Clean cache after intro vignette and testhat checks

# censobr v0.1.0

* Launch of **censobr** v0.1.0 on CRAN https://cran.r-project.org/package=censobr
* All data sets are now enriched with geography columns following {geobr} name standards. This should help data manipulation and integration with spatial data from the [{geobr}](https://github.com/ipeaGIT/geobr) package. The added columns are: c('code_muni', 'code_state', 'abbrev_state', 'name_state', 'code_region', 'name_region', 'code_weighting'). Closes #5.
* Data included in this version:
  * 2000 Census
    * Microdata of population, households and families.
  * 2010 Census
    * Microdata of population, households, deaths and emigration.
