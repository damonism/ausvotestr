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
