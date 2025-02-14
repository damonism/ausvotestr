% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/search.R
\name{search_returns_date}
\alias{search_returns_date}
\title{Search donor and recipient returns by date}
\usage{
search_returns_date(donor_name, from_date, ...)
}
\arguments{
\item{donor_name}{Donor name as a regular expression.}

\item{from_date}{Date in 'YYYY-MM-DD' format.}

\item{...}{Passed to \code{search_returns()}.}
}
\value{
A \code{data.frame}.
}
\description{
Deprecated -- use \link{search_returns} with \code{from_date} instead.
}
\examples{
search_returns_date("Woodside|AGL", from_date = "2010-01-01")
}
