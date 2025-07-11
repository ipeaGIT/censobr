% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_households.R
\name{read_households}
\alias{read_households}
\title{Download microdata of household records from Brazil's census}
\usage{
read_households(
  year,
  columns = NULL,
  add_labels = NULL,
  as_data_frame = FALSE,
  showProgress = TRUE,
  cache = TRUE,
  verbose = TRUE
)
}
\arguments{
\item{year}{Numeric. Year of reference in the format \code{yyyy}.}

\item{columns}{String. A vector of column names to keep. The rest of the
columns are not read. Defaults to \code{NULL} and read all columns.}

\item{add_labels}{Character. Whether the function should add labels to the
responses of categorical variables. When \code{add_labels = "pt"}, the
function adds labels in Portuguese. Defaults to \code{NULL}.}

\item{as_data_frame}{Logical. When \code{FALSE} (Default), the function returns an
Arrow Dataset, which allows users to work with larger-than-memory data.
If \code{TRUE}, the function returns \code{data.frame}.}

\item{showProgress}{Logical. Defaults to \code{TRUE} display download progress
bar. The progress bar only reflects only the downloading
time, not the time to load the data to memory.}

\item{cache}{Logical. Whether the function should read the data cached
locally, which is much faster. Defaults to \code{TRUE}. The first time the
user runs the function, \code{censobr} will download the file and store it
locally so that the file only needs to be download once. If \code{FALSE},
the function will download the data again and overwrite the local file.}

\item{verbose}{A logical. Whether the function should print informative
messages. Defaults to \code{TRUE}.}
}
\value{
An arrow \code{Dataset} or a \code{"data.frame"} object.
}
\description{
Download microdata of household records from Brazil's census. Data collected
in the sample component of the questionnaire.
}
\section{1960 Census}{


The 1960 microdata version available in \strong{{censobr}} is a combination of two
versions of the Demographic Census sample. The 25\% sample data from the 1960
Census was never fully processed by IBGE - several states did not have their
questionnaires digitized. Currently, this dataset only has data from 16 states
of the Federation (and from a contested border region between Minas Gerais and
Espirito Santo called Serra dos Aimores). Information is missing for the states
of the former Northern Region, Maranhão, Piaui, Guanabara, Santa Catarina, and
Espírito Santo. In 1965, IBGE decided to draw a probabilistic sub-sample of
approximately 1.27\% of the population, including all units of the federation.
With this data, IBGE produced several official reports at the time. The data
from \strong{{censobr}} is the combination of these two datasets.

We pre-processed the 1.27\% sample data to ensured data consistency, given the
original data was partially corrupted. We also created a sample weight variable
to correct for unbalanced data and to expand te sample to the total
population. For the data from the 25\% sample, the weights expand to the
municipal totals. Meanwhile, for the data from the 1.27\% sample, the weights
expand to the state totals. Additionally, we constructed a few variables that
allow for the approximate incorporation of the complex sample design, enabling
the proper calculation of standard errors and confidence intervals.

You can read more about the 1960 Census and find a thorough documentation of
how this dataset was processed on this link \url{https://github.com/antrologos/ConsistenciaCenso1960Br}.
}

\examples{
\dontshow{if (identical(tolower(Sys.getenv("NOT_CRAN")), "true")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# return data as arrow Dataset
df <- read_households(
  year = 2010,
  showProgress = FALSE
  )

\dontshow{\}) # examplesIf}
}
\seealso{
Other Microdata: 
\code{\link{read_emigration}()},
\code{\link{read_families}()},
\code{\link{read_mortality}()},
\code{\link{read_population}()}
}
\concept{Microdata}
