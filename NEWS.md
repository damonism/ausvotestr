# ausvotes 0.3

## 14 July 2022
- Updated the data
- Added election returns
- Added a `NEWS.md` file to track changes to the package.

# ausvotesTR 0.2.1

## 2 February 2022
- Big documentation update -- all of the data should now be properly documented
  and update the vignettes a bit.
- Small version number bump to 0.2.1

# ausvotes 0.2

## 1 February 2022
- Updated the data with the 2020-21 returns.
- Re-worked the import script to make it a bit more robust.

## 31 January 2022
- Updated the data with the final 2019-20 data (I guess).
- Updated the Examples vignette.

# ausvotesTR 0.1.8

## 1 September 2021
- Fixed some documentation, including clarifying when `TransactionDate` might 
  be missing for `returns_receipts_details` and `returns_donor_details`
- Fixed `search_returns()` to replace `TransactionDate` with 
  `DisclosurePeriodEndDate` when `TransactionDate` is missing when called with 
  the `from_date` option so that those records were not just silently 
  discarded. This is particularly important for the Shiny app as it always uses
  dates in its searches.
- Fixed the timezone in the Shiny App (who know 'AEST' was not a valid 
  timezone).
- Removed a lot of cruft from the data scraping process. This isn't exposed in
  the package but it makes my life a lot easier.
- Updated the data.

# ausvotesTR 0.1.7

## 2 June 2021
- New data extract
- Added [package documentation](https://r-pkgs.org/man.html#man-packages) for
  the package (including adding a `globalVariables()` definition for the data
  frames so the package will pass a `devtools::check()` cleanly -- there must
  be a better way to do this with data packages!)

## 18 May 2021
- New data extract
- Renamed all of the search functions to makes them easier to find.
- Rolled `search_returns_date()` functionality into `search_returns()`.
- Fixed `search_returns()` so that even if it produces a nil return the
  columns are the correct format so you can join them with something like
  `map_dfr()` or `lapply()`.
- The scraper now uses `use_data()` from `usethis`, where it has moved from
  `devtools`. This is not reflected in dependencies as the scraper is not
  actually included in the package.
- A few documentation tweaks. 

## 14 March 2021
- `returns_search()` and associated functions no longer returns an error when
  there isn't a hit on the search (now returns a zero-row `data.frame` with
  all of the appropriate columns)

## 9 March 2021

- `returns_search()` is now case-insensitive, which seems to make more
  sense.

## 7 March 2021

- Fixed some documentation bugs so it now builds cleanly.
- Vignettes still not showing up -- not sure why.

# ausvotesTR 0.1.5

## 2 February 2021

- Updated the data with the 2019-2020 returns
- Added summary tables to `transparency_register_scraper.R` in order to 
  provide some reassurance that the web scraping process continues to work
  properly (not yet complete for all tables)

# ausvotesTR 0.1.4

## 16 December 2020

- Added this ReadMe
- Added `DisclosurePeriodEndDate` to `returns_receipts_details`, 
  `returns_donor_details`
- Implemented a more memory efficient way to standardise the `FinancialYear` 
  field
- Update the data
- Moved search functions from the Shiny app and exported them
