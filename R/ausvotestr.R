#' ausvotesTR: Australian federal political donations data.
#'
#' Contains data extracted from the Australian Electoral Commission's
#'   Transparency Register plus a number of convenience functions (and a bonus
#'   Shiny app) for analysing that data.
#'
#' @docType package
#' @name ausvotesTR
utils::globalVariables(c("returns_donor", "returns_donor_address",
                         "returns_donor_details", "returns_party",
                         "returns_receipts_details"))
