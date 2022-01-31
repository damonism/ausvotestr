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

#### Import the data into R ####

# Political party returns
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

if(nrow(returns_party) == nrow(returns_party_web)) {

  rm(tmp_party_returns)
  use_data(returns_party, overwrite = TRUE)
  rm(returns_party_web)  # returns_party is needed (and deleted) later.

} else {

  stop("Merge of address CSV and returns_party have different numbers of rows.")

}

# Political campaigner returns
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

use_data(returns_campaigner, overwrite = TRUE)
# rm(returns_campaigner)

# Associated entity returns
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

use_data(returns_associatedentity, overwrite = TRUE)

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

} else {

  use_data(returns_associatedentity_associatedparty, overwrite = TRUE)
  rm(returns_associatedentity, returns_associatedentity_associatedparty, returns_party)


}


# Donor returns
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

returns_donor %>%
  group_by(FinancialYear) %>%
  summarise(Rows = n(),
            PartiesAndCampaigners = sum(TotalDonationsMadeToPoliticalPartiesAndCampaigners, na.rm = TRUE),
            PoliticalParties = sum(TotalDonationsMadeToPoliticalParties, na.rm = TRUE),
            PoliticalCampaigners = sum(TotalDonationsMadeToPoliticalCampaigners, na.rm = TRUE),
            Received = sum(TotalDonationsReceived, na.rm = TRUE)) %>%
  arrange(desc(FinancialYear)) %>%
  print()

returns_donor_details %>%
  group_by(FinancialYear) %>%
  summarise(Rows = n(),
            Amount = sum(Amount, na.rm = TRUE),
            Returns = length(unique(ReturnId)),
            Donors = length(unique(ClientFileId)),
            Recipients = length(unique(DonationMadeToClientFileId))) %>%
  arrange(desc(FinancialYear)) %>%
  print()

returns_donor_address %>%
  group_by(FinancialYear) %>%
  summarise(Rows = n(),
            TotalDonationsMade = sum(TotalDonationsMade, na.rm = TRUE),
            TotalDonationsReceived = sum(TotalDonationsReceived, na.rm = TRUE)) %>%
  arrange(desc(FinancialYear)) %>%
  print()

use_data(returns_donor, returns_donor_details, returns_donor_address, overwrite = TRUE)
rm(returns_donor, returns_donor_details, returns_donor_address, returns_donor_web, returns_donor_details_web)

# Third party returns
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

use_data(returns_thirdparty, overwrite = TRUE)
rm(returns_thirdparty)

# Detailed receipts
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

use_data(returns_receipts_details, overwrite = TRUE)
rm(returns_receipts_details, returns_receipts_details_web)

# Make a record of when the data was last updated.
returns_updated <- data.frame(Updated = Sys.time(), stringsAsFactors = FALSE)
use_data(returns_updated, overwrite = TRUE)

rm(list = ls())


#### Make the files portable ####

# # This was a hack I did to work around certain limitations with one of the
# # machines I was developing this on, and is no longer necessary.
# #
# # Use this instead: remotes::install_gitlab("damonism/ausvotesTR")
#
# data_files <- list.files("data")
#
# for(each_file in data_files) {
#
#   load(paste0("data/", each_file))
#   df_name <- gsub(".rda", "", fixed = TRUE, each_file)
#   save(list = df_name, ascii = TRUE, file = paste0("data-raw/", df_name, ".asc"))
#   rm(list = df_name)
#
# }
