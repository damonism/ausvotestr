#' Donor returns search
#'
#' Generally \link{search_returns} will be a better option for searching this
#'   data.
#'
#' @param donor_name donor name
#' @param approximate logical. If \code{TRUE}, will use \link{agrep} for
#'   searching rather than \link{grep}.
#'
#' @return A \code{data.frame}.
#' @export
search_donor_returns <- function(donor_name, approximate = FALSE) {

  tmp_groups <- unique(returns_party[c("ClientFileId", "PartyGroupId", "PartyGroupName")])

  if(approximate == FALSE) {
    return_data <- returns_donor_details[grep(donor_name, returns_donor_details$ReturnClientName),]
  } else {
    return_data <- returns_donor_details[agrep(donor_name, returns_donor_details$ReturnClientName),]
  }
  return_data <- merge(return_data, tmp_groups, by.x = "DonationMadeToClientFileId", by.y = "ClientFileId", all.x = TRUE)
  colnames(return_data) <- gsub("DonationMadeToName", "RecipientName", colnames(return_data), fixed = TRUE)
  colnames(return_data) <- gsub("ReturnClientName", "DonorName", colnames(return_data), fixed = TRUE)

  return_data <- return_data[c("FinancialYear", "RecipientName", "DonorName", "PartyGroupName", "TransactionDate", "Amount")]
  rownames(return_data) <- NULL
  return(return_data[order(return_data$FinancialYear, return_data$PartyGroupName, return_data$RecipientName, decreasing = TRUE),])

}

#' Recipient returns search
#'
#' @param donor_name donor name
#' @param approximate logical. If \code{TRUE}, will use \link{agrep} for
#'   searching rather than \link{grep}.
#'
#' Includes political party, political campaigner and associated entity
#'   returns.
#'
#' @return A \code{data.frame}.
#' @export
search_recipient_returns <- function(donor_name, approximate = FALSE) {

  if(approximate == FALSE) {
    return_data <- returns_receipts_details[grep(donor_name, returns_receipts_details$ReceivedFromClientName),]
  } else {
    return_data <- returns_receipts_details[agrep(donor_name, returns_receipts_details$ReceivedFromClientName),]
  }
  # colnames(return_data) <- gsub("Value", "Amount", colnames(return_data), fixed = TRUE)
  colnames(return_data) <- gsub("ReceivedFromClientName", "DonorName", colnames(return_data), fixed = TRUE)
  rownames(return_data) <- NULL
  return_data[c("FinancialYear", "ReturnTypeDescription", "DonorName", "RecipientName", "PartyGroupName", "ReceiptType", "Amount")]

}

search_donor_id <- function(donor_name) {

  tmp_donor <- returns_donor[c("FinancialYear", "CurrentClientName", "ReturnClientName", "ClientFileId")][grepl(donor_name, returns_donor$CurrentClientName) | grepl(donor_name, returns_donor$ReturnClientName),]
  tmp_donor$ReturnType <- "Donor Return"
  tmp_donor <- unique(tmp_donor)

  tmp_recip <- returns_receipts_details[c("FinancialYear", "ReceivedFromClientName", "ReceivedFromClientId", "ReturnTypeDescription")][grepl(donor_name, returns_receipts_details$ReceivedFromClientName),]
  colnames(tmp_recip) <- c("FinancialYear", "ReturnClientName", "ClientFileId", "ReturnType")
  tmp_recip$CurrentClientName <- NA
  tmp_recip <- unique(tmp_recip)

  rbind(tmp_donor, tmp_recip)

}

#' Search donor and recipient returns for the named donor(s).
#'
#' This provides a quick way to search for named donors in either the donor
#' returns or the donor and recipient returns.
#'
#' The search is via a string search (using either \link{grep} or
#' \link{agrep}, depending on arguments) of the \code{DonorName} field. As
#' such, the \code{donor_name} argument supports whatever search patterns the
#' function supports (including regular expressions in the case of
#' \link{grep}).
#'
#' If \code{approximate = FALSE} the search is case insensitive. This makes
#' the search a little more useful when you're not sure exactly what the
#' name of the entity is (approximate searches are less affected by string
#' case).
#'
#' If the \code{donor_only} argument is \code{FALSE}, the function also
#' searchers the recipient returns, which is good from the sake of
#' completeness, but also includes 'Other Receipts' (ie., receipts that
#' are not donations), which may lead to interpretation difficulties as some
#' data will be repeated between the donor and recipient returns, but it will
#' not always be obvious what data is repeated.
#'
#' The companion function \link{search_returns_summary} provides the
#' output of this function aggregated by donor name (and optionally by
#' year).
#'
#' @param donor_name donor name as a \link{grep} pr \code{link} pattern.
#' @param approximate (\code{BOOL}) if \code{TRUE}, use \code{agrep} for an
#'   approximate match, rather than \link{grep}. Defaults to \code{FALSE}
#'   (\link{grep}).
#' @param donor_only (\code{BOOL}) only search donor returns (useful for
#'   avoiding 'Other Receipts' in recipient returns). Defaults to
#'   \code{TRUE}.
#' @param from_date Date in 'YYYY-MM-DD' format. Return a filtered result with
#'   only those returns with a later \code{TransactionDate}. Note that not all
#'   transactions have a date (this is particularly true of political party
#'   returns) and if the \code{TransactionDate} is missing this will be replaced
#'   by relevant \code{DisclosurePeriodEndDate} and a warning will be printed.
#'
#' @return A \code{data.frame} with zero or more rows and the following
#'   columns: \code{FinancialYear}, \code{ReturnId}, \code{RegistrationCode},
#'   \code{DonorName}, \code{RecipientName}, \code{PartyGroupName},
#'   \code{ReceiptType}, '\code{ReturnTypeDescription}, \code{TransactionDate},
#'   \code{Amount}.
#' @export
#'
#' @examples
#' search_returns("Woodside|AGL", from_date = "2010-01-01")
search_returns <- function(donor_name, approximate = FALSE, donor_only = TRUE, from_date = NA) {

  tmp_groups <- unique(returns_party[c('ClientFileId', 'PartyGroupId', 'PartyGroupName')])

  tmp_common_cols <- c('FinancialYear', 'ReturnId', 'RegistrationCode',
                       'DonorName', 'RecipientName', 'PartyGroupName',
                       'ReceiptType', 'ReturnTypeDescription', 'TransactionDate',
                       'Amount', 'DisclosurePeriodEndDate')

  if(approximate == FALSE) {
    tmp_donor <- returns_donor_details[grep(donor_name, returns_donor_details$ReturnClientName, ignore.case = TRUE),]
  } else {
    tmp_donor <- returns_donor_details[agrep(donor_name, returns_donor_details$ReturnClientName),]
  }

  if(nrow(tmp_donor) > 0) {
    tmp_donor <- merge(tmp_donor, tmp_groups, by.x = "DonationMadeToClientFileId", by.y = "ClientFileId", all.x = TRUE)

    colnames(tmp_donor) <- gsub('DonationMadeToName', 'RecipientName', colnames(tmp_donor), fixed = TRUE)
    colnames(tmp_donor) <- gsub('ReturnClientName', 'DonorName', colnames(tmp_donor), fixed = TRUE)

    tmp_donor$ReceiptType <- 'Donation'
    tmp_return <- tmp_donor[tmp_common_cols]

  } else {
    message("No donor returns for search: ", donor_name)
    # No easy way to add a column to a zero row data.frame - this is a hack
    # to keep the column formats with a nil return (which allows it to be
    # pasted together with other returns).
    tmp_donor <- returns_donor_details[1,]
    colnames(tmp_donor) <- gsub('DonationMadeToName', 'RecipientName', colnames(tmp_donor), fixed = TRUE)
    colnames(tmp_donor) <- gsub('ReturnClientName', 'DonorName', colnames(tmp_donor), fixed = TRUE)

    tmp_donor$ReceiptType <- 'Donation'
    tmp_donor$PartyGroupName <- 'DUMMY'
    tmp_return <- tmp_donor[0,][tmp_common_cols]
  }

  if(donor_only == FALSE) {

    if(approximate == FALSE) {
      tmp_recipient <- returns_receipts_details[grep(donor_name, returns_receipts_details$ReceivedFromClientName, ignore.case = TRUE),]
    } else {
      tmp_recipient <- returns_receipts_details[agrep(donor_name, returns_receipts_details$ReceivedFromClientName),]
    }
    colnames(tmp_recipient) <- gsub('ReceivedFromClientName', 'DonorName', colnames(tmp_recipient), fixed = TRUE)

    if(nrow(tmp_recipient) == 0) {
      message("No recipient returns for search: ", donor_name)
    }

    tmp_return <- rbind(tmp_return, tmp_recipient[tmp_common_cols])

  }

  tmp_return <- tmp_return[order(tmp_return$FinancialYear),]

  if(!is.na(from_date)){
    if(nrow(tmp_return) != nrow(tmp_return[!is.na(tmp_return$TransactionDate),])) {
      message('Warning: ',
              nrow(tmp_return) - nrow(tmp_return[!is.na(tmp_return$TransactionDate),]),
              ' rows missing dates - replaced with DisclosurePeriodEndDate.')
      tmp_return$TransactionDate[is.na(tmp_return$TransactionDate)] <- tmp_return$DisclosurePeriodEndDate[is.na(tmp_return$TransactionDate)]
    }
    tmp_return <- tmp_return[tmp_return$TransactionDate >= from_date,]
  }

  rownames(tmp_return) <- NULL
  return(tmp_return)
}

#' Search Returns and provide URL
#'
#' Run \code{\link{search_returns}} and include a column (\code{URL}) that has a
#' URL to the return on the AEC website.
#'
#' @param ... Passed to \code{\link{search_returns}}
#' @param as_html Return \code{data.frame} with an additional column
#'   \code{ReturnLink} that includes a formatted HTML link.
#'
#' @return A \code{data.frame}.
#' @export
#'
#' @examples
#' returns_url("taxation", donor_only = FALSE, from_date = '2010-01-01')
search_returns_url <- function(..., as_html = FALSE) {
  tmp_returns <- search_returns(...)

  if(nrow(tmp_returns > 0)) {

    tmp_returns$URL <- paste0("https://transparency.aec.gov.au/",
                             ifelse(tmp_returns$ReturnTypeDescription == "Political Party Return", "AnnualPoliticalParty",
                                    ifelse(tmp_returns$ReturnTypeDescription == "Organisation Donor Return" | tmp_returns$ReturnTypeDescription == "Individual Donor Return", "AnnualDonor",
                                           ifelse(tmp_returns$ReturnTypeDescription == "Associated Entity Return", "AnnualAssociatedEntity",
                                                  ifelse(tmp_returns$ReturnTypeDescription == "Significant Third Party Return", "AnnualSignificantThirdParty", NA)))),
                             "/ReturnDetail?returnId=", tmp_returns$ReturnId)

    if(as_html) {
      tmp_returns$ReturnLink <- paste0("<a href=\'", tmp_returns$URL, "\' target=\'_blank\'>", tmp_returns$ReturnId, "</a>")
    }

    return(tmp_returns)

  }
}

#' Search donor and recipient returns by date
#'
#' Deprecated -- use \link{search_returns} with `from_date` instead.
#'
#' @param donor_name Donor name as a regular expression.
#' @param from_date Date in 'YYYY-MM-DD' format.
#' @param ... Passed to \code{search_returns()}.
#'
#' @return A \code{data.frame}.
#' @export
#'
#' @examples
#' search_returns_date("Woodside|AGL", from_date = "2010-01-01")
search_returns_date <- function(donor_name, from_date, ...) {

  search_returns(donor_name = donor_name, from_date = from_date, ...)

  # tmp_data <- search_returns(donor_name = donor_name, ...)
  # if(nrow(tmp_data) == 0) {
  #   return(tmp_data)
  # } else {
  #   tmp_data <- tmp_data[!is.na(tmp_data$TransactionDate),]
  #   return(tmp_data[tmp_data$TransactionDate > from_date,])
  # }

}

#' Cross-tab of donations by donor
#'
#' Returns a \code{data.frame} of donations by named donor(s) aggregated by
#' recipient party group and (optionally) year of return.
#'
#' This is mainly a convenience function for the Shiny app. It calls
#' \link{search_returns} internally.
#'
#' @param donor_name donor name as a regular expression.
#' @param by_year (\code{BOOL}) aggregate donation amounts by financial year.
#'   Defaults to \code{FALSE}.
#' @param from_date (Optional) date in 'YYYY-MM-DD' format.
#' @param approximate (\code{BOOL}) if \code{TRUE}, use \code{agrep} for an
#'   approximate match, rather than \code{grep}. Defaults to \code{FALSE}
#'   (\code{grep}).
#'
#' @return A \code{data.frame}.
#' @export
#'
#' @examples
#' search_returns_summary("Woodside|AGL", from_date = "2010-01-01", by_year = TRUE)
#'
#' @importFrom stats aggregate
search_returns_summary <- function(donor_name, by_year = FALSE, from_date = NA, approximate = FALSE) {

  tmp_data <- search_returns(donor_name, approximate = approximate, donor_only = TRUE, from_date = from_date)

  if(nrow(tmp_data) == 0) {
    message("No entries returned for search ", donor_name)
    return(tmp_data)
  }

  # if(!is.na(from_date)) {
  #   tmp_data <- tmp_data[tmp_data$TransactionDate > as.Date(from_date),]
  # }

  if(by_year == FALSE) {
    tmp_table <- aggregate(Amount ~ PartyGroupName + DonorName, tmp_data, sum)
  } else {
    tmp_table <- aggregate(Amount ~ FinancialYear + PartyGroupName + DonorName, tmp_data, sum)
  }

  return(tmp_table[order(tmp_table$PartyGroupName),])

}
