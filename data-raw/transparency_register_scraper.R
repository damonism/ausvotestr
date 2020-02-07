library(httr)
library(jsonlite)
library(dplyr)

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
returns_party <- get_returns_data("https://transparency.aec.gov.au/AnnualPoliticalParty",
                                         "https://transparency.aec.gov.au/AnnualPoliticalParty/PoliticalPartyReturnsRead")

tmp_party_returns <- read.csv("data-raw/csv/Party Returns.csv", stringsAsFactors = FALSE)
returns_party <- returns_party %>%
  left_join(tmp_party_returns %>%
              select(FinancialYear = Financial.Year,
                     CurrentClientName = Name,
                     AddressLine1 = Address.Line.1,
                     AddressLine2 = Address.Line.2,
                     Suburb, State, Postcode),
            by = c("FinancialYear", "CurrentClientName"))
rm(tmp_party_returns)

devtools::use_data(returns_party, overwrite = TRUE)

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
            by = c("FinancialYear", "CurrentClientName"))
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
                     AddressLine1 = Address.Line.1,
                     AddressLine2 = Address.Line.2,
                     Suburb, State, Postcode),
            by = c("FinancialYear", "CurrentClientName"))
rm(tmp_ae_returns)

devtools::use_data(returns_associatedentity, overwrite = TRUE)

# Donor returns
returns_donor <- get_returns_data("https://transparency.aec.gov.au/AnnualDonor",
                                  "https://transparency.aec.gov.au/AnnualDonor/DonorReturnsRead")
returns_donor_details <- get_returns_data("https://transparency.aec.gov.au/AnnualDonor",
                                          "https://transparency.aec.gov.au/AnnualDonor/DonationsMadeRead")

tmp_donor_returns <- read.csv("data-raw/csv/Donor Returns.csv", stringsAsFactors = FALSE)
returns_donor <- returns_donor %>%
  left_join(tmp_donor_returns %>%
              select(FinancialYear = Financial.Year,
                     CurrentClientName = Name,
                     AddressLine1 = Address.Line.1,
                     AddressLine2 = Address.Line.2,
                     Suburb, State, Postcode),
            by = c("FinancialYear", "CurrentClientName"))
rm(tmp_donor_returns)

devtools::use_data(returns_donor, returns_donor_details, overwrite = TRUE)

# Third partry returns
# NOTE: there does not seem to be any way to get the donations to third parties via the web
# interface (although they are in the CSV files).
returns_thirdparty <- get_returns_data("https://transparency.aec.gov.au/AnnualThirdParty",
                               "https://transparency.aec.gov.au/AnnualThirdParty/ThirdPartyReturnsRead")
devtools::use_data(returns_thirdparty, overwrite = TRUE)

# Detailed receipts
returns_receipts_details <- get_returns_data("https://transparency.aec.gov.au/AnnualDetailedReceipts",
                                        "https://transparency.aec.gov.au/AnnualDetailedReceipts/DetailedReceiptsRead")

returns_receipts_details <- returns_receipts_details %>%
  left_join(get_returns_data("https://transparency.aec.gov.au/AnnualDetailedReceipts",
                             "https://transparency.aec.gov.au/AnnualDetailedReceipts/DetailedReceiptsPartyGroupsRead") %>%
              select(PartyGroupName = Name, PartyGroupId) %>%
              mutate(PartyGroupId = as.integer(PartyGroupId)),
            by = "PartyGroupId")

devtools::use_data(returns_receipts_details, overwrite = TRUE)

# get_returns_data("https://transparency.aec.gov.au/AnnualDetailedReceipts",
#                  "https://transparency.aec.gov.au/AnnualDetailedReceipts/DetailedReceiptsPoliticalPartiesRead")


#### Make the files portable ####

rm(list = ls())

data_files <- list.files("data")

for(each_file in data_files) {

  load(paste0("data/", each_file))
  df_name <- gsub(".rda", "", fixed = TRUE, each_file)
  save(list = df_name, ascii = TRUE, file = paste0("data-raw/", df_name, ".asc"))
  rm(list = df_name)

}
