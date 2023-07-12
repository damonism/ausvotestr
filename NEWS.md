# ausvotesTR Development Version

# ausvotesTR 0.4.1

## 12 July 2023

- Implemented a more intelligent way to detect and display changes to the 
  imported data files. Now suggests the `arsenal` package to do this.
- Updated the data to test the new import process.

## 11 July 2023

- Re-wrote the `search_donor_name()` function to make it more useful.

## 10 July 2023

- Added `search_donor_name()` function.
- Updated the data for consistency
- Fixed a couple of documentation errors.
- Added a pointer as to how to run the Shiny app.

## 6 July 2023

- Updated the data import script to run properly on Windows and fix some 
  deprecated functions.
- Updated the data.

## 31 March 2023

- Documentation updates

## 7 March 2023

- New data extract.

## 10 February 2023

- Added `search_returns_url()` function, to add a URL to the specific return on 
  the AEC website.
- Added a quick-and-dirty URL to the return on the AEC website to the table on 
  the Shiny app using the aforementioned function. Also added a recommendation
  for the `DT` package.

## 3 February 2023

- Added a variable to `return_receipts_details` to indicate if an amount is 
  public funding. I've done a bit of checking and I'm reasonably confident that
  it is correct, but it's also difficult to be 100% sure.

# ausvotesTR 0.4.0.1

## 3 February 2023

- The import script now reclassifies rows in `return_receipts_details` with 
  blank `ReceiptType` as "Unspecified". Adjust documentation to note this.
- Note in the documentation for `return_receipts_details` that there is also
  a `ReceiptType` category of "Third Party Gift" for third party returns.

# ausvotesTR 0.4

## 2 February 2023

- Imported the 2021-22 data (and modified the import script to record it).
- Fixed some of the CSV data that was causing conniptions for R CMD check 
  because it had an en-dash in it. 
- added `returns_mp`, a new returns type I'd failed to include, and documented
  it.
- Updated a bunch of documentation to reflect that the data was now up to 
  2021-22 and to fix some stuff that had got out of date.
- Updated the version number.

## 18 January 2023

- Vignette building now much less likely to crash due to memory issues.

# ausvotesTR 0.3.2

## 18 January 2023

- Another data update -- last one before the 2021-22 data is released.

# ausvotesTR 0.3.1

## 25 November 2022

- The AEC has now renamed the political campaigners dataset to significant 
  third parties, reflecting changes in legislation. The extract script and 
  the package documentation now reflects this.
- Updated the data 
- The CSVs in the AEC's zip file have changed. Updated check for these.


# ausvotesTR 0.3

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
