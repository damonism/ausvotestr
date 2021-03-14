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
devtools::install_gitlab("damonism/ausvotesTR")
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

The current data in the package was extracted on 02 February 2021.

## Disclosure threshold

The disclosure threshold is CPI indexed anually. Donations below the
threshold may not be included in returns.

The disclosure threshold for each year was:

| FinancialYear | ReportingThreshold |
|:--------------|-------------------:|
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

## Changelog

### 14 March 2021

-   `returns_search()` and associated functions no longer returns an
    error when there isn’t a hit on the search (now returns a zero-row
    `data.frame` with all of the appropriate columns)

### 9 March 2021

-   `returns_search()` is now case-insensitive, which seems to make more
    sense.

### 7 March 2021

-   Fixed some documentation bugs so it now builds cleanly.
-   Vignettes still not showing up – not sure why.

### 2 February 2021

-   Updated the data with the 2019-2020 returns
-   Added summary tables to `transparency_register_scraper.R` in order
    to provide some reassurance that the web scraping process continues
    to work properly (not yet complete for all tables)
-   Bumped the version number to 0.1.5

### 16 December 2020

-   Added this ReadMe
-   Added `DisclosurePeriodEndDate` to `returns_receipts_details`,
    `returns_donor_details`
-   Implemented a more memory efficient way to standardise the
    `FinancialYear` field
-   Update the data
-   Moved search functions from the Shiny app and exported them
-   Updated version number to 0.1.4

## Todo

-   Combine `returns_search` and `returns_search_date`
