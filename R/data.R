#' Associated entities annual returns
#'
#' @docType data
"returns_associatedentity"

#' Third party expenditure returns
#'
#' @docType data
"returns_thirdparty"

#' Political campaigner returns
#'
#' @docType data
"returns_campaigner"

#' Parties annual returns
#'
#' Annual returns filed by political parties (1998-99 to 2018-19).
#'
#' Data is by financial year and is published by the AEC at the beginning of the February following the financial year.
#'
#' Note that the data have been taken directly from AEC website and thus contain the AEC's idiosyncrasies and very occasional errors.
#'
#' Some data (addresses of parties) has been merged from the CSV files the \href{https://transparency.aec.gov.au/Download}{AEC provides}.
#'
#'@format A \code{data.frame} with 1717 rows and 24 variables:
#' \describe{
#'   \item{ViewName}{String of "Political Party Annual Return".}
#'   \item{ReturnTypeCode}{String of "federalpoliticalparty".}
#'   \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'   \item{ReturnId}{Unique code for each individual return (Int) -- Not clear why both this and \code{RegistrationCode} both exist but may be an internal AEC thing.}
#'   \item{FinancialYear}{Financial year of the return in the format of \code{YYYY-YY}.}
#'   \item{DisclosurePeriodEndDate}{End date of the financial year as a date object (easier to use for plotting).}
#'   \item{ReturnTypeDescription}{String of "Political Party Return".}
#'   \item{ClientFileId}{Unique identifier of the party filing the return (Int).}
#'   \item{CurrentClientName}{Name that the party filed the current return under (Chr).}
#'   \item{ReturnClientName}{Party name that should be consistent across the dataset (Chr).}
#'   \item{PartyGroupId}{If the party is a member of a party group, the ID code of that group (Int).}
#'   \item{PartyGroupName}{If the party is a member of a party group, the name of that group (Chr).}
#'   \item{TotalReceipts}{Total reported recipts, in whole Australian dollars (Int).}
#'   \item{TotalPayments}{Total reported payments, in whole Australian dollars (Int).}
#'   \item{TotalDebts}{Total reported debts, in whole Australian dollars (Int).}
#'   \item{DetailsOfReceiptsTotal}{Total of receipts listed for the return in \code{\link{returns_receipts_details}} data file (Int),}
#'   \item{DetailsOfDebtsTotal}{Total of debts listed for the return in \code{\link{returns_receipts_details}} data file (Int),}
#'   \item{DetailsOfDiscretionaryBenefitsTotal}{Total of discretionary benefits listed for the return in \code{\link{returns_receipts_details}} data file (Int),}
#'   \item{AddressLine1}{Address line 1 (merged from CSV file) (Chr).}
#'   \item{AddressLine2}{Address line 2 -- often blank (merged from CSV file) (Chr).}
#'   \item{Suburb}{Suburb (merged from CSV file) (Chr).}
#'   \item{State}{State abbreviation (merged from CSV file) (Chr).}
#'   \item{Postcode}{Postcode (merged from CSV file) (Int).}
#' }
#' @source \url{https://transparency.aec.gov.au/AnnualPoliticalParty}
#' @docType data
"returns_party"

#' Donor annual returns
#'
#' @docType data
"returns_donor"

#' Donor annual returns addresses
#'
#' AEC-provided addresses for the donors listed in the \code{returns_donor} file.
#'
#' The AEC provides CSV files with the addresses of donors who have made returns, however because those records in the CSV files do not have unique identifiers it is not possible to definitively match the addresses to the records in the \code{returns_donor} data.
#'
#' As of the 2018-19 data, matching on \code{c("FinancialYear", "CurrentClientName", "TotalDonationsReceived"))} duplicates about 40-odd records (or about 11,000), which may be sufficient precision, depending on what you want to do.
#'
#' The formatting of donors from outside Australia is inconsistent, but they can generally be picked up by filter on \code{is.na(Postcode)}.
#'
#'@format A \code{data.frame} with 11166 rows and 10 variables:
#' \describe{
#'   \item{FinancialYear}{Financial year of the return in the format of \code{YYYY-YY}.}
#'   \item{CurrentClientName}{Name that the party filed the current return under (Chr).}
#'   \item{AddressLine1}{Address line 1(Chr).}
#'   \item{AddressLine2}{Address line 2 -- often blank(Chr).}
#'   \item{Suburb}{Suburb (Chr).}
#'   \item{State}{State abbreviation (Chr).}
#'   \item{Postcode}{Postcode (Int).}
#'   \item{LodgedOnBehalfOf}{Usually blank (Chr).}
#'   \item{TotalDonationsMade}{Total reported donations, in whole Australian dollars (Int).}
#'   \item{TotalDonationsReceived}{Total reported receipts, in whole Australian dollars (Int).}
#' }
#' @source \url{https://transparency.aec.gov.au/Download}
#' @docType data
"returns_donor_address"

#' Donations made details
#'
#' Itemised details of receipts from political donors (1998-99 to 2018-19).
#'
#' Part XX of the Commonwealth Electoral Act 1918 requires all donors to set
#' out the details of all receipts above the disclosure threshold each
#' financial year.
#'
#' These details set out:
#'
#' * the name of the person/entity that provided the funds
#' * the address of the person/entity
#' * the amount donated
#' * the date on which the donation was made
#'
#' All detailed receipts disclosed on political party, political campaigner
#' and associated entity returns from 1998-99 to 2018-19 are listed.
#'
#' Note that recipients, who are identfied by name (\code{CurrentClientName}
#' and \code{ReturnClientName}) or ID (\code(ClientFileId)), may or may not
#' be a political party, as indicated by \code{DonationMadeToClientType}. As
#' such matches may need to be made across one of a number of datasets
#' (\code{\link{returns_party}}, \code{\link{returns_campaigner}},
#' \code{\link{returns_thirdparty}} or \code{\link{returns_associatedentity}}).
#'
#'@format A \code{data.frame} with 53477 rows and 15 variables:
#' \describe{
#'   \item{ViewName}{String of "Annual Donor Donation Made" (Chr).}
#'   \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'   \item{ReturnId}{Unique code for each individual return (Int) -- Not clear why both this and \code{RegistrationCode} both exist but may be an internal AEC thing.}
#'   \item{ReturnTypeCode}{String of either "federaldonororganisation" or "federaldonorindividual" (Chr).}
#'   \item{ReturnTypeDescription}{String of either "Organisation Donor Return" or "Individual Donor Return" (Chr).}
#'   \item{FinancialYear}{Financial year of the return in the format of \code{YYYY-YY}.}
#'   \item{ClientFileId}{Unique identifier of the party filing the return (Int).}
#'   \item{CurrentClientName}{Name that the donor filed the current return under (Chr).}
#'   \item{ReturnClientName}{Donor name that should be consistent across the dataset (Chr).}
#'   \item{DonationMadeToName}{Name of recipient of donation as written on return (Chr).}
#'   \item{DonationMadeToClientFileId}{ID of recipient (Int).}
#'   \item{DonationMadeToClientType}{String of one of "politicalparty", "politicalcampaigner", "thirdparty", "general", "associatedentity" or "organisationdonor". Used to determine the appropriate dataset to search for \code{ClientFileId} of recipient (Chr).}
#'   \item{TransactionDate}{Date object of transaction date (Date).}
#'   \item{Amount}{Donation amount in whole Australian dollars (Int).}
#'   \item{FinancialRecordType}{A string of either "donationmade" or "campaignerdonation" (Chr).}
#' }
#'
#' @source \url{https://transparency.aec.gov.au/AnnualDonor}
#' @docType data
"returns_donor_details"

#' Detailed receipts
#'
#' Itemised details of receipts from annual returns of parties, political campaigners and associated entities.
#'
#' Part XX of the Commonwealth Electoral Act 1918 requires all political parties, political campaigners and associated entities to set out the details of all receipts above the disclosure threshold each financial year.
#'
#' These details set out:
#'
#' * the name of the person/entity that provided the funds
#' * the address of the person/entity
#' * the amount received from that person/entity
#' * the type of funds that were received
#'
#' All detailed receipts disclosed on political party, political campaigner and associated entity returns from 1998-99 onwards are listed.
#'
#' @source \url{https://transparency.aec.gov.au/AnnualDetailedReceipts}
#'
#' @docType data
"returns_receipts_details"
