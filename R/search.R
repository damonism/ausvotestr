#' Donor returns search
#'
#' @param donor_name donor name
#' @param approximate logical. If \code{TRUE}, will use \code{agrep} for searching rather than grep.
#'
#' @return A \code{data.frame}.
#' @export
donor_returns_search <- function(donor_name, approximate = FALSE) {

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
#' @param donor_name Donor name
#' @param approximate logical. If \code{TRUE}, will use \code{agrep} for searching rather than grep.
#'
#' Includes political party, political campaigner and associated entity returns.
#'
#' @return A \code{data.frame}.
#' @export
recipient_returns_search <- function(donor_name, approximate = FALSE) {

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

donor_id_search <- function(donor_name) {

  tmp_donor <- returns_donor[c("FinancialYear", "CurrentClientName", "ReturnClientName", "ClientFileId")][grepl(donor_name, returns_donor$CurrentClientName) | grepl(donor_name, returns_donor$ReturnClientName),]
  tmp_donor$ReturnType <- "Donor Return"
  tmp_donor <- unique(tmp_donor)

  tmp_recip <- returns_receipts_details[c("FinancialYear", "ReceivedFromClientName", "ReceivedFromClientId", "ReturnTypeDescription")][grepl(donor_name, returns_receipts_details$ReceivedFromClientName),]
  colnames(tmp_recip) <- c("FinancialYear", "ReturnClientName", "ClientFileId", "ReturnType")
  tmp_recip$CurrentClientName <- NA
  tmp_recip <- unique(tmp_recip)

  rbind(tmp_donor, tmp_recip)

}

