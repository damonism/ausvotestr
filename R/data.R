#' Associated entities annual returns
#'
#' Annual returns filed by associated entities (1998-99 to 2020-22).
#'
#' \href{https://www.aec.gov.au/Parties_and_Representatives/financial_disclosure/guides/associated-entities/index.htm}{According
#' to the AEC} persons or entities are required to register as an associated
#' entity if any of the following apply in a financial year:
#'
#' \itemize{
#'
#'
#' \item{the entity is controlled by one or more registered political parties;}
#'
#' \item{the entity is a financial member of a registered political party;}
#'
#' \item{another person is a financial member of a registered political party on
#' behalf of the entity;}
#'
#' \item{the entity has voting rights in a registered political party;}
#'
#' \item{another person has voting rights in a registered political party on
#' behalf of the entity;}
#'
#' \item{the entity operates wholly, or to a significant extent, for the benefit
#' of one or more disclosure entities, and the benefit relates to one or more
#' electoral activities (whether or not the electoral activities are undertaken
#' during an election period).}
#'
#' }
#'
#' Examples of associated entities include '500 clubs', 'think tanks',
#' registered clubs, service companies, trade unions and corporate party
#' members.
#'
#' Data is by financial year and is published by the AEC at the beginning of the
#' February following the financial year.
#'
#' Note that the data have been taken directly from AEC website and thus contain
#' the AEC's idiosyncrasies and very occasional errors.
#'
#' @format A \code{data.frame} with 27 variables:
#'
#'   \describe{
#'
#'   \item{ViewName}{String containing the year and "Associated Entity Annual
#'   Return".}
#'
#'   \item{ReturnTypeCode}{String of "federalassociatedentity".}
#'
#'   \item{DisclosurePeriodEndDate}{End date of the financial year as a date
#'   object (easier to use for plotting).}
#'
#'   \item{ClientFileId}{Unique identifier of the associated entity filing the
#'   return (Int).}
#'
#'   \item{DetailsOfCapitalContributionsTotal}{Where an associated entity paid
#'   an amount during a financial year to or for the benefit of one or more
#'   political party and the amount was paid out of funds generated from the
#'   capital of the associated entity the associated entity must disclose
#'   deposits of capital received since 16 June 1995.}
#'
#'   \item{DetailsOfDebtsTotal}{Total of debts listed for the return in
#'   \code{\link{returns_receipts_details}} data file (Int),}
#'
#'   \item{DetailsOfReceiptsTotal}{Total of receipts listed for the return in
#'   \code{\link{returns_receipts_details}} data file (Int),}
#'
#'   \item{DetailsOfDiscretionaryBenefitsTotal}{Total of discretionary benefits
#'   listed for the return in \code{\link{returns_receipts_details}} data file
#'   (Int),}
#'
#'   \item{DetailsOfReceiptsTotal}{Total of receipts listed for the return in
#'   \code{\link{returns_receipts_details}} data file (Int),}
#'
#'   \item{ReportingThreshold}{The threshold, in whole Australian follars, above
#'   which donations must be reported in that reporting period (Int).}
#'
#'   \item{ReturnId}{Unique code for each individual return (Int) -- It is not
#'   clear why both this and \code{RegistrationCode} both exist but may be for
#'   internal AEC use.}
#'
#'   \item{TotalDebts}{Total reported debts, in whole Australian dollars (Int).}
#'
#'   \item{TotalPayments}{Total reported payments, in whole Australian dollars
#'   (Int).}
#'
#'   \item{TotalReceipts}{Total reported receipts, in whole Australian dollars
#'   (Int).}
#'
#'   \item{AssociatedParties}{The parties with which the entity is associated.
#'   If more than one, they will be separated with a semicolon (\code{;}). These
#'   are also available in long format in
#'   \link{returns_associatedentity_associatedparty}.}
#'
#'   \item{AssociatedPartiesFormatted}{As per \code{AssociatedParties} but the
#'   parties are separated with a \code{<br/>} string.}
#'
#'   \item{ClientFileIdsOfAssociatedParties}{The \code{ClientFileId} of any
#'   associated parties. If more than one, they are separated with a semicolon
#'   (\code{;}). These are also available in long format in
#'   \link{returns_associatedentity_associatedparty}.}
#'
#'   \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'
#'   \item{LodgedOnBehalfOf}{Any unions or body corporate the return has been
#'   lodged on behalf of. This field is often blank (but not \code{NA}). Where
#'   there is more than one entity the return has been lodged on behalf of,
#'   these will be separated with a \code{<br/>} string.}
#'
#'   \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'
#'   \item{CurrentClientName}{Name that the associated entity filed the current
#'   return under (Chr).}
#'
#'   \item{ReturnClientName}{Associated entity name that should be consistent
#'   across the dataset (Chr).}
#'
#'   \item{ReturnTypeDescription}{String of "Associated Entity Return".}
#'
#'   \item{AddressLine1}{Address line 1 (merged from CSV file) (Chr).}
#'
#'   \item{AddressLine2}{Address line 2 -- often blank (merged from CSV file)
#'   (Chr).}
#'
#'   \item{Suburb}{Suburb (merged from CSV file) (Chr).}
#'
#'   \item{State}{State abbreviation (merged from CSV file) (Chr).}
#'
#'   \item{Postcode}{Postcode (merged from CSV file) (Int).}
#'
#'   \item{FinancialYear}{Financial year of the return in the format of
#'   \code{YYYY-YY}.} }
#'
#' @source \url{https://transparency.aec.gov.au/AnnualAssociatedEntity}
#' @docType data
"returns_associatedentity"

#' Associated parties of associated entities
#'
#' An associated entity may have multiple associated parties, which are listed
#' in this \code{data.frame} and can be merged back into the
#' \link{returns_associatedentity} table by joining on \code{RegistrationCode}.
#'
#' The primary source of this data is the \link{returns_associatedentity} table.
#'
#' @format A \code{data.frame} with 4 variables:
#' \describe{
#'   \item{FinancialYear}{Financial year of the return in the format of
#'         \code{YYYY-YY}.}
#'   \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'   \item{AssociatedParties}{A party with which the entity is associated.}
#'   \item{ClientFileId}{Unique identifier of the associated party.}
#' }
#'
#' @source \url{https://transparency.aec.gov.au/AnnualAssociatedEntity}
#' @docType data
"returns_associatedentity_associatedparty"

#' Third party expenditure returns
#'
#' Annual returns from third parties, from the 2006-07 to the 2020-22 financial
#' years.
#'
#' Part XX of the
#' \href{https://www.legislation.gov.au/Latest/C2019C00103}{Commonwealth
#' Electoral Act 1918} requires all third parties that incurred electoral
#' expenditure above the disclosure threshold, to lodge financial disclosure
#' returns on an annual basis.
#'
#' These returns set out for that financial year:
#'
#' \itemize{
#'
#' \item{the total amount of electoral expenditure incurred}
#'
#' \item{the details of any donations above the disclosure threshold that the
#' third party received, and used to incur that electoral expenditure.} }
#'
#' Returns for financial years that ended before 1 January 2019 required third
#' parties to break down the total electoral expenditure into five distinct
#' categories, which are detailed on those returns.
#'
#' @format A \code{data.frame} with 20 variables: \describe{
#'   \item{ViewName}{String of "Third Party Return".}
#'
#'   \item{ReturnTypeCode}{String of "federalthirdparty".}
#'
#'   \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'
#'   \item{ReturnId}{Unique code for each individual return (Int) -- It is not
#'   clear why both this and \code{RegistrationCode} both exist but may be for
#'   internal AEC use.}
#'
#'   \item{ReportingThreshold}{The threshold, in whole Australian follars, above
#'   which donations must be reported in that reporting period (Int).}
#'
#'   \item{ReturnTypeDescription}{String of "Third Party Return".}
#'
#'   \item{ReturnClientName}{Third party name that should be consistent across
#'   the dataset (Chr).}
#'
#'   \item{CurrentClientName}{Name that the third party filed the current return
#'   under (Chr).}
#'
#'   \item{TotalPublicExpressionPartyCandidate}{Expenditure on public expression
#'   of views on a political party or candidate (not used since 2019).}
#'
#'   \item{TotalPrintingAndProduction}{Expenditure on printing or publication
#'   (not used since 2019).}
#'
#'   \item{TotalBroadcast}{Expenditure on broadcasting (not used since 2019).}
#'
#'   \item{TotalOpinionPolling}{Expenditure on polling (not used since 2019).}
#'
#'   \item{TotalPublicExpressionOtherIssue}{Expenditue on public expression of
#'   views on an issue (not used since 2019).}
#'
#'   \item{TotalElectoralExpenditure}{Total electoral expenditure, in whole
#'   Australian dollars (Int).}
#'
#'   \item{TotalExpenditure}{Total expenditure, in whole Australian dollars
#'   (Int). From 2019 \code{TotalExpenditure} should equal
#'   \code{TotalElectoralExpenditure} as that is the only reportable
#'   expenditure.}
#'
#'   \item{TotalGifts}{Total amount of gifts (donations) received for electoral
#'   expenditure, in whole Australian dollars (Int).}
#'
#'   \item{LodgedOnBehalfOf}{Any unions or body corporate the return has been
#'   lodged on behalf of. This field is often blank (but not \code{NA}). Where
#'   there is more than one entity the return has been lodged on behalf of,
#'   these will be separated with a \code{<br/>} string.}
#'
#'   \item{FinancialYear}{Financial year of the return in the format of
#'   \code{YYYY-YY}.} }
#'
#' @source \url{https://transparency.aec.gov.au/AnnualThirdParty}
#' @docType data
"returns_thirdparty"

#'Significant third party returns
#'
#'Annual returns from significant third parties (from the 2018-19 to the 2020-22
#'financial years.)
#'
#'Part XX of the
#'\href{https://www.legislation.gov.au/Latest/C2019C00103}{Commonwealth
#'Electoral Act 1918} requires all registered significant third partied to lodge
#'financial disclosure returns on an annual basis. Significant third parties
#'were previously called political campaigners, however the name was changed in
#'the legislation. The name of the data reflects the name of the category when
#'it was first introduced into the legislation so as not to break any existing
#'usage.
#'
#'These returns set out for that financial year:
#'
#'\itemize{
#'
#'\item{the total value of receipts}
#'
#'\item{the details of amounts received that are more than the disclosure
#'threshold}
#'
#'\item{the total value of payments}
#'
#'\item{the total value of debts as at 30 June}
#'
#'\item{the details of debts outstanding as at 30 June that total more than the
#'disclosure threshold}
#'
#'\item{the total amount of electoral expenditure incurred}
#'
#'\item{the details of any discretionary benefits received from the
#'Commonwealth, State or Territory.}
#'
#'}
#'
#'Political campaigners were first required to lodge returns for the 2018-19
#'financial year and all lodged returns are listed.
#'
#'@format A \code{data.frame} with 20 variables:
#'
#'  \describe{
#'
#'  \item{ViewName}{String of "Significant Third Party Return".}
#'
#'  \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'
#'  \item{ReturnId}{Unique code for each individual return (Int) -- It is not
#'  clear why both this and \code{RegistrationCode} both exist but may be for
#'  internal AEC use.}
#'
#'  \item{DisclosurePeriodEndDate}{End date of the financial year as a date
#'  object (easier to use for plotting).}
#'
#'  \item{ReportingThreshold}{The threshold, in whole Australian dollars, above
#'  which donations must be reported in that reporting period (Int).}
#'
#'  \item{ReturnTypeDescription}{String of "Political Campaigner Return".}
#'
#'  \item{ReturnTypeCode}{String of "federalpoliticalcampaigner".}
#'
#'  \item{ClientFileId}{Unique identifier of the campaigner filing the return
#'  (Int).}
#'
#'  \item{CurrentClientName}{Name that the campaigner filed the current return
#'  under (Chr).}
#'
#'  \item{ReturnClientName}{Campaigner name that should be consistent across the
#'  dataset (Chr).}
#'
#'  \item{TotalReceipts}{Total reported receipts, in whole Australian dollars
#'  (Int).}
#'
#'  \item{TotalPayments}{Total reported payments, in whole Australian dollars
#'  (Int).}
#'
#'  \item{TotalDebts}{Total reported debts, in whole Australian dollars (Int).}
#'
#'  \item{TotalElectoralExpenditure}{Total electoral expenditure, in whole
#'  Australian dollars (Int).}
#'
#'  \item{LodgedOnBehalfOf}{Any unions or body corporate the return has been
#'  lodged on behalf of. This field is often blank (but not \code{NA}). Where
#'  there is more than one entity the return has been lodged on behalf of, these
#'  will be separated with a \code{<br/>} string.}
#'
#'  \item{DetailsOfReceiptsTotal}{Total of receipts listed for the return in
#'  \code{\link{returns_receipts_details}} data file (Int),}
#'
#'  \item{DetailsOfDebtsTotal}{Total of debts listed for the return in
#'  \code{\link{returns_receipts_details}} data file (Int),}
#'
#'  \item{DetailsOfDiscretionaryBenefitsTotal}{Total of discretionary benefits
#'  listed for the return in \code{\link{returns_receipts_details}} data file
#'  (Int),}
#'
#'  \item{AddressLine1}{Address line 1 (merged from CSV file) (Chr).}
#'
#'  \item{AddressLine2}{Address line 2 -- often blank (merged from CSV file)
#'  (Chr).}
#'
#'  \item{Suburb}{Suburb (merged from CSV file) (Chr).}
#'
#'  \item{State}{State abbreviation (merged from CSV file) (Chr).}
#'
#'  \item{Postcode}{Postcode (merged from CSV file) (Int).}
#'
#'  \item{FinancialYear}{Financial year of the return in the format of
#'  \code{YYYY-YY}.}
#'
#'  }
#'
#'@source \url{https://transparency.aec.gov.au/AnnualSignificantThirdParty}
#'
#'@docType data
"returns_campaigner"


#' MP and Senator Returns
#'
#' Member of the House of Representatives and Senator returns (from the 2020-21
#' to the 2021-22 financial years).
#'
#' Members of the House of Representatives (MP) or Senators who receive one or
#' more gifts during a financial year that were made for federal purposes must
#' lodge an annual disclosure return.
#'
#' A federal purpose means the purpose of incurring electoral expenditure, or
#' creating or communicating electoral matter.
#'
#' The MP or Senator is responsible for lodging the annual return. However, an
#' MP or Senator may authorise another person to provide the return on their
#' behalf.
#'
#' NOTE: If an MP or Senator did not receive any gifts during the financial year
#' that were made for federal purposes, a return does not need to be provided.
#'
#' @format A \code{data.frame} with 14 variables.
#'
#'   \describe{
#'
#'   \item{ViewName}{String of "Member of Parliament Return".}
#'
#'   \item{ReturnTypeCode}{String of either "federalmemberofhor" or
#'   "federalsenator".}
#'
#'   \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'
#'   \item{ReturnId}{Unique code for each individual return (Int) -- It is not
#'   clear why both this and \code{RegistrationCode} both exist but may be for
#'   internal AEC use.}
#'
#'   \item{FinancialYear}{Financial year of the return in the format of
#'   \code{YYYY-YY}.}
#'
#'   \item{DisclosurePeriodEndDate}{End date of the financial year as a date
#'   object (easier to use for plotting).}
#'
#'   \item{ReportingThreshold}{The threshold, in whole Australian dollars, above
#'   which donations must be reported in that reporting period (Int).}
#'
#'   \item{ReturnTypeDescription}{String of either "Member of House of
#'   Representatives Return" or "Senator Return".}
#'
#'   \item{ClientFileId}{Unique identifier of the campaigner filing the return
#'   (Int).}
#'
#'   \item{CurrentClientName}{Name that the campaigner filed the current return
#'   under (Chr).}
#'
#'   \item{ReturnClientName}{Campaigner name that should be consistent across
#'   the dataset (Chr).}
#'
#'   \item{NumberOfDonors}{Number of individual donors reported by MP or senator
#'   (note that the details of the individual donors, if any, are in
#'   \code{\link{returns_receipts_details}}).}
#'
#'   \item{TotalGiftValue}{Aggregate of all donations (note that the details of
#'   the individual donors, if any, are in
#'   \code{\link{returns_receipts_details}}).}
#'
#'   \item{ClientType}{String of either "memberofhor" or "senator".}
#'
#'   }
#'
#' @source \url{https://transparency.aec.gov.au/MemberOfParliament}
#'
#' @docType data
"returns_mp"

#' Parties annual returns
#'
#' Annual returns filed by political parties (1998-99 to 2020-22).
#'
#' Data is by financial year and is published by the AEC at the beginning of
#' the February following the financial year.
#'
#' Note that the data have been taken directly from AEC website and thus
#' contain the AEC's idiosyncrasies and very occasional errors.
#'
#' Some data (addresses of parties) has been merged from the CSV files the
#' \href{https://transparency.aec.gov.au/Download}{AEC provides}.
#'
#'@format A \code{data.frame} with 24 variables:
#' \describe{
#'   \item{ViewName}{String of "Political Party Annual Return".}
#'   \item{ReturnTypeCode}{String of "federalpoliticalparty".}
#'   \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'   \item{ReturnId}{Unique code for each individual return (Int) -- It is not
#'         clear why both this and \code{RegistrationCode} both exist but may
#'         be for internal AEC use.}
#'   \item{ReturnTypeDescription}{String of "Political Party Return".}
#'   \item{ClientFileId}{Unique identifier of the party filing the return
#'         (Int).}
#'   \item{CurrentClientName}{Name that the party filed the current return under
#'         (Chr).}
#'   \item{ReturnClientName}{Party name that should be consistent across the
#'         dataset (Chr).}
#'   \item{PartyGroupId}{If the party is a member of a party group, the ID code
#'         of that group (Int).}
#'   \item{PartyGroupName}{If the party is a member of a party group, the name
#'         of that group (Chr).}
#'   \item{TotalReceipts}{Total reported receipts, in whole Australian dollars
#'         (Int).}
#'   \item{TotalPayments}{Total reported payments, in whole Australian dollars
#'         (Int).}
#'   \item{TotalDebts}{Total reported debts, in whole Australian dollars (Int).}
#'   \item{DetailsOfReceiptsTotal}{Total of receipts listed for the return in
#'         \code{\link{returns_receipts_details}} data file (Int),}
#'   \item{DetailsOfDebtsTotal}{Total of debts listed for the return in
#'         \code{\link{returns_receipts_details}} data file (Int),}
#'   \item{DetailsOfDiscretionaryBenefitsTotal}{Total of discretionary benefits
#'         listed for the return in \code{\link{returns_receipts_details}} data
#'         file (Int),}
#'   \item{AddressLine1}{Address line 1 (merged from CSV file) (Chr).}
#'   \item{AddressLine2}{Address line 2 -- often blank (merged from CSV file)
#'         (Chr).}
#'   \item{Suburb}{Suburb (merged from CSV file) (Chr).}
#'   \item{State}{State abbreviation (merged from CSV file) (Chr).}
#'   \item{Postcode}{Postcode (merged from CSV file) (Int).}
#'   \item{FinancialYear}{Financial year of the return in the format of
#'         \code{YYYY-YY}.}
#' }
#' @source \url{https://transparency.aec.gov.au/AnnualPoliticalParty}
#' @docType data
"returns_party"

#' Donor annual returns
#'
#' List of annual returns from political donors (1998-99 to 2020-22),
#'
#' During the period covered by this data the reporting requirements in the
#' Commonwealth Electoral Act 1918 changed, which led to the discrepancy
#' between the \code{TotalDonationsMadeToPoliticalPartiesAndCampaigners} and
#' \code{TotalDonationsMadeToPoliticalParties} variables.
#'
#'@format A \code{data.frame} with 16 variables:
#' \describe{
#'   \item{ViewName}{String of "Donor Return" (Chr).}
#'   \item{ReturnTypeCode}{String of either "federaldonororganisation" or "federaldonorindividual" (Chr).}
#'   \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'   \item{ReturnId}{Unique code for each individual return (Int) -- Not clear why both this and \code{RegistrationCode} both exist but may be an internal AEC thing.}
#'   \item{DisclosurePeriodEndDate}{End date of the financial year as a date object (easier to use for plotting) (Date).}
#'   \item{ReportingPeriodThreshold}{The threshold, in whole Australian follars, above which donations must be reported in that reporting period (Int).}
#'   \item{ReturnTypeDescription}{String of either "Organisation Donor Return" or "Individual Donor Return" (Chr).}
#'   \item{ClientFileId}{Unique identifier of the party filing the return (Int).}
#'   \item{CurrentClientName}{Name that the party filed the current return under (Chr).}
#'   \item{ReturnClientName}{Party name that should be consistent across the dataset (Chr).}
#'   \item{TotalDonationsMadeToPoliticalPartiesAndCampaigners}{Sum of donations to political parties and political campaigners, in whole Australian dollars (Int).}
#'   \item{TotalDonationsMadeToPoliticalParties}{Sum of donations to political parties, in whole Australian dollars (Int).}
#'   \item{TotalDonationsMadeToPoliticalCampaigners}{Sum of donations to political campaigners (the legislative requirement to report this was only introduced in 2018-19) (Int).}
#'   \item{TotalDonationsReceived}{Sum of donations received, in whole Australian dollars (Int).}
#'   \item{LodgedOnBehalfOf}{Usually blank (Chr).}
#'   \item{FinancialYear}{Financial year of the return in the format of \code{YYYY-YY} (Chr).}
#' }
#' @source \url{https://transparency.aec.gov.au/AnnualDonor}
#' @docType data
"returns_donor"

#' Donor annual returns addresses
#'
#' AEC-provided addresses for the donors listed in the \code{returns_donor} file.
#'
#' The AEC provides CSV files with the addresses of donors who have made
#' returns, however because those records in the CSV files do not have unique
#' identifiers it is not possible to definitively match the addresses to the
#' records in the \code{returns_donor} data.
#'
#' As of the 2018-19 data, matching on \code{c("FinancialYear",
#' "CurrentClientName", "TotalDonationsReceived"))} duplicates about 40-odd
#' records (or about 11,000), which may be sufficient precision, depending on
#' what you want to do.
#'
#' The formatting of donors from outside Australia is inconsistent, but they
#' can generally be picked up by filter on \code{is.na(Postcode)}.
#'
#'@format A \code{data.frame} with 10 variables:
#' \describe{
#'   \item{CurrentClientName}{Name that the party filed the current return
#'         under (Chr).}
#'   \item{AddressLine1}{Address line 1(Chr).}
#'   \item{AddressLine2}{Address line 2 -- often blank(Chr).}
#'   \item{Suburb}{Suburb (Chr).}
#'   \item{State}{State abbreviation (Chr).}
#'   \item{Postcode}{Postcode (Int).}
#'   \item{LodgedOnBehalfOf}{Usually blank (Chr).}
#'   \item{TotalDonationsMade}{Total reported donations, in whole Australian
#'         dollars (Int).}
#'   \item{TotalDonationsReceived}{Total reported receipts, in whole Australian
#'         dollars (Int).}
#'   \item{FinancialYear}{Financial year of the return in the format of
#'         \code{YYYY-YY}.}
#' }
#' @source \url{https://transparency.aec.gov.au/Download}
#' @docType data
"returns_donor_address"

#' Donations made details
#'
#' Itemised details of receipts from political donors (1998-99 to 2020-22).
#'
#' Part XX of the Commonwealth Electoral Act 1918 requires all donors to set out
#' the details of all receipts above the disclosure threshold each financial
#' year.
#'
#' These details set out:
#'
#' \itemize{
#'
#' \item{the name of the person/entity that provided the funds}
#'
#' \item{the address of the person/entity}
#'
#' \item{the amount donated}
#'
#' \item{the date on which the donation was made (however the date is missing
#' for unknown reasons in a very small proportion of the entries)}
#'
#' }
#'
#' All detailed receipts disclosed on political party, political campaigner and
#' associated entity returns from 1998-99 to 2018-19 are listed.
#'
#' Note that recipients, who are identified by name (\code{CurrentClientName}
#' and \code{ReturnClientName}) or ID (\code{ClientFileId}), may or may not be a
#' political party, as indicated by \code{DonationMadeToClientType}. As such
#' matches may need to be made across one of a number of datasets
#' (\code{\link{returns_party}}, \code{\link{returns_campaigner}},
#' \code{\link{returns_thirdparty}}, \code{\link{returns_mp}} or
#' \code{\link{returns_associatedentity}}).
#'
#' @format A \code{data.frame} 16 variables:
#'
#'   \describe{
#'
#'
#'   \item{ViewName}{String of "Annual Donor Donation Made" (Chr).}
#'
#'   \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'
#'   \item{ReturnId}{Unique code for each individual return (Int) -- It is not
#'   clear why both this and \code{RegistrationCode} both exist but may be for
#'   internal AEC use}
#'
#'   \item{ReturnTypeCode}{String of either "federaldonororganisation",
#'   "federaldonorindividual" (Chr).}
#'
#'   \item{ReturnTypeDescription}{String of either "Organisation Donor Return"
#'   or "Individual Donor Return" (Chr).}
#'
#'   \item{ClientFileId}{Unique identifier of the party filing the return
#'   (Int).}
#'
#'   \item{CurrentClientName}{Name that the donor filed the current return under
#'   (Chr).}
#'
#'   \item{ReturnClientName}{Donor name that should be consistent across the
#'   dataset (Chr).}
#'
#'   \item{DonationMadeToName}{Name of recipient of donation as written on
#'   return (Chr).}
#'
#'   \item{DonationMadeToClientFileId}{ID of recipient (Int). This can be joined
#'   with \code{ClientFileId} from \link{returns_party} to get
#'   \code{PartyGroupName}, which is usually more useful than
#'   \code{DonationMadeToName} in this table.}
#'
#'   \item{DonationMadeToClientType}{String of one of "politicalparty",
#'   "politicalcampaigner", "thirdparty", "general", "associatedentity" or
#'   "organisationdonor". Used to determine the appropriate dataset to search
#'   for \code{ClientFileId} of recipient (Chr).}
#'
#'   \item{TransactionDate}{Date object of transaction date (Date). Note that a
#'   small proportion of entries (around 100) do not include a date (ie., the
#'   data will be \code{NA}), and filtering by date will therefore exclude these
#'   entries.}
#'
#'   \item{Amount}{Donation amount in whole Australian dollars (Int).}
#'
#'   \item{FinancialRecordType}{A string of either "donationmade" or
#'   "campaignerdonation" (Chr).}
#'
#'   \item{FinancialYear}{Financial year of the return in the format of
#'   \code{YYYY-YY}.}
#'
#'   \item{DisclosurePeriodEndDate}{End date of the financial year as a date
#'   object (easier to use for plotting) (Date).}
#'
#'   }
#'
#' @source \url{https://transparency.aec.gov.au/AnnualDonor}
#' @docType data
"returns_donor_details"

#' Detailed receipts
#'
#' Itemised details of receipts from annual returns of parties, political
#' campaigners and associated entities.
#'
#' Part XX of the Commonwealth Electoral Act 1918 requires all political
#' parties, political campaigners and associated entities to set out the details
#' of all receipts above the disclosure threshold each financial year.
#'
#' These details set out:
#'
#' \itemize{
#'
#' \item{the name of the person/entity that provided the funds}
#'
#' \item{the address of the person/entity}
#'
#' \item{the amount received from that person/entity}
#'
#' \item{the type of funds that were received}
#'
#' }
#'
#' The details of the following returns are found in this dataset (as per
#' \code{ReturnTypeDescription}):
#'
#' \itemize{
#'
#' \item{"Third Party Return"}
#'
#' \item{"Significant Third Party Return"}
#'
#' \item{"Political Party Return"}
#'
#' \item{"Organisation Donor Return"}
#'
#' \item{"Member of HOR Return"}
#'
#' \item{"Associated Entity Return"}
#'
#' \item{"Political Campaigner Return"}
#'
#' \item{"Individual Donor Return"}
#'
#' }
#'
#' All detailed receipts disclosed on political party, political campaigner and
#' associated entity returns from 1998-99 onwards are listed.
#'
#' Receipts may be listed in \code{ReceiptType} as donations ("Donation
#' Received") or as an "Other Receipt". Occasionally \code{ReceiptType} is
#' listed as a "Subscription", which are treated by the AEC (and the \emph{CEA})
#' as Other Receipts. Additionally, there is a \code{ReceiptType} of "Third
#' Party Gift", but these are only present in third party returns
#' (\link{returns_thirdparty}).
#'
#' There are around 125 rows where \code{ReceiptType} is blank in the original
#' AEC data, but most of them are older and most are not political party returns
#' and it is probably reasonably safe (and consistent with AEC practice) to
#' consider these to be donations. These blank rows have been converted to
#' "Unspecified" in the data import script.
#'
#' @format A \code{data.frame} with 20 variables:
#'
#'   \describe{
#'
#'   \item{ViewName}{String of "Annual Detailed Receipt" (Chr).}
#'
#'   \item{RegistrationCode}{Unique code for each individual return (Chr).}
#'
#'   \item{ReturnId}{Unique code for each individual return (Int) -- It is not
#'   clear why both this and \code{RegistrationCode} both exist but may be for
#'   internal AEC use.}
#'
#'   \item{ReturnTypeCode}{String of one of "federalthirdparty",
#'   "federalsignificantthirdparty", "federalpoliticalparty",
#'   "federaldonororganisation", "federalmemberofhor",
#'   "federalassociatedentity", "federalpoliticalcampaigner" or
#'   "federaldonorindividual" (Chr).}
#'
#'   \item{ReturnTypeDescription}{String of one of "Third Party Return",
#'   "Significant Third Party Return", "Political Party Return", "Organisation
#'   Donor Return", "Member of HOR Return", "Associated Entity Return",
#'   "Political Campaigner Return" or "Individual Donor Return" (Chr).}
#'
#'   \item{AmendmentNumber}{The number of times the return has been amended
#'   (Int).}
#'
#'   \item{UniqueReferenceNumber}{Unique code (as per \code{RegistrationCode})
#'   for each amendment of each return (Chr).}
#'
#'   \item{RecipientClientId}{Unique identifier (\code{ClientFileId} of the
#'   recipient of the donation (Int).}
#'
#'   \item{RecipientName}{Name of the receipient of the money (Chr).}
#'
#'   \item{RecipientClientType}{One of "Political Party", "Political
#'   Campaigner", "Third Party", "Organisation Donor" or "Associated Entity"
#'   (Chr).}
#'
#'   \item{PartyGroupId}{ID if party is a member of a party group (see
#'   \code{\link{party_by_group}}) (Int).}
#'
#'   \item{PoliticalPartyId}{List of IDs of political parties (List).}
#'
#'   \item{ReceivedFromClientName}{Name that the donor (Chr).}
#'
#'   \item{RecivedFromClientId}{\code{ClientFileId} of the donor (Int).}
#'
#'   \item{RecieptType}{One of "Donation Received", "Other Receipt",
#'   "Subscription", "Unspecified", "Third Party Gift" (only for third party
#'   returns) or "Public Funding" (note that "Public Funding" is always an
#'   "Other Receipt", and is generally not included in the more recent data)
#'   (Chr).}
#'
#'   \item{TransactionDate}{Date object of transaction date (Date). Note that a
#'   large proportion of entries \strong{do not include a date} (ie., the data
#'   will be \code{NA}), and filtering by date will therefore exclude a large
#'   amount of data.}
#'
#'   \item{Amount}{Donation amount in whole Australian dollars (Int).}
#'
#'   \item{PartyGroupName}{If party is a member of a party group, the name of
#'   the group (see \code{\link{party_by_group}}) (Chr).}
#'
#'   \item{FinancialYear}{Financial year of the return in the format of
#'   \code{YYYY-YY}.}
#'
#'   \item{DisclosurePeriodEndDate}{End date of the financial year as a date
#'   object (easier to use for plotting) (Date).} }
#'
#' @source \url{https://transparency.aec.gov.au/AnnualDetailedReceipts}
#'
#' @docType data
"returns_receipts_details"

#' Data update date
#'
#' The date and time the data was last updated, as a \code{POSIXct} object.
#'
#' This data is automatically generated each time the data is extracted.
#'
#' Note that the new returns data is only released on the first working day
#' of February for the previous financial year, however amendments may be made
#' to returns in the meantime. Data extracted after early February should
#' therefore generally not contain new returns, but may have some different
#' entries to the original data release.
#'
#'@format A \code{data.frame} with 1 row and 1 variable:
#' \describe{
#'   \item{Updated}{The date and time the data was last updated, as a
#'   \code{POSIXct} object.}
#' }
#'
#' @docType data
"returns_updated"

#' Candidate and group election returns
#'
#' @format A \code{data.frame} with 34 variables.
#'
#' @docType data
"election_candidates_returns"

#' Detailed receipts from candidate and group election returns
#'
#' @format A \code{data.frame} with 19 variables.
#'
#' @docType data
"election_donor_details"

#' Election donor returns
#'
#' @format A \code{data.frame} with 24 variables.
#'
#' @docType data
"election_donor_returns"

