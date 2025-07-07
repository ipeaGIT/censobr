## R CMD check results

── R CMD check results ────────────────────────────────── censobr 0.5.0 ────
Duration: 7m 14.1s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔


* Major changes
  * New function `get_censobr_cache_dir()`
  * The function `set_censobr_cache_dir()` now sets cache directories that persist across R sessions. Closes [#55](https://github.com/ipeaGIT/censobr/issues/55). The data is saved in versioned directory inside the cache directory.
  * New parameter `verbose` (logical) indicating whether functions should print messsages
  * The `year` parameter no longer defaults to `2010`.

* Minor changes
  * Improved internal code of `merge_households = TRUE` to avoid duplicated columns 
  * Improved package info and error messages with {cli}
  * {censobr} now imports {cli} and {rlang}

* New data set and files included in this version:
  * 2022 census. Closes [#64](https://github.com/ipeaGIT/censobr/issues/64)
    * Census-tract level data
    * Census-tract level data dictionary
  * 2000 census. Closes [#43](https://github.com/ipeaGIT/censobr/issues/43)
    * Census-tract level data
  * All data sets are save in `.parquet` compressed using `compression='zstd'` and `compression_level = 22`. This has almost halved the size of data files, making downloads much more efficient at minimal cost of reading time.
  * All data sets are now sorted by key columns to speed up join operations. Closes #60.
  * Fixed annoying message about arrow metadata. closed #56.
