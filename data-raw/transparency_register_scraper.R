library(httr)
library(jsonlite)
library(dplyr)
library(tidyr)

# This script imports all of the data from the AEC transparency register, located at:
#
# https://transparency.aec.gov.au/
#
# Last updated 4 February 2020.

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
  mutate(FinancialYear = ifelse(FinancialYear == "1998-1999", "1998-99",
                                ifelse(FinancialYear == "1999-2000", "1999-00",
                                       ifelse(FinancialYear == "2000-2001", "2000-01",
                                              ifelse(FinancialYear == "2001-2002", "2001-02",
                                                     ifelse(FinancialYear == "2002-2003", "2002-03",
                                                            ifelse(FinancialYear == "2003-2004", "2003-04",
                                                                   ifelse(FinancialYear == "2004-2005", "2004-05",
                                                                          ifelse(FinancialYear == "2005-2006", "2005-06",
                                                                                 ifelse(FinancialYear == "2006-2007", "2006-07",
                                                                                        ifelse(FinancialYear == "2007-2008", "2007-08",
                                                                                               ifelse(FinancialYear == "2008-2009", "2008-09",
                                                                                                      ifelse(FinancialYear == "2009-2010", "2009-10",
                                                                                                             ifelse(FinancialYear == "2010-2011", "2010-11", FinancialYear)))))))))))))) %>%
  filter(!(RegistrationCode == "P0083" & State == "TAS")) %>%  # These confuse the merge because they are 0 Totals.
  filter(!(RegistrationCode == "P0091" & State == "NT"))

if(nrow(returns_party) == nrow(returns_party_web)) {

  rm(tmp_party_returns)
  devtools::use_data(returns_party, overwrite = TRUE)

} else {

  stop("Merge of address CSV and returns_party have different numbers of rows.")

}

# Political campaigner returns
returns_campaigner <- get_returns_data("https://transparency.aec.gov.au/AnnualPoliticalCampaigner",
                                       "https://transparency.aec.gov.au/AnnualPoliticalCampaigner/PoliticalCampaignerReturnsRead")

tmp_camp_returns <- read.csv("data-raw/csv/Political Campaigner Returns.csv", stringsAsFactors = FALSE)
returns_campaigner <- returns_campaigner %>%
  left_join(tmp_camp_returns %>%
              select(FinancialYear = Financial.Year,
                     CurrentClientName = Name,
                     AddressLine1 = Address.Line.1,
                     AddressLine2 = Address.Line.2,
                     Suburb, State, Postcode),
            by = c("FinancialYear", "CurrentClientName")) %>%
  mutate(FinancialYear = ifelse(FinancialYear == "1998-1999", "1998-99",
                                ifelse(FinancialYear == "1999-2000", "1999-00",
                                       ifelse(FinancialYear == "2000-2001", "2000-01",
                                              ifelse(FinancialYear == "2001-2002", "2001-02",
                                                     ifelse(FinancialYear == "2002-2003", "2002-03",
                                                            ifelse(FinancialYear == "2003-2004", "2003-04",
                                                                   ifelse(FinancialYear == "2004-2005", "2004-05",
                                                                          ifelse(FinancialYear == "2005-2006", "2005-06",
                                                                                 ifelse(FinancialYear == "2006-2007", "2006-07",
                                                                                        ifelse(FinancialYear == "2007-2008", "2007-08",
                                                                                               ifelse(FinancialYear == "2008-2009", "2008-09",
                                                                                                      ifelse(FinancialYear == "2009-2010", "2009-10",
                                                                                                             ifelse(FinancialYear == "2010-2011", "2010-11", FinancialYear))))))))))))))
rm(tmp_camp_returns)

devtools::use_data(returns_campaigner, overwrite = TRUE)

# Associated entity returns
returns_associatedentity <- get_returns_data("https://transparency.aec.gov.au/AnnualAssociatedEntity",
                               "https://transparency.aec.gov.au/AnnualAssociatedEntity/AssociatedEntityReturnsRead")

tmp_ae_returns <- read.csv("data-raw/csv/Associated Entity Returns.csv", stringsAsFactors = FALSE)
returns_associatedentity <- returns_associatedentity %>%
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
  mutate(FinancialYear = ifelse(FinancialYear == "1998-1999", "1998-99",
                                ifelse(FinancialYear == "1999-2000", "1999-00",
                                       ifelse(FinancialYear == "2000-2001", "2000-01",
                                              ifelse(FinancialYear == "2001-2002", "2001-02",
                                                     ifelse(FinancialYear == "2002-2003", "2002-03",
                                                            ifelse(FinancialYear == "2003-2004", "2003-04",
                                                                   ifelse(FinancialYear == "2004-2005", "2004-05",
                                                                          ifelse(FinancialYear == "2005-2006", "2005-06",
                                                                                 ifelse(FinancialYear == "2006-2007", "2006-07",
                                                                                        ifelse(FinancialYear == "2007-2008", "2007-08",
                                                                                               ifelse(FinancialYear == "2008-2009", "2008-09",
                                                                                                      ifelse(FinancialYear == "2009-2010", "2009-10",
                                                                                                             ifelse(FinancialYear == "2010-2011", "2010-11", FinancialYear))))))))))))))
rm(tmp_ae_returns)

devtools::use_data(returns_associatedentity, overwrite = TRUE)

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

  devtools::use_data(returns_associatedentity_associatedparty, overwrite = TRUE)

}


# Donor returns
# NOTE: There is some duplication with the returns_donor file due to
# insufficient detail for matching the CSV files to the JSON data.
returns_donor_web <- get_returns_data("https://transparency.aec.gov.au/AnnualDonor",
                                  "https://transparency.aec.gov.au/AnnualDonor/DonorReturnsRead")
returns_donor_details_web <- get_returns_data("https://transparency.aec.gov.au/AnnualDonor",
                                          "https://transparency.aec.gov.au/AnnualDonor/DonationsMadeRead")

returns_donor <- returns_donor_web %>%
  # left_join(tmp_donor_returns %>%
  #             select(FinancialYear = Financial.Year,
  #                    CurrentClientName = Name,
  #                    TotalDonationsReceived = Total.Donations.Received,
  #                    AddressLine1 = Address.Line.1,
  #                    AddressLine2 = Address.Line.2,
  #                    Suburb, State, Postcode),
  #           by = c("FinancialYear", "CurrentClientName", "TotalDonationsReceived")) %>%
  mutate(FinancialYear = ifelse(FinancialYear == "1998-1999", "1998-99",
                                ifelse(FinancialYear == "1999-2000", "1999-00",
                                       ifelse(FinancialYear == "2000-2001", "2000-01",
                                              ifelse(FinancialYear == "2001-2002", "2001-02",
                                                     ifelse(FinancialYear == "2002-2003", "2002-03",
                                                            ifelse(FinancialYear == "2003-2004", "2003-04",
                                                                   ifelse(FinancialYear == "2004-2005", "2004-05",
                                                                          ifelse(FinancialYear == "2005-2006", "2005-06",
                                                                                 ifelse(FinancialYear == "2006-2007", "2006-07",
                                                                                        ifelse(FinancialYear == "2007-2008", "2007-08",
                                                                                               ifelse(FinancialYear == "2008-2009", "2008-09",
                                                                                                      ifelse(FinancialYear == "2009-2010", "2009-10",
                                                                                                             ifelse(FinancialYear == "2010-2011", "2010-11", FinancialYear))))))))))))))

returns_donor_details <- returns_donor_details_web %>%
  mutate(FinancialYear = ifelse(FinancialYear == "1998-1999", "1998-99",
                                ifelse(FinancialYear == "1999-2000", "1999-00",
                                       ifelse(FinancialYear == "2000-2001", "2000-01",
                                              ifelse(FinancialYear == "2001-2002", "2001-02",
                                                     ifelse(FinancialYear == "2002-2003", "2002-03",
                                                            ifelse(FinancialYear == "2003-2004", "2003-04",
                                                                   ifelse(FinancialYear == "2004-2005", "2004-05",
                                                                          ifelse(FinancialYear == "2005-2006", "2005-06",
                                                                                 ifelse(FinancialYear == "2006-2007", "2006-07",
                                                                                        ifelse(FinancialYear == "2007-2008", "2007-08",
                                                                                               ifelse(FinancialYear == "2008-2009", "2008-09",
                                                                                                      ifelse(FinancialYear == "2009-2010", "2009-10",
                                                                                                             ifelse(FinancialYear == "2010-2011", "2010-11", FinancialYear))))))))))))))


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
  mutate(FinancialYear = ifelse(FinancialYear == "1998-1999", "1998-99",
                                ifelse(FinancialYear == "1999-2000", "1999-00",
                                       ifelse(FinancialYear == "2000-2001", "2000-01",
                                              ifelse(FinancialYear == "2001-2002", "2001-02",
                                                     ifelse(FinancialYear == "2002-2003", "2002-03",
                                                            ifelse(FinancialYear == "2003-2004", "2003-04",
                                                                   ifelse(FinancialYear == "2004-2005", "2004-05",
                                                                          ifelse(FinancialYear == "2005-2006", "2005-06",
                                                                                 ifelse(FinancialYear == "2006-2007", "2006-07",
                                                                                        ifelse(FinancialYear == "2007-2008", "2007-08",
                                                                                               ifelse(FinancialYear == "2008-2009", "2008-09",
                                                                                                      ifelse(FinancialYear == "2009-2010", "2009-10",
                                                                                                             ifelse(FinancialYear == "2010-2011", "2010-11", FinancialYear))))))))))))))

rm(tmp_donor_returns)
# returns_donor <- unique(returns_donor)

devtools::use_data(returns_donor, returns_donor_details, returns_donor_address, overwrite = TRUE)

# Third partry returns
# NOTE: there does not seem to be any way to get the donations to third parties via the web
# interface (although they are in the CSV files).
returns_thirdparty <- get_returns_data("https://transparency.aec.gov.au/AnnualThirdParty",
                               "https://transparency.aec.gov.au/AnnualThirdParty/ThirdPartyReturnsRead") %>%
  mutate(FinancialYear = ifelse(FinancialYear == "1998-1999", "1998-99",
                                ifelse(FinancialYear == "1999-2000", "1999-00",
                                       ifelse(FinancialYear == "2000-2001", "2000-01",
                                              ifelse(FinancialYear == "2001-2002", "2001-02",
                                                     ifelse(FinancialYear == "2002-2003", "2002-03",
                                                            ifelse(FinancialYear == "2003-2004", "2003-04",
                                                                   ifelse(FinancialYear == "2004-2005", "2004-05",
                                                                          ifelse(FinancialYear == "2005-2006", "2005-06",
                                                                                 ifelse(FinancialYear == "2006-2007", "2006-07",
                                                                                        ifelse(FinancialYear == "2007-2008", "2007-08",
                                                                                               ifelse(FinancialYear == "2008-2009", "2008-09",
                                                                                                      ifelse(FinancialYear == "2009-2010", "2009-10",
                                                                                                             ifelse(FinancialYear == "2010-2011", "2010-11", FinancialYear))))))))))))))
devtools::use_data(returns_thirdparty, overwrite = TRUE)

# Detailed receipts
returns_receipts_details_web <- get_returns_data("https://transparency.aec.gov.au/AnnualDetailedReceipts",
                                        "https://transparency.aec.gov.au/AnnualDetailedReceipts/DetailedReceiptsRead")

returns_receipts_details <- returns_receipts_details_web %>%
  left_join(get_returns_data("https://transparency.aec.gov.au/AnnualDetailedReceipts",
                             "https://transparency.aec.gov.au/AnnualDetailedReceipts/DetailedReceiptsPartyGroupsRead") %>%
              select(PartyGroupName = Name, PartyGroupId) %>%
              mutate(PartyGroupId = as.integer(PartyGroupId)),
            by = "PartyGroupId") %>%
  rename(Amount = Value) %>%
  mutate(FinancialYear = ifelse(FinancialYear == "1998-1999", "1998-99",
                                ifelse(FinancialYear == "1999-2000", "1999-00",
                                       ifelse(FinancialYear == "2000-2001", "2000-01",
                                              ifelse(FinancialYear == "2001-2002", "2001-02",
                                                     ifelse(FinancialYear == "2002-2003", "2002-03",
                                                            ifelse(FinancialYear == "2003-2004", "2003-04",
                                                                   ifelse(FinancialYear == "2004-2005", "2004-05",
                                                                          ifelse(FinancialYear == "2005-2006", "2005-06",
                                                                                 ifelse(FinancialYear == "2006-2007", "2006-07",
                                                                                        ifelse(FinancialYear == "2007-2008", "2007-08",
                                                                                               ifelse(FinancialYear == "2008-2009", "2008-09",
                                                                                                      ifelse(FinancialYear == "2009-2010", "2009-10",
                                                                                                             ifelse(FinancialYear == "2010-2011", "2010-11", FinancialYear))))))))))))))

devtools::use_data(returns_receipts_details, overwrite = TRUE)

# Make a record of when the data was last updated.
returns_updated <- data.frame(Updated = Sys.time(), stringsAsFactors = FALSE)
devtools::use_data(returns_updated, overwrite = TRUE)

#### Make the files portable ####

rm(list = ls())

data_files <- list.files("data")

for(each_file in data_files) {

  load(paste0("data/", each_file))
  df_name <- gsub(".rda", "", fixed = TRUE, each_file)
  save(list = df_name, ascii = TRUE, file = paste0("data-raw/", df_name, ".asc"))
  rm(list = df_name)

}
