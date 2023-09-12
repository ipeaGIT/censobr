## R CMD check results

── R CMD check results ─────────────────────────────────────── censobr 0.1.1 ────
Duration: 12m 10s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

* Changes requested by CRAN team
  * Changed location of cached data to directory inside tools::R_user_dir("censobr", which = "cache"). 
  * The package now automatically deletes cached data from previous data releases that might exist from previous versions of the package
  * Clean cache after intro vignette and testhat checks

* Minor changes
  * Using cache_dir and data_release as global variables. Closes [#13](https://github.com/ipeaGIT/censobr/issues/13)
  * Running `censobr_cache(delete_file = 'all')`now also remove data from old data releases. Closes [#14](https://github.com/ipeaGIT/censobr/issues/14).
  * Large improvement in code coverage 
