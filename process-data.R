# Helper script to process request data for visualization
library(tidyverse)
library(lubridate)
library(shiny)
library(sqldf)
library(usmap)
library(tigris)
data("fips_codes")

# Read in OPRA request data
requests <- read_csv('data/opra_data_5-12-20.csv')

# Read in table of counties
counties <- read_csv('data/county_to_tag.csv')


# Drop first column, not needed
requests <- requests[ -c(1) ]

# Reorder requests in descending order
requests <- requests %>% map_df(rev)

# Break tags into their own columns
#requests <- requests %>% separate(tag_string, into = c("tag1","tag2","tag3", "tag4"), sep = "[ ]")


# Calculate time difference in days between last_public_response_at and request_created_at columns
requests$days_until_response <- as.double(difftime(requests$last_public_response_at, requests$request_created_at),
                                          units = "days")

# Get request counts by state
request_counts <- requests %>% count(vars = described_state) %>% arrange(desc(n))


# Create new output dataframe
output <- requests %>% select(title, url_title, requested_by, requested_from, awaiting_description, described_state, request_created_at, last_public_response_at, days_until_response, tag1, tag2, tag3, tag4)

# Add the OPRAmachine URL to the url slug to url_title column
output$url_title <- paste('https://opramachine.com/request/', output$url_title, sep = "")

# Create properly formatted HTML of data urls for the dashboard
for (i in 1:nrow(output)) {
  output$title_html[i] <- toString(tags$a(href=output$url_title[i], output$title[i]))
}

# Rename title_html column to request
output <- rename(output, request = title_html)

# Subset just the columns we need now that the tags have been generated
output <- output %>% select(request, requested_by, requested_from, awaiting_description, described_state, request_created_at, last_public_response_at, days_until_response, tag1, tag2, tag3, tag4)

# Write out to CSV
write_csv(output, 'data/output.csv')


# Generate county-level summaries
for (i in 1:nrow(counties)) {
  counties$request_count[i] <- requests %>% filter(str_detect(tag_string, counties$Tag[i])) %>% count()
  
  # Add a column for each request state
  for (j in 1:nrow(request_counts)) {
    # Initialize empty columns with request states
    counties[, as.character(request_counts$vars[j])] <- NA
      # Count of each request state for each county
      for (l in 3:17) {
        counties[i, l] <- requests %>% filter(described_state == request_counts$vars[j] & (str_detect(tag_string, counties$Tag[i]))) %>% count()
    }
  }
}

# Generate proper county names from tags
counties$name_full <- paste(counties$Name, 'County')

fips_codes %>% filter(state == 'NJ')
