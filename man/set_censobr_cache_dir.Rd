% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cache.R
\name{set_censobr_cache_dir}
\alias{set_censobr_cache_dir}
\title{Set custom cache directory for censobr files}
\usage{
set_censobr_cache_dir(path, verbose = TRUE)
}
\arguments{
\item{path}{String. The path to an existing directory. It defaults to
\code{path = NULL}, to use the default directory}

\item{verbose}{A logical. Whether the function should print informative
messages. Defaults to \code{TRUE}.}
}
\value{
A message pointing to the directory where censobr files are cached.
}
\description{
Set custom directory for caching files from the censobr package. The user
only needs to run this function once. This set directory is persistent across
R sessions.
}
\examples{
\dontshow{if (identical(tolower(Sys.getenv("NOT_CRAN")), "true")) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}

# Set custom cache directory
tempd <- tempdir()
set_censobr_cache_dir(path = tempd)

# back to default path
set_censobr_cache_dir(path = NULL)
\dontshow{\}) # examplesIf}
}
\seealso{
Other Cache data: 
\code{\link{censobr_cache}()},
\code{\link{get_censobr_cache_dir}()}
}
\concept{Cache data}
