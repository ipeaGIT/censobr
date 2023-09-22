# censobr: Download Data from Brazil's Population Census <img align="right" src="man/figures/logo.png?raw=true" alt="logo" width="180">

[![CRAN
   status](https://www.r-pkg.org/badges/version/censobr)](https://CRAN.R-project.org/package=censobr)
[![R-CMD-check](https://github.com/ipeaGIT/censobr/workflows/R-CMD-check/badge.svg)](https://github.com/ipeaGIT/censobr/actions)
[![Lifecycle:
     experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![CRAN/METACRAN Total
   downloads](http://cranlogs.r-pkg.org/badges/grand-total/censobr?color=yellow)](https://CRAN.R-project.org/package=censobr) [![Codecov test
coverage](https://codecov.io/gh/ipeaGIT/censobr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ipeaGIT/censobr?branch=main)

**censobr** is an R package to download data from Brazil's Population Census. The package is built on top of the [Arrow platform](https://arrow.apache.org/docs/r/), which allows users to work with larger-than-memory census data using [{dplyr} familiar functions](https://arrow.apache.org/docs/r/articles/arrow.html#analyzing-arrow-data-with-dplyr).


## Installation

```R
# install from CRAN
install.packages("censobr")

# or use the development version with latest features
utils::remove.packages('censobr')
remotes::install_github("ipeaGIT/censobr", ref="dev")
library(censobr)
```


## Basic usage

The package currently includes 6 main functions to download census data:

1. `read_population()`
2. `read_households()`
3. `read_mortality()`
4. `read_families()`
5. `read_emigration()`
6. `read_tracts()`

**censobr** also includes a few support functions to help users navigate the documentation Brazilian censuses, providing convenient information on data variables and methodology.:

7. `data_dictionary()`
8. `questionnaire()`
9. `interview_manual()`

Finally, the package includs a function to help users to manage the data chached locally.

10. `censobr_cache()` 

The syntax of all **censobr** functions to read data operate on the same logic so it becomes intuitive to download any data set using a single line of code. Like this:


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

- Pereira, Rafael H. M.; Barbosa, Rogerio J. (2023) censobr: Download Data from Brazil's Population Census. R package version v0.2.0, <https://CRAN.R-project.org/package=censobr>.


```
bibentry(
  bibtype  = "Manual",
  title       = "censobr: Download Data from Brazil's Population Census",
  author      = "Rafael H. M. Pereira [aut, cre] and Rogério J. Barbosa [aut]",
  year        = 2023,
  version     = "v0.2.0",
  url         = "https://CRAN.R-project.org/package=censobr",
  textVersion = "Pereira, R. H. M.; Barbosa, R. J. (2023) censobr: Download Data from Brazil's Population Census. R package version v0.2.0, <https://CRAN.R-project.org/package=censobr>."
)

```
::: {.pkgdown-devel}
tests only on dev branch
`2+2`
:::



