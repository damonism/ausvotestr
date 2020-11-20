#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ausvotesTR)

returns_search <- function(donor_name, approximate = FALSE, donor_only = TRUE) {
  
  tmp_groups <- unique(returns_party[c('ClientFileId', 'PartyGroupId', 'PartyGroupName')])
  
  tmp_common_cols <- c('FinancialYear', 'ReturnId', 'RegistrationCode', 
                       'DonorName', 'RecipientName', 'PartyGroupName',
                       'ReceiptType', 'ReturnTypeDescription', 'TransactionDate', 'Amount')
  
 if(approximate == FALSE) {
    tmp_donor <- returns_donor_details[grep(donor_name, returns_donor_details$ReturnClientName),]
  } else {
    tmp_donor <- returns_donor_details[agrep(donor_name, returns_donor_details$ReturnClientName),]
  }  
  
  tmp_donor <- merge(tmp_donor, tmp_groups, by.x = "DonationMadeToClientFileId", by.y = "ClientFileId", all.x = TRUE)
  
  colnames(tmp_donor) <- gsub('DonationMadeToName', 'RecipientName', colnames(tmp_donor), fixed = TRUE)
  colnames(tmp_donor) <- gsub('ReturnClientName', 'DonorName', colnames(tmp_donor), fixed = TRUE)
  
  # You can't add a new column to an empty data.frame
  if(nrow(tmp_donor) > 0) {
    tmp_donor$ReceiptType <- 'Donation'
  } else {
    message("No donor returns for search: ", donor_name)
  }
  
  if(donor_only == FALSE) {
    
    if(approximate == FALSE) {
      tmp_recipient <- returns_receipts_details[grep(donor_name, returns_receipts_details$ReceivedFromClientName),]
    } else {
      tmp_recipient <- returns_receipts_details[agrep(donor_name, returns_receipts_details$ReceivedFromClientName),]
    }
    colnames(tmp_recipient) <- gsub('ReceivedFromClientName', 'DonorName', colnames(tmp_recipient), fixed = TRUE)
    
    # tmp_ae <- tmp_recipient[tmp_recipient$ReturnTypeCode == 'federalassociatedentity',]
    
    if(nrow(tmp_recipient) == 0) {
      message("No recipient returns for search: ", donor_name)
    }
    
    tmp_return <- rbind(tmp_donor[tmp_common_cols], tmp_recipient[tmp_common_cols])
   
  } else {
    
    tmp_return <- tmp_donor[tmp_common_cols]
    
  }
  
  tmp_return <- tmp_return[order(tmp_return$FinancialYear),]
  rownames(tmp_return) <- NULL
  
  return(tmp_return)
}

returns_search_date <- function(donor_name, from_date, ...) {
  
  tmp_data <- returns_search(donor_name = donor_name, ...)
  tmp_data <- tmp_data[!is.na(tmp_data$TransactionDate),]
  tmp_data[tmp_data$TransactionDate > from_date,]
  
}

returns_search_summary <- function(donor_name, by_year = FALSE, from_date = NA, approximate = FALSE) {
  
  tmp_data <- returns_search(donor_name, approximate = approximate, donor_only = TRUE)
  
  if(nrow(tmp_data) == 0) {
    stop("No entries returned.")
  }
  
  if(!is.na(from_date)) {
    
    tmp_data <- tmp_data[tmp_data$TransactionDate > as.Date(from_date),]
    
  }
  
  if(by_year == FALSE) {
    tmp_table <- aggregate(Amount ~ PartyGroupName + DonorName, tmp_data, sum)
  } else {
    tmp_table <- aggregate(Amount ~ FinancialYear + PartyGroupName + DonorName, tmp_data, sum)
    
  }
  
  return(tmp_table[order(tmp_table$PartyGroupName),])
  
}

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("AEC Donations Explorer"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        textInput("donor_name",
                  h3("Donor name:")),
        dateInput("from_date",
                  "From date:",
                  value = "1980-01-01"),
        checkboxInput("donor_only", 
                      "Donor returns only?",
                      value = TRUE),
        downloadButton("download_details", 
                       "Download data")
      ),
      
      # Show a plot of the generated distribution
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

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  detailed_data_df <- reactive({
    req(input$donor_name)
    detailed_data <- returns_search_date(input$donor_name, 
                                         approximate = FALSE, 
                                         donor_only = input$donor_only,
                                         from_date = input$from_date)    
  })
  
  output$detailed <- renderDataTable({
    detailed_data <- detailed_data_df()
    detailed_data[c('ReturnId', 'RegistrationCode')] <- NULL
    detailed_data
  }, options = list(lengthMenu = list(c(25, 50, 100, -1), c('25', '50', '100', 'All'))))
  
  #  output$detailed <- renderDataTable({
  #   detailed_data <- returns_search_date(input$donor_name, 
  #                                        approximate = FALSE, 
  #                                        donor_only = input$donor_only,
  #                                        from_date = input$from_date)
  #   detailed_data[c('ReturnId', 'RegistrationCode')] <- NULL
  #   detailed_data
  # }, options = list(lengthMenu = list(c(25, 50, 100, -1), c('25', '50', '100', 'All'))))
  
  output$summary <- renderDataTable({
    summary_table <- returns_search_summary(input$donor_name, 
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
      # detailed_data <- returns_search_date(input$donor_name, 
      #                                      approximate = FALSE, 
      #                                      donor_only = input$donor_only,
      #                                      from_date = input$from_date)
      write.csv(detailed_data, file, row.names = FALSE)
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)

