# censobr: Download Data from Brazil's Population Census <img align="right" src="man/figures/logo.png?raw=true" alt="logo" width="180">

[![CRAN
   status](https://www.r-pkg.org/badges/version/censobr)](https://CRAN.R-project.org/package=censobr)
[![R-CMD-check](https://github.com/ipeaGIT/censobr/workflows/R-CMD-check/badge.svg)](https://github.com/ipeaGIT/censobr/actions)
[![Lifecycle:
     experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![CRAN/METACRAN Total
   downloads](http://cranlogs.r-pkg.org/badges/grand-total/censobr?color=yellow)](https://CRAN.R-project.org/package=censobr)

**censobr** is an R package to download data from Brazil's Population Census. The package is built on top of the [Arrow patform](https://arrow.apache.org/docs/r/), which allow users to work with larger-than-memory census data using [{dplyr} familiar functions](https://arrow.apache.org/docs/r/articles/arrow.html#analyzing-arrow-data-with-dplyr).

*obs.:* The package is still under development. At the moment, censobr only includes microdata from the 2000 and 2010 censuses, but it is being expanded to cover more years and data sets.

## Installation

**censobr** is no on CRAN yet. For now, you can install the dev version from Github.

```R
utils::remove.packages('censobr')
devtools::install_github("ipeaGIT/censobr")
```


## Basic usage

The package currently includes 3 main functions to download Census microdata:

1. `read_population()`
2. `read_households()`
3. `read_deaths()`

The syntax of all **censobr** functions operate on the same logic so it becomes intuitive to download any data set using a single line of code. Like this:

```
dfh <- read_households(
          year,          # year of reference
          columns,       # whether to return only selected columns
          as_data_frame, # whether to return an Arrow table or a data.frame
          showProgress,  # whether to show a download progress bar
          cache          # whether to cache data for faster access later
         )

```

## Larger-than-memory Data

Microdata of Brazilian census are often be too big to load in users' RAM memory. To avoid this problem, **censobr** will by default return an [Arrow table](https://arrow.apache.org/docs/r/articles/arrow.html#tabular-data-in-arrow), which can be analyzed like a regular `data.frame` using the `dplyr` package without loading the full data to memory.

This example below calculates the average rent in by state.

```
dfh |> group_by(V0001) |>
  summarize(mean_rent = weighted.mean(x=V2011, w=V0010, na.rm = TRUE))

```

In case users want the output as a `data.frame`, though, they can pass the parameter `as_data_frame = TRUE`.



## Acknowledgement <a href="https://www.ipea.gov.br"><img align="right" src="man/figures/ipea_logo.png" alt="IPEA" width="300" /></a>

Original data is collected by the Brazilian Institute of Geography and Statistics (IBGE). The **censobr** package is developed by a team at the Institute for Applied Economic Research (Ipea), Brazil. 
