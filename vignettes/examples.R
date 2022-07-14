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

