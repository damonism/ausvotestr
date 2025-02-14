% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/search.R
\name{search_donor_returns}
\alias{search_donor_returns}
\title{Donor returns search}
\usage{
search_donor_returns(donor_name, approximate = FALSE)
}
\arguments{
\item{donor_name}{donor name}

\item{approximate}{logical. If \code{TRUE}, will use \link{agrep} for
searching rather than \link{grep}.}
}
\value{
A \code{data.frame}.
}
\description{
Generally \link{search_returns} will be a better option for searching this
data.
}
