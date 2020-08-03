# Create OPRA reques statistics 

library(tidyverse)
library(usmap)

counties <- read_csv('data/county_to_tag.csv')
requests <- read.csv('data/output.csv')
request_states <- requests %>% select(described_state) %>% distinct()

# Get FIPS codes for every county
counties$fips_code <- fips('NJ', county = counties$Name)


for (i in 1:nrow(counties)) {
  county_requests <- requests %>% filter(str_detect(tag1, counties$Tag[i]) | str_detect(tag2, counties$Tag[i]) |  str_detect(tag3, counties$Tag[i]) | str_detect(tag4, counties$Tag[i])) %>% filter(described_state != 'error_message')
  # Get total requests for each county
  counties$total_requests[i] <- nrow(county_requests)
  # Get average response time for each county
  counties$average_response_time[i] <- round(mean(na.omit(county_requests$days_until_response)),digits = 2)
  # Get number of unique requesters
  counties$total_requesters[i] <- as.integer(county_requests %>% select(requested_by) %>% distinct() %>% count())
}

write.csv(counties, 'data/county_summaries.csv')

