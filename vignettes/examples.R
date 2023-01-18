## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

devtools::load_all(".")

## ----search_mutliple_donors, message=TRUE, warning=FALSE, paged.print=TRUE----
library(purrr)

check_donors <- c('Rinehart', 'Hancock', 'Forrest', 'Fortescue',
                  'Pratt', 'Shimao', 'Wing Mau', 'Cannon-Brookes',
                  'Atlassian', 'Farquhar', 'Triguboff', 'Meriton',
                  'Palmer', 'Mineralogy', 'Lowy', 'Westfield',
                  'Stokes', 'Seven', 'John Gandel', 'Vicinity', 'Alan Wilson',
                  'Reece', 'Packer', 'Crown', 'Sehgal', 'Samvardhana',
                  'Chak Wing', 'Kingold', 'Glasenberg', 'Glencore',
                  'Cowin', 'Competitive Foods', 'Ainsworth', 
                  'Aristocrat', 'Lang Walker', 'Walker Group', 
                  'Richard White', 'WiseTech')

map_dfr(check_donors, search_returns, donor_only = FALSE)

## ----donors_to_party, warning=FALSE, results='asis'---------------------------
library(dplyr)

returns_receipts_details %>%
  filter(PartyGroupName == "The Greens") %>% 
  filter(ReceiptType == "Donation Received") %>% 
  filter(FinancialYear %in% c('2020-21', '2019-20', '2018-19', '2017-18')) %>% 
  group_by(FinancialYear, ReceivedFromClientId, ReceivedFromClientName) %>% 
  summarise(Amount = sum(Amount, na.rm = TRUE)) %>% 
  mutate(link = paste0('https://transparency.aec.gov.au/AnnualClientEntity/EntityDetail?clientFileId=', ReceivedFromClientId)) %>% 
  head() %>% 
  knitr::kable()

## ----donors_party_group, message=TRUE, warning=FALSE, paged.print=TRUE--------
library(dplyr)

returns_donor_details %>% 
  filter(FinancialYear %in% c('2018-19', '2019-20', '2020-21')) %>% 
  filter(DonationMadeToClientType == 'politicalparty') %>% 
  left_join(party_by_group(), 
            by = c("DonationMadeToClientFileId" = "ClientFileId"))

## ----receipts_by_type---------------------------------------------------------
#library(ausvotesTR)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

Receipts_by_type <- returns_party %>%
  group_by(FinancialYear) %>% 
  summarise(TotalReceipts = sum(TotalReceipts)) %>% 
  left_join(returns_receipts_details %>% 
              filter(ReturnTypeDescription == "Political Party Return") %>% 
              mutate(ReceiptType = ifelse(ReceiptType == "", "Unspecified", ReceiptType),
                     ReceiptType = ifelse(grepl("Electoral Commission", ReceivedFromClientName, fixed = TRUE), "Public Funding", ReceiptType)) %>% 
              group_by(FinancialYear, ReceiptType) %>% 
              summarise(Amount = sum(Amount, na.rm = TRUE)) %>% 
              bind_rows(group_by(., FinancialYear) %>% 
                          summarise(Amount = sum(Amount, na.rm = TRUE)) %>% 
                          mutate(ReceiptType = "TotalDeclared")) %>%
              spread(ReceiptType, Amount, fill = 0),
            by = "FinancialYear") %>%
  mutate(Undeclared = TotalReceipts - TotalDeclared) %>% 
  gather(ReceiptType, Amount, -FinancialYear) %>%
  filter(!ReceiptType %in% c("TotalReceipts", "TotalDeclared"))

ggplot(Receipts_by_type, aes(x = FinancialYear, y = Amount, fill = ReceiptType)) +
  geom_bar(stat = "identity") + 
  scale_y_continuous(name = "Amount ($)", labels = comma) +
  scale_x_discrete(name = "Financial year (election years in red)") +
  scale_fill_discrete(name = "Receipt type") +
  ggtitle(label = "Total receipts by type") +
  theme(axis.text = element_text(angle = 45, hjust = 1, size = 12),
        axis.text.x = element_text(colour = ifelse(Receipts_by_type$FinancialYear %in% c("2018-19", "2015-16", "2013-14", "2010-11", "2007-08", "2004-05", "2001-02", "1998-99"), "red", "black")))


## ----receipts_by_type_table, results='asis'-----------------------------------
Receipts_by_type %>% 
  spread(ReceiptType, Amount) %>% 
  knitr::kable()

## ----declared_and_undeclared, results='asis'----------------------------------
returns_party %>% 
  mutate(PartyGroupName = ifelse(is.na(PartyGroupName), "Others", PartyGroupName)) %>% 
  mutate(PartyGroupName = ifelse(PartyGroupName %in% c("Christian Democratic Party (Fred Nile Group)", 
                                                       "Democratic Labor Party"), 
                                 "Others", 
                                 PartyGroupName)) %>% 
  group_by(FinancialYear, PartyGroupName) %>% 
  summarise(TotalReceipts = sum(TotalReceipts),
            Declared = sum(DetailsOfReceiptsTotal)) %>% 
  mutate(Undeclared = TotalReceipts - Declared) %>% 
  # select(-TotalReceipts) %>% 
  filter(FinancialYear == "2020-21") %>% 
  knitr::kable()

## ----below_disclosure_threshold, results='asis'-------------------------------
returns_donor_details %>% 
  left_join(disclosure_threshold(), by = "FinancialYear") %>% 
  filter(Amount < ReportingThreshold) %>% 
  group_by(FinancialYear) %>% 
  summarise(BelowThreshold = sum(Amount, na.rm = TRUE)) %>% 
  left_join(returns_donor_details %>% 
              group_by(FinancialYear) %>% 
              summarise(Total = sum(Amount, na.rm = TRUE)),
            by = "FinancialYear") %>% 
  mutate(Percent = BelowThreshold / Total * 100) %>% 
  left_join(disclosure_threshold(), by = "FinancialYear") %>% 
  knitr::kable()

## ----number_of_donors, results='asis'-----------------------------------------
returns_donor_details %>% 
  group_by(FinancialYear, RegistrationCode, DonationMadeToClientFileId) %>% 
  summarise(Total = sum(Amount, na.rm = TRUE)) %>% 
  left_join(disclosure_threshold(), by = "FinancialYear") %>%
  filter(Total < ReportingThreshold) %>% 
  group_by(FinancialYear, ReportingThreshold) %>% 
  summarise(n = n()) %>% 
  arrange(desc(ReportingThreshold)) %>% 
  knitr::kable()

## ----donations_in_qld, results='asis'-----------------------------------------
tmp_qld <- returns_receipts_details %>% 
  filter(FinancialYear == "2018-19" & 
           RecipientClientId %in% returns_party$ClientFileId[returns_party$FinancialYear == "2020-21" & returns_party$State == "QLD"] & 
           ReceiptType == "Donation Received")

dim(tmp_qld)[1]
sum(tmp_qld$Amount)


