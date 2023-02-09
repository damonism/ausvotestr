#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#

library(shiny)
library(ausvotesTR)

ui <- fluidPage(

   titlePanel("AEC Donations Explorer"),

   sidebarLayout(
      sidebarPanel(
        textInput("donor_name",
                  h3("Donor name:")),
        helpText("Donor name accepts regular expressions."),
        dateInput("from_date",
                  "From date:",
                  value = "1980-01-01"),
        checkboxInput("donor_only",
                      "Donor returns only?",
                      value = TRUE),
        downloadButton("download_details",
                       "Download data"),
        htmlOutput("date_updated")
      ),

      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("Detailed results",
                             h2(textOutput("detailed_heading")),
                             dataTableOutput("detailed")),
                    tabPanel("Summary",
                             checkboxInput("summary_by_year",
                                           "Group by year",
                                           value = TRUE),
                             dataTableOutput("summary"))
        )
      )
   )
)

server <- function(input, output) {

  detailed_data_df <- reactive({
    req(input$donor_name)
    detailed_data <- search_returns(input$donor_name,
                                    approximate = FALSE,
                                    donor_only = input$donor_only,
                                    from_date = input$from_date)
  })

  output$detailed <- renderDataTable({
    detailed_data <- detailed_data_df()
    detailed_data[c('ReturnId', 'RegistrationCode')] <- NULL
    detailed_data
  }, options = list(lengthMenu = list(c(25, 50, 100, -1), c('25', '50', '100', 'All'))))

  output$summary <- renderDataTable({
    summary_table <- search_returns_summary(input$donor_name,
                                            approximate = FALSE,
                                            by_year = input$summary_by_year,
                                            from_date = input$from_date)
    summary_table
  }, options = list(searching = FALSE, paging = FALSE)
  )

  output$detailed_heading <- renderText({
    ifelse(input$donor_only, 'Donor returns search', 'All returns search')
  })

  output$download_details <- downloadHandler(
    filename = function() {
      ifelse(input$donor_only, 'donor_returns.csv', 'all_returns.csv')
    },
    content = function(file) {
      detailed_data <- detailed_data_df()
      write.csv(detailed_data, file, row.names = FALSE)
    }
  )

  output$date_updated <- renderText({
    paste(p(paste0("Data extracted on ",
          format(as.Date(returns_updated[1,1], tz = "Australia/Melbourne"),
                 "%d %B %Y"),
          " from the Australian Electoral Commission's (AEC) Transparency Register. ",
          "Results will not reflect any amendments made to returns after that date.")),
          p(paste0("The most recent returns period as of the date the data was extracted was ",
          head(unique(returns_donor$FinancialYear),1),
          ".")),
          sep = "")
  })
}

shinyApp(ui = ui, server = server)

