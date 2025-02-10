#' ausvotesTR: Australian federal political donations data.
#'
#' Contains data extracted from the Australian Electoral Commission's
#'   Transparency Register plus a number of convenience functions (and a bonus
#'   Shiny app) for analysing that data.
#'
#' To run the Shiny app, use:
#'
#' \code{shiny::runApp(system.file("shiny-examples", "donation-explorer", package = "ausvotesTR"),
#'   display.mode = "normal")}
#'
#' @docType package
#' @name ausvotesTR
utils::globalVariables(c("returns_donor",
                         "returns_donor_details", "returns_party",
                         "returns_receipts_details"))
