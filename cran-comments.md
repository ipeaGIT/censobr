## R CMD check results

── R CMD check results ──────────────────────────────────────────── censobr 0.4.0 ────
Duration: 12m 6.4s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔


* Major changes
  * Some functions (`read_mortality`, `read_emigration`) now include a new parameter `merge_households` (logical) to indicate whether the function should merge household variables to the output data. Partially closes [#31](https://github.com/ipeaGIT/censobr/issues/31)
  * {censobr} now imports the {duckplyr} package, which is used for merging household data. Closes issue [#31](https://github.com/ipeaGIT/censobr/issues/31).
  * New vignette showing how to work with larger-than-memory data. Closes [#42](https://github.com/ipeaGIT/censobr/issues/42). The vignette still needs to be expanded with more examples, though.

* Minor changes
  * Updated Vignettes Closes issue [#51](https://github.com/ipeaGIT/censobr/issues/51)
  * Removed dependency on the {httr} package
  * Now using `curl::multi_download()` to download files in parallel. This brings the advantage that the pacakge now automatically detects whether the data/documentation file has been upated and should be downloaded again.

* Changes to data sets and files included in this version:
  * Population microdata for the year 2000 now include a few columns that were not included before. Closes [#44](https://github.com/ipeaGIT/censobr/issues/44)
  * Included additional columns and fixed minor errors in data dictionary of 2010 microdata. Closes [#45](https://github.com/ipeaGIT/censobr/issues/45) 

* New data set and files included in this version:
  * 1960 census Closes [#32](https://github.com/ipeaGIT/censobr/issues/32)
    * Interview manual 
    * Data dictionary for microdata of population and households
    * Microdata of population and households
  * 1970: fixed geography columns. Closes [#52](https://github.com/ipeaGIT/censobr/issues/52)
  * 1991 census: Data dictionary for microdata of population and households. Closes [#28](https://github.com/ipeaGIT/censobr/issues/28)
