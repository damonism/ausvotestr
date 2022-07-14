ausvotesTR
================

`ausvotesTR` is an R package of the data provided by the Australian
Electoral Commission’s (AEC) [Transparency
Register](https://transparency.aec.gov.au/).

The package aims to be both easier to access than the data on the AEC’s
website, and also to provide linkages and metadata that is available on
the AEC site, but isn’t readily accessed.

Scripts to re-create all of the data used in the package are included in
the `data-raw` folder.

The package also contains some convenience functions for analysing the
data and a Shiny app for quickly searching for donations by donors.

## Installation

To install from GitLab:

``` r
remotes::install_gitlab("damonism/ausvotesTR")
```

## Data extraction date

The [*Commonwealth Electoral Act
1918*](https://www.legislation.gov.au/Latest/C2019C00103) requires
parties, associated entities, donors, third parties and political
campaigners to submit an annual return with any donations above the
[disclosure
threshold](https://www.aec.gov.au/Parties_and_Representatives/public_funding/threshold.htm)
each financial year. Data extracted from the returns is then published
on the first working day of the following February.

Regulated entities may submit an amendment to their returns to the AEC,
and the data in the package will reflect all of the returns and any
amendments at the time of extraction.

The current data in the package was extracted on 14 July 2022.

## Disclosure threshold

The disclosure threshold is CPI indexed annually. Donations below the
threshold may not be included in returns.

The disclosure threshold for each year was:

| FinancialYear | ReportingThreshold |
|:--------------|-------------------:|
| 2020-21       |             14,300 |
| 2019-20       |             14,000 |
| 2018-19       |             13,800 |
| 2017-18       |             13,500 |
| 2016-17       |             13,200 |
| 2015-16       |             13,000 |
| 2014-15       |             12,800 |
| 2013-14       |             12,400 |
| 2012-13       |             12,100 |
| 2011-12       |             11,900 |
| 2010-11       |             11,500 |
| 2009-10       |             11,200 |
| 2008-09       |             10,900 |
| 2007-08       |             10,500 |
| 2006-07       |             10,300 |
| 2005-06       |              1,500 |
| 2004-05       |              1,500 |
| 2003-04       |              1,500 |
| 2002-03       |              1,500 |
| 2001-02       |              1,500 |
| 2000-01       |              1,500 |
| 1999-00       |              1,500 |
| 1998-99       |              1,500 |

## Todo

-   [ ] Add links to AEC returns from Shiny app
-   [ ] Properly document the election returns data frames
-   [x] Combine `returns_search` and `returns_search_date`
-   [x] Complete the documentation of the data
-   [x] The Shiny app should have an option not to use dates (or should
    use the DisclosurePeriodEndDate) as some entries are missing dates
    and will be ignored when using `search_returns()` with a date.
