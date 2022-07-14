library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)
library(usethis)

# This script imports all of the data from the AEC transparency register, located at:
#
# https://transparency.aec.gov.au/

tmp_FinancialYear <- read.table(header = TRUE, text = "
FinancialYear FinancialYearNew DisclosurePeriodEndDate
2020-21          2020-21              2021-06-30
2019-20          2019-20              2020-06-30
2018-19          2018-19              2019-06-30
2017-18          2017-18              2018-06-30
2016-17          2016-17              2017-06-30
2015-16          2015-16              2016-06-30
2014-15          2014-15              2015-06-30
2013-14          2013-14              2014-06-30
2012-13          2012-13              2013-06-30
2011-12          2011-12              2012-06-30
2010-2011          2010-11              2011-06-30
2009-2010          2009-10              2010-06-30
2008-2009          2008-09              2009-06-30
2007-2008          2007-08              2008-06-30
2006-2007          2006-07              2007-06-30
2005-2006          2005-06              2006-06-30
2004-2005          2004-05              2005-06-30
2003-2004          2003-04              2004-06-30
2002-2003          2002-03              2003-06-30
2001-2002          2001-02              2002-06-30
2000-2001          2000-01              2001-06-30
1999-2000          1999-00              2000-06-30
1998-1999          1998-99              1999-06-30
", stringsAsFactors = FALSE)

tmp_FinancialYear$DisclosurePeriodEndDate <- as.Date(as.character(tmp_FinancialYear$DisclosurePeriodEndDate))

get_returns_data <- function(page_url, json_url) {

  tmp_page <- GET(page_url)

  tmp_token <- strsplit(regmatches(content(tmp_page, "text"),
                                   regexpr("<input name=\"__RequestVerificationToken\".*?>", content(tmp_page, "text"))), "\"")[[1]][6]

  tmp_data <- POST(json_url, body =
                     paste0("__RequestVerificationToken=", tmp_token),
                   content_type("application/x-www-form-urlencoded"))

  tmp_returns <- fromJSON(content(tmp_data, "text"), flatten = TRUE)$Data

  if("DisclosurePeriodEndDate" %in% colnames(tmp_returns)) {
    tmp_returns$DisclosurePeriodEndDate <- as.Date(as.character(tmp_returns$DisclosurePeriodEndDate), format = "%Y-%m-%dT%H:%M:%S")
  }

  if("TransactionDate" %in% colnames(tmp_returns)) {
    tmp_returns$TransactionDate <- as.Date(as.character(tmp_returns$TransactionDate), format = "%Y-%m-%dT%H:%M:%S")
  }

  if("GiftDate" %in% colnames(tmp_returns)) {
    tmp_returns$GiftDate <- as.Date(as.character(tmp_returns$GiftDate), format = "%Y-%m-%dT%H:%M:%S")
  }

  return(tmp_returns)

}

#### Download the zip file with the addresses ####

tmp_zip <- tempfile()
download.file("https://transparency.aec.gov.au/Download/AllAnnualData", tmp_zip)
if(!dir.exists("data-raw/csv")) {
  dir.create("data-raw/csv")
}
unzip(tmp_zip, junkpaths = TRUE, exdir = "data-raw/csv")
unlink(tmp_zip)

csv_files <- list.files("data-raw/csv")

csv_files_expected <- c("Associated Entity Returns.csv", "Capital Contributions.csv", "Detailed Debts.csv",
                        "Detailed Discretionary Benefits.csv", "Detailed Receipts.csv", "Donations Made.csv",
                        "Donor Donations Received.csv", "Donor Returns.csv", "Party Returns.csv",
                        "Political Campaigner Returns.csv", "Third Party Donations Received.csv", "Third Party Returns.csv")

if(!setequal(csv_files, csv_files_expected)) {
  warning("CSV files in zipfile not as expected.")
}

#### Build the data frames ####

##### Political party returns #####
message('#### returns_party ####')
returns_party_web <- get_returns_data("https://transparency.aec.gov.au/AnnualPoliticalParty",
                                         "https://transparency.aec.gov.au/AnnualPoliticalParty/PoliticalPartyReturnsRead")

tmp_party_returns <- read.csv("data-raw/csv/Party Returns.csv", stringsAsFactors = FALSE)

returns_party <- returns_party_web %>%
  left_join(tmp_party_returns %>%
              select(FinancialYear = Financial.Year,
                     CurrentClientName = Name,
                     TotalReceipts = Total.Receipts,
                     TotalPayments = Total.Payments,
                     TotalDebts = Total.Debts,
                     AddressLine1 = Address.Line.1,
                     AddressLine2 = Address.Line.2,
                     Suburb, State, Postcode),
            by = c("FinancialYear", "CurrentClientName", "TotalReceipts", "TotalPayments", "TotalDebts")) %>%
  left_join(tmp_FinancialYear %>% select(-DisclosurePeriodEndDate),  # Data already has DisclosurePeriodEndDate
            by = "FinancialYear") %>%
  select(-FinancialYear) %>%
  rename(FinancialYear = FinancialYearNew) %>%
  filter(!(RegistrationCode == "P0083" & State == "TAS")) %>%  # These confuse the merge because they are 0 Totals.
  filter(!(RegistrationCode == "P0091" & State == "NT"))

# if(nrow(returns_party) == nrow(returns_party_web)) {
#
#   rm(tmp_party_returns)
#   use_data(returns_party, overwrite = TRUE)
#   rm(returns_party_web)  # returns_party is needed (and deleted) later.
#
# } else {
#
#   stop("Merge of address CSV and returns_party have different numbers of rows.")
#
# }

if(nrow(returns_party) != nrow(returns_party_web)) {

  stop("Merge of address CSV and returns_party have different numbers of rows.")

}

returns_party %>%
  group_by(FinancialYear) %>%
  summarise(Returns = n(),
            Receipts = sum(TotalReceipts, na.rm = TRUE),
            Payments = sum(TotalPayments, na.rm = TRUE),
            Debts = sum(TotalDebts, na.rm = TRUE),
            DiscBenefits = sum(DetailsOfDiscretionaryBenefitsTotal, na.rm = TRUE),
            DetailsReceipts = sum(DetailsOfReceiptsTotal, na.rm = TRUE),
            DetailsDebts = sum(DetailsOfDebtsTotal, na.rm = TRUE)) %>%
  arrange(desc(FinancialYear)) %>%
  print()

rm(tmp_party_returns, returns_party_web)

##### Political campaigner returns #####
message('#### returns_campaigner ####')
returns_campaigner_web <- get_returns_data("https://transparency.aec.gov.au/AnnualPoliticalCampaigner",
                                       "https://transparency.aec.gov.au/AnnualPoliticalCampaigner/PoliticalCampaignerReturnsRead")

tmp_camp_returns <- read.csv("data-raw/csv/Political Campaigner Returns.csv", stringsAsFactors = FALSE)

returns_campaigner <- returns_campaigner_web %>%
  left_join(tmp_camp_returns %>%
              select(FinancialYear = Financial.Year,
                     CurrentClientName = Name,
                     AddressLine1 = Address.Line.1,
                     AddressLine2 = Address.Line.2,
                     Suburb, State, Postcode),
            by = c("FinancialYear", "CurrentClientName")) %>%
  left_join(tmp_FinancialYear %>% select(-DisclosurePeriodEndDate),  # Data already has DisclosurePeriodEndDate
            by = "FinancialYear") %>%
  select(-FinancialYear) %>%
  rename(FinancialYear = FinancialYearNew)

rm(tmp_camp_returns, returns_campaigner_web)

# Summary table
message("Only goes back to 2018-19.")
returns_campaigner %>%
  group_by(FinancialYear) %>%
  summarise(Returns = n(),
            Receipts = sum(TotalReceipts, na.rm = TRUE),
            Payments = sum(TotalPayments, na.rm = TRUE),
            Debts = sum(TotalDebts, na.rm = TRUE),
            Expenditure = sum(TotalElectoralExpenditure, na.rm = TRUE),
            DiscBenefits = sum(DetailsOfDiscretionaryBenefitsTotal, na.rm = TRUE),
            DetailsReceipts = sum(DetailsOfReceiptsTotal, na.rm = TRUE),
            DetailsDebts = sum(DetailsOfDebtsTotal, na.rm = TRUE)) %>%
  print()

##### Associated entity returns #####
message('#### returns_associatedentity ####')
returns_associatedentity_web <- get_returns_data("https://transparency.aec.gov.au/AnnualAssociatedEntity",
                               "https://transparency.aec.gov.au/AnnualAssociatedEntity/AssociatedEntityReturnsRead")
tmp_ae_returns <- read.csv("data-raw/csv/Associated Entity Returns.csv", stringsAsFactors = FALSE)

returns_associatedentity <- returns_associatedentity_web %>%
  left_join(tmp_ae_returns %>%
              select(FinancialYear = Financial.Year,
                     CurrentClientName = Name,
                     TotalReceipts = Total.Receipts,
                     TotalPayments = Total.Payments,
                     TotalDebts = Total.Debts,
                     AddressLine1 = Address.Line.1,
                     AddressLine2 = Address.Line.2,
                     Suburb, State, Postcode),
            by = c("FinancialYear", "CurrentClientName", "TotalReceipts", "TotalPayments", "TotalDebts")) %>%
  left_join(tmp_FinancialYear %>% select(-DisclosurePeriodEndDate),  # Data already has DisclosurePeriodEndDate
            by = "FinancialYear") %>%
  select(-FinancialYear) %>%
  rename(FinancialYear = FinancialYearNew)

rm(tmp_ae_returns, returns_associatedentity_web)

returns_associatedentity %>%
  group_by(FinancialYear) %>%
  summarise(Rows = n(),
            Returns = length(unique(ReturnId)),
            DetailsCapital = sum(DetailsOfCapitalContributionsTotal, na.rm = TRUE),
            DetailsDebts = sum(DetailsOfDebtsTotal, na.rm = TRUE),
            DetailsDisc = sum(DetailsOfDiscretionaryBenefitsTotal, na.rm = TRUE),
            DetailsReceipts = sum(DetailsOfReceiptsTotal, na.rm = TRUE),
            TotalDebts = sum(TotalDebts, na.rm = TRUE),
            TotalPayments = sum(TotalPayments, na.rm = TRUE),
            TotalReceipts = sum(TotalReceipts)) %>%
  arrange(desc(FinancialYear)) %>%
  print()

# Remove ClientFileIdsOfAssociatedParties into its own data.frame to normalise
# (At some point they stopped using ClientFileIdsOfAssociatedParties so now we guestimate using
# AssociatedParties, which is a text field and doesn't match perfectly in all cases.)
#
# returns_associatedentity_associatedparty <- returns_associatedentity[c("FinancialYear", "RegistrationCode", "ClientFileIdsOfAssociatedParties")] %>%
#   filter(!is.na(ClientFileIdsOfAssociatedParties)) %>%
#   mutate(ClientFileIdsOfAssociatedParties = strsplit(ClientFileIdsOfAssociatedParties, ";")) %>%
#   unnest(ClientFileIdsOfAssociatedParties)
#
# returns_associatedentity_associatedparty$ClientFileIdsOfAssociatedParties <- as.integer(trimws(returns_associatedentity_associatedparty$ClientFileIdsOfAssociatedParties))
# returns_associatedentity$ClientFileIdsOfAssociatedParties <- NULL
#

returns_associatedentity_associatedparty <- returns_associatedentity %>%
  select(FinancialYear, RegistrationCode, AssociatedParties) %>%
  filter(!is.na(AssociatedParties)) %>%
  mutate(AssociatedParties = strsplit(AssociatedParties, "; ")) %>%
  unnest(AssociatedParties) %>%
  left_join(returns_party %>%
              select(FinancialYear, AssociatedParties = ReturnClientName, ClientFileId),
            by = c("FinancialYear", "AssociatedParties"))

# It had 2311 when I knew it was working
if(nrow(returns_associatedentity_associatedparty) < 2000) {

  stop("Something has gone wrong with generating returns_associatedentity_associatedparty")

}

##### Donor returns #####

# NOTE: There is some duplication with the returns_donor file due to
# insufficient detail for matching the CSV files to the JSON data.
message('#### returns_donor, returns_donor_details, returns_donor_address ####')
returns_donor_web <- get_returns_data("https://transparency.aec.gov.au/AnnualDonor",
                                  "https://transparency.aec.gov.au/AnnualDonor/DonorReturnsRead")
returns_donor_details_web <- get_returns_data("https://transparency.aec.gov.au/AnnualDonor",
                                          "https://transparency.aec.gov.au/AnnualDonor/DonationsMadeRead")

returns_donor <- returns_donor_web %>%
  left_join(tmp_FinancialYear %>% select(-DisclosurePeriodEndDate),  # Data already has DisclosurePeriodEndDate
            by = "FinancialYear") %>%
  select(-FinancialYear) %>%
  rename(FinancialYear = FinancialYearNew)

returns_donor_details <- returns_donor_details_web %>%
  left_join(tmp_FinancialYear, by = "FinancialYear") %>%
  select(-FinancialYear) %>%
  rename(FinancialYear = FinancialYearNew)

tmp_donor_returns <- read.csv("data-raw/csv/Donor Returns.csv", stringsAsFactors = FALSE)

returns_donor_address <- tmp_donor_returns %>%
  select(FinancialYear = Financial.Year,
         CurrentClientName = Name,
         AddressLine1 = Address.Line.1,
         AddressLine2 = Address.Line.2,
         Suburb, State, Postcode,
         LodgedOnBehalfOf = Lodged.on.behalf.of,
         TotalDonationsMade = Total.Donations.Made,
         TotalDonationsReceived = Total.Donations.Received) %>%
  left_join(tmp_FinancialYear %>% select(-DisclosurePeriodEndDate),  # No need for DisclosurePeriodEndDate
            by = "FinancialYear") %>%
  select(-FinancialYear) %>%
  rename(FinancialYear = FinancialYearNew)

rm(tmp_donor_returns)
# returns_donor <- unique(returns_donor)

message("returns_donor summary:")
returns_donor %>%
  group_by(FinancialYear) %>%
  summarise(Rows = n(),
            PartiesAndCampaigners = sum(TotalDonationsMadeToPoliticalPartiesAndCampaigners, na.rm = TRUE),
            PoliticalParties = sum(TotalDonationsMadeToPoliticalParties, na.rm = TRUE),
            PoliticalCampaigners = sum(TotalDonationsMadeToPoliticalCampaigners, na.rm = TRUE),
            Received = sum(TotalDonationsReceived, na.rm = TRUE)) %>%
  arrange(desc(FinancialYear)) %>%
  print()

message("returns_donor_details summary:")
returns_donor_details %>%
  group_by(FinancialYear) %>%
  summarise(Rows = n(),
            Amount = sum(Amount, na.rm = TRUE),
            Returns = length(unique(ReturnId)),
            Donors = length(unique(ClientFileId)),
            Recipients = length(unique(DonationMadeToClientFileId))) %>%
  arrange(desc(FinancialYear)) %>%
  print()

message("returns_donor_address summary:")
returns_donor_address %>%
  group_by(FinancialYear) %>%
  summarise(Rows = n(),
            TotalDonationsMade = sum(TotalDonationsMade, na.rm = TRUE),
            TotalDonationsReceived = sum(TotalDonationsReceived, na.rm = TRUE)) %>%
  arrange(desc(FinancialYear)) %>%
  print()

rm(returns_donor_web, returns_donor_details_web)

##### Third party returns #####

# NOTE: there does not seem to be any way to get the donations to third parties via the web
# interface (although they are in the CSV files).
message("#### returns_thirdparty #####")

returns_thirdparty_web <- get_returns_data("https://transparency.aec.gov.au/AnnualThirdParty",
                                       "https://transparency.aec.gov.au/AnnualThirdParty/ThirdPartyReturnsRead")

returns_thirdparty <- returns_thirdparty_web %>%
  left_join(tmp_FinancialYear %>% select(-DisclosurePeriodEndDate),  # Data already has DisclosurePeriodEndDate
            by = "FinancialYear") %>%
  select(-FinancialYear) %>%
  rename(FinancialYear = FinancialYearNew)

## TEST ##
returns_thirdparty %>%
  group_by(FinancialYear) %>%
  summarise(Rows = n(),
            ElectoralExpenditure = sum(TotalElectoralExpenditure, na.rm = TRUE),
            TotalExpenditure = sum(TotalExpenditure, na.rm = TRUE),
            TotalGifts = sum(TotalGifts, na.rm = TRUE)) %>%
  arrange(desc(FinancialYear)) %>%
  print()

rm(returns_thirdparty_web)

##### Detailed receipts #####

message("#### returns_receipts_details #####")
returns_receipts_details_web <- get_returns_data("https://transparency.aec.gov.au/AnnualDetailedReceipts",
                                        "https://transparency.aec.gov.au/AnnualDetailedReceipts/DetailedReceiptsRead")

returns_receipts_details <- returns_receipts_details_web %>%
  left_join(get_returns_data("https://transparency.aec.gov.au/AnnualDetailedReceipts",
                             "https://transparency.aec.gov.au/AnnualDetailedReceipts/DetailedReceiptsPartyGroupsRead") %>%
              select(PartyGroupName = Name, PartyGroupId) %>%
              mutate(PartyGroupId = as.integer(PartyGroupId)),
            by = "PartyGroupId") %>%
  rename(Amount = Value) %>%
  left_join(tmp_FinancialYear, by = "FinancialYear") %>%
  select(-FinancialYear) %>%
  rename(FinancialYear = FinancialYearNew)

# Quick summary of data to check it has run correctly
returns_receipts_details %>%
  group_by(FinancialYear) %>%
  summarise(Rows = n(),
            Amount = sum(Amount, na.rm = TRUE),
            Recipients = length(unique(RecipientClientId)),
            Donors = length(unique(ReceivedFromClientId))) %>%
  arrange(desc(FinancialYear)) %>%
  left_join(returns_receipts_details %>%
              filter(ReceiptType == "Donation Received") %>%
              group_by(FinancialYear) %>%
              summarise(Donor.Rows = n(),
                        Donor.Amount = sum(Amount, na.rm = TRUE)),
            by = "FinancialYear") %>%
  left_join(returns_receipts_details %>%
              filter(ReceiptType == "Other Receipt") %>%
              group_by(FinancialYear) %>%
              summarise(Other.Rows = n(),
                        Other.Amount = sum(Amount, na.rm = TRUE)),
            by = "FinancialYear") %>%
  print()

rm(returns_receipts_details_web)

##### Election Returns from Candidates and Senate Groups #####

election_candidates_returns <- get_returns_data('https://transparency.aec.gov.au/CandidateSenateGroup',
                                       'https://transparency.aec.gov.au/CandidateSenateGroup/CandidateSenateGroupData') |>
  mutate(IsNilReturn = ifelse(IsNilReturn == "Y", TRUE,
                              ifelse(IsNilReturn == "N", FALSE, NA)))

election_donor_returns <- get_returns_data('https://transparency.aec.gov.au/Donor',
                                           'https://transparency.aec.gov.au/Donor/DonorReturnsRead')


election_donor_details <- get_returns_data('https://transparency.aec.gov.au/Donor',
                                           'https://transparency.aec.gov.au/Donor/DonationsMadeRead')


# Make a record of when the data was last updated.
returns_updated <- data.frame(Updated = Sys.time(), stringsAsFactors = FALSE)

#### Import the data into the package ####

if(askYesNo("Compare new files to old files?")) {

  # This is a very quick and dirty comparison of the new and old data
  # and is mostly just a framework for something more thorough in the
  # future.
  old_data <- new.env()

  lapply(list.files("data/", full.names = TRUE), load, envir = old_data)

  lapply(ls(pattern = "^returns_"), function(x) message(x, " : ", all_equal(get(x), get(x, envir = old_data))))

}

if(askYesNo("Write data tables to package?")) {
  use_data(returns_campaigner,
           returns_associatedentity,
           returns_receipts_details,
           returns_thirdparty,
           returns_party,
           returns_donor, returns_donor_details, returns_donor_address,
           returns_associatedentity_associatedparty,
           returns_updated,
           election_candidates_returns, election_donor_returns, election_donor_details,
           overwrite = TRUE)

}

if(askYesNo("Delete data files?")) {
  rm(list = ls())
}
