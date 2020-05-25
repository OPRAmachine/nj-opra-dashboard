# Helper script to process request data for visualization
library(tidyverse)
library(lubridate)
library(shiny)

requests <- read_csv('data/opra_data_5-12-20.csv')

# Drop first column, not needed
requests <- requests[ -c(1) ]

# Reorder requests in descending order
requests <- requests %>% map_df(rev)

# Calculate time difference in days between last_public_response_at and request_created_at columns
requests$days_until_response <- as.double(difftime(requests$last_public_response_at, requests$request_created_at),
                                          units = "days")

# Create new output dataframe
output <- requests %>% select(title, url_title, requested_by, requested_from, awaiting_description, described_state, request_created_at, last_public_response_at, days_until_response, tag_string)

# Add the OPRAmachine URL to the url slug to url_title column
output$url_title <- paste('https://opramachine.com/request/', output$url_title, sep = "")

# Create properly formatted HTML of data urls for the dashboard
for (i in 1:nrow(output)) {
  output$title_html[i] <- toString(tags$a(href=output$url_title[i], output$title[i]))
}

# Rename title_html column to request
output <- rename(output, request = title_html)

# Subset just the columns we need now that the tags have been generated
output <- output %>% select(request, requested_by, requested_from, awaiting_description, described_state, request_created_at, last_public_response_at, days_until_response, tag_string)

# Write out to CSV
write_csv(output, 'data/output.csv')