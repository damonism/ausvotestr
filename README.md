---
title: "ausvotesTR"
output: 
  html_document: 
    keep_md: yes
---



`ausvotesTR` is an R package of the data provided by the Australian Electoral Commission's (AEC) [Transparency Register](https://transparency.aec.gov.au/).

The package aims to be both easier to access than the data on the AEC's 
website, and also to provide linkages and metadata that is available on the 
AEC site, but isn't readily accessed.

Scripts to re-create all of the data used in the package are included in 
the `data-raw` folder.

The package also contains some convenience functions for analysing the data
and a Shiny app for quickly searching for donations by donors.

## Data extraction date

The [_Commonwealth Electoral Act 1918_](https://www.legislation.gov.au/Latest/C2019C00103) 
requires parties, associated entities, donors, third parties and political 
campaigners to submit an annual return with any donations above the
[disclosure threshold](https://www.aec.gov.au/Parties_and_Representatives/public_funding/threshold.htm) 
each financial year. Data extracted from the returns is then published on 
the first working day of the following February.

Regulated entities may submit an amendment to their returns to the AEC, and
the data in the package will reflect all of the returns and any amendments
at the time of extraction.

The current data in the package was extracted on 16 December 2020.

## Disclosure threshold

The disclosure threshold is CPI indexed anually. Donations below
the threshold may not be included in returns.

The disclosure threshold for each year was:

<table class="table" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> FinancialYear </th>
   <th style="text-align:right;"> ReportingThreshold </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> 2018-19 </td>
   <td style="text-align:right;"> 13,800 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2017-18 </td>
   <td style="text-align:right;"> 13,500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2016-17 </td>
   <td style="text-align:right;"> 13,200 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2015-16 </td>
   <td style="text-align:right;"> 13,000 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2014-15 </td>
   <td style="text-align:right;"> 12,800 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2013-14 </td>
   <td style="text-align:right;"> 12,400 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2012-13 </td>
   <td style="text-align:right;"> 12,100 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2011-12 </td>
   <td style="text-align:right;"> 11,900 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2010-11 </td>
   <td style="text-align:right;"> 11,500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2009-10 </td>
   <td style="text-align:right;"> 11,200 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2008-09 </td>
   <td style="text-align:right;"> 10,900 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2007-08 </td>
   <td style="text-align:right;"> 10,500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2006-07 </td>
   <td style="text-align:right;"> 10,300 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2005-06 </td>
   <td style="text-align:right;"> 1,500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2004-05 </td>
   <td style="text-align:right;"> 1,500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2003-04 </td>
   <td style="text-align:right;"> 1,500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2002-03 </td>
   <td style="text-align:right;"> 1,500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2001-02 </td>
   <td style="text-align:right;"> 1,500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 2000-01 </td>
   <td style="text-align:right;"> 1,500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1999-00 </td>
   <td style="text-align:right;"> 1,500 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> 1998-99 </td>
   <td style="text-align:right;"> 1,500 </td>
  </tr>
</tbody>
</table>

## Changelog

### 16 December 2020

- Added this ReadMe
- Added DisclosurePeriodEndDate to returns_receipts_details, returns_donor_details
- Implemented a more memory efficient way to standardise the FinancialYear field
- Update the data
- Moved search functions from the Shiny app and exported them
- Updated version number to 0.1.4

## Todo
- Combine `returns_search` and `returns_search_date`
