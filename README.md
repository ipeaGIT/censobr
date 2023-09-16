# censobr: Download Data from Brazil's Population Census <img align="right" src="man/figures/logo.png?raw=true" alt="logo" width="180">

[![CRAN
   status](https://www.r-pkg.org/badges/version/censobr)](https://CRAN.R-project.org/package=censobr)
[![CRAN/METACRAN Total
   downloads](http://cranlogs.r-pkg.org/badges/grand-total/censobr?color=blue)](https://CRAN.R-project.org/package=censobr) [![Codecov test
coverage](https://codecov.io/gh/ipeaGIT/censobr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ipeaGIT/censobr?branch=main)
[![Lifecycle:
     maturing](https://img.shields.io/badge/lifecycle-maturing-yellow.svg)](https://lifecycle.r-lib.org/articles/stages.html)

[![R-CMD-check-main](https://github.com/ipeaGIT/censobr/workflows/R-CMD-check-main/badge.svg)](https://github.com/ipeaGIT/censobr/actions)
[![R-CMD-check-dev](https://github.com/ipeaGIT/censobr/workflows/R-CMD-check-dev/badge.svg)](https://github.com/ipeaGIT/censobr/actions)


**censobr** is an R package to download data from Brazil's Population Census. The package is built on top of the [Arrow platform](https://arrow.apache.org/docs/r/), which allows users to work with larger-than-memory census data using [{dplyr} familiar functions](https://arrow.apache.org/docs/r/articles/arrow.html#analyzing-arrow-data-with-dplyr).

*obs.:* The package is still under development. At the moment, censobr only includes microdata from the 2000 and 2010 censuses, but it is being expanded to cover more years and data sets.

## Installation

```R
# install from CRAN
install.packages("censobr")

# or use the development version with latest features
utils::remove.packages('censobr')
devtools::install_github("ipeaGIT/censobr")
library(censobr)
```


## Basic usage

The package currently includes 5 main functions to download Census microdata:

1. `read_population()`
2. `read_households()`
3. `read_mortality()`
4. `read_families()`
5. `read_emigration()`


The syntax of all **censobr** functions operate on the same logic so it becomes intuitive to download any data set using a single line of code. Like this:

```
read_households(
  year,          # year of reference
  columns,       # select columns to read
  add_labels,    # add labels to categorical variables
  as_data_frame, # return an Arrow DataSet or a data.frame
  showProgress,  # show download progress bar
  cache          # cache data for faster access later
  )
```

***Note:*** all data sets in **censobr** are enriched with geography columns following the name standards of the [{geobr} package](https://github.com/ipeaGIT/geobr/) to help data manipulation and integration with spatial data from {geobr}. The added columns are: `c(‘code_muni’, ‘code_state’, ‘abbrev_state’, ‘name_state’, ‘code_region’, ‘name_region’, ‘code_weighting’)`.

### Data cache

The first time the user runs a function, **censobr** will download the file and store it locally. This way, the data only needs to be downloaded once. When the `cache` parameter is set to `TRUE` (Default), the function will read the cached data, which is much faster. Users can list and/or delete data files cached locally using the `censobr_cache()` function.


## Larger-than-memory Data

Microdata of Brazilian census are often be too big to load in users' RAM memory. To avoid this problem, **censobr** will by default return an [Arrow table](https://arrow.apache.org/docs/r/articles/arrow.html#tabular-data-in-arrow), which can be analyzed like a regular `data.frame` using the `dplyr` package without loading the full data to memory.

More info in the package [vignette](https://ipeagit.github.io/censobr/).


## Contributing to censobr
If you would like to contribute to **censobr**, you're welcome to open an issue to explain the proposed a contribution.

-----

#### **Related projects**

Afaik, **censobr** is the only R package that provides fast and convenient access to data of Brazilian censuses. The [microdadosBrasil](https://github.com/lucasmation/microdadosBrasil) package used to provide access to microdata of several public data sets, but unfortunately, it has been discontinued.

#### **Similar packages for other countries**
- Canada: [cancensus](https://mountainmath.github.io/cancensus/)
- Chile: [censo2017](https://docs.ropensci.org/censo2017/)
- US: [tidycensus](https://walker-data.com/tidycensus/)
- World: [ipumsr](https://tech.popdata.org/ipumsr/)


## Credits <a href="https://www.ipea.gov.br"><img align="right" src="man/figures/ipea_logo.png" alt="IPEA" width="300" /></a>

Original Census data is collected by the Brazilian Institute of Geography and Statistics (IBGE). The **censobr** package is developed by a team at the Institute for Applied Economic Research (Ipea), Brazil. If you want to cite this package, you can cite it as:

- Pereira, R.H.M. (2023) censobr: Download Data from Brazil's Population Census. GitHub repository - https://github.com/ipeaGIT/censobr.


::: {.pkgdown-devel}
tests only on dev branch
`2+2`
:::



