# censobr v0.1.9999 dev

* Major changes:
  * New data sets for the 2000 census (population, households and families) Closes #1.
  * New data sets for the 2010 census (emmigration). Closes #1.
  * All data sets are now enriched with geography columns following {geobr} name standards. This should help data manipulation and integration with spatial data from the [{geobr}](https://github.com/ipeaGIT/geobr) package. The added columns are: c('code_muni', 'code_state', 'abbrev_state', 'name_state', 'code_region', 'name_region', 'code_weighting'). Closes #5.

* Data included in this version:
  * 2000 Census
    * Microdata of population, households and families.
  * 2010 Census
    * Microdata of population, households, deaths and emmigration.


# censobr v0.1.0

* Launch of **censobr** v0.1.0 on CRAN https://cran.r-project.org/package=censobr
* Data included in this version:
  * 2010 Census
    * Microdata of population, households and deaths.
