#' ausvotesTR: A package of data from the Australian Electoral Commission's
#'   Transparency Register
#'
#' Contains data extracted from the Transparency Register plus a number of
#'   convenience functions (and a bonus Shiny app) for analysing that data.
#'
#' @docType package
#' @name ausvotesTR
utils::globalVariables(c("returns_donor", "returns_donor_address",
                         "returns_donor_details", "returns_party",
                         "returns_receipts_details"))
