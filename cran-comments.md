## R CMD check results

── R CMD check results ─────────────────────────────────────────── censobr 0.1.0 ────
Duration: 5m 20.9s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

* This is a new release.
* Reviewed description text
* This package does not write in the user’s home filespace. Instead, it writes files in the user's data folder using `tools::R_user_dir()`. This is the same approach used in several other packages on CRAN such as r2u, targets, duckdb, modelsummary, rtweet, rnoaa, taxadb, sass, censo2017 among others. As far as I understandand, this is in line with CRAN's policy, which says:
  * "For R version 4.0 or later (hence a version dependency is required or only conditional use is possible), packages may store user-specific data, configuration and cache files in their respective user directories obtained from tools::R_user_dir(), provided that by default sizes are kept as small as possible and the contents are actively managed (including removing outdated material)."
