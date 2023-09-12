# censobr v0.1.1999 dev

* Minor changes
  * Running `censobr_cache(delete_file = 'all')` now removes all data and directories related from censobr.
  
  

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
