party_to_group <- function(.data) {

  tmp_groups <- unique(ausvotesTR::returns_party[c("ClientFileId", "PartyGroupId", "PartyGroupName")])

  if("DonationMadeToClientFileId" %in% colnames(.data)) {

    tmp_data <- merge(.data, tmp_groups, by.x = "DonationMadeToClientFileId", by.y = "ClientFileId", all.x = TRUE)
    tmp_data <- tmp_data[!colnames(tmp_data) %in% c("DonationMadeToClientFileId", "PartyGroupId")]
    return(tmp_data[order(tmp_data$FinancialYear, tmp_data$PartyGroupName, tmp_data$TransactionDate),])

  }

}

#' Disclosure threshold table
#'
#' @return A \code{data.frame} with two columns -- \code{FinancialYear} and
#'   \code{ReportingThreshold}
#' @export
#'
#' @examples
#' disclosure_threshold()
disclosure_threshold <- function() {

  rbind(unique(returns_donor[c("FinancialYear", "ReportingThreshold")]), make.row.names = FALSE)

}

#' Party and group table
#'
#' @return A \code{data.frame} of party IDs and party group IDs and names.
#' @export
#'
#' @examples
#' party_by_group()
party_by_group <- function() {

  tmp_df <- unique(returns_party[!is.na(returns_party$PartyGroupId),][c("ClientFileId", "PartyGroupId", "PartyGroupName")])
  tmp_df <- tmp_df[order(tmp_df$PartyGroupId, tmp_df$ClientFileId),]
  rownames(tmp_df) <- NULL
  return(tmp_df)

}

#' Returns donor merged
#'
#' Return a \code{data.frame} of \code{\link{returns_donor}} with the address
#' fields (\code{AddressLine1}, \code{AddressLine2}, \code{Suburb},
#' \code{State} and \code{Postcode}) from \code{\link{returns_donor_address}}.
#'
#' The AEC's Transparency Register contains \code{\link{returns_donor}} and
#' \code{\link{returns_donor_address}} as separate files, but without a unique
#' identifier to link them.
#'
#' This function merges the two datasets on the \code{FinancialYear},
#' \code{CurrentClientName} and \code{TotalDonationsReceived} fields
#' (\code{TotalDonationsMade} is not present in \code{\link{returns_donor}}
#' in the same format so can't be linked on.).
#'
#' Note that these three fields do not provide a perfect match, which
#' potentially results in the repition of some rows of
#' \code{\link{returns_donor}}. Over the total dataset this involves a
#' duplication of 38 records (out of 11,204), so may be a justifiable
#' trade-off, depending on the analysis.
#'
#' Note that this function includes all records in \code{\link{returns_donor}}
#' and matching records in \code{\link{returns_donor_address}}, so includes
#' all donors regardless of whether an address is listed (some number of
#' donors appear not be listed in the \code{\link{returns_donor_address}}
#' data).
#'
#' @return A \code{data.frame}.
#'
#' @export
#'
#' @examples
#' head(returns_donors_merged())
returns_donor_merged <- function() {

  message("Warning: The address data does not merge cleanly with the donor data, leading to possible repition of rows from returns_data.")
  tmp_data <- merge(returns_donor,
               returns_donor_address[c("FinancialYear", "CurrentClientName", "AddressLine1", "AddressLine2", "Suburb", "Postcode", "TotalDonationsReceived")],
               by = c("FinancialYear", "CurrentClientName", "TotalDonationsReceived"), all.x = TRUE, sort = FALSE)
  tmp_data <- unique(tmp_data)
  tmp_data[order(tmp_data$FinancialYear, tmp_data$ReturnId),]

}
