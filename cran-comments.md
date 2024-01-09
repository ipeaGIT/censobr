## R CMD check results

── R CMD check results ───────────────────────────────────────────── censobr 0.2.0999 ────
Duration: 21m 10.4s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

* Major changes
  * The `questionnaire()` function now accepts questionnaires of `type`: `"long"` or `"short"`.
  * Updated census tract data following latest update by IBGE on Oct/2023. Closed [#38](https://github.com/ipeaGIT/censobr/issues/38). As a result, the package moved to data release v0.3.0.

* Minor changes
  * Replaced `.onAttach` by `.onLoad` so that the package works with `censobr::function()`
  * Fixed documentation of various functions.
  * Fixed issue to make sure censobr uses suggested packages conditionally on CRAN
  * Fixed message when user requests a data set / file for a year that is not available

* New data set and files included in this version:
  * 2022 census [*New*]
    * Questionnaires and interview manuals 
  * Short questionnaires for every census between 1960 and 2022.
  * Long questionnaire for the 1960 and 2022 censuses.

