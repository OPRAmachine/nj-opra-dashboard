
By County
=====================================
  
  Compare by County {.sidebar}
-----------------------------------------------------------------------
  How do New Jersey's counties compare for OPRA response times?

```{r}
selectInput("county_name", "County Name", choices = counties$Name)

```

Row
-----------------------------------------------------------------------

### Average response time for this county


```{r}
renderValueBox({
  # Get tag for selected county
  county_tag <- paste0(input$county_name,'County')
  county_tag <- str_replace_all(string=county_tag, pattern=" ", repl="")
  # Filter requests containing the tag
  county_requests <- requests %>% filter(str_detect(tag1, county_tag) | str_detect(tag2, county_tag) |  str_detect(tag3, county_tag) | str_detect(tag4, county_tag)) %>% filter(described_state != 'error_message')
  # Calculate average response time for the county
  county_response_time <- round(mean(na.omit(county_requests$days_until_response)),digits = 2)
  
  # Remove requests that failed to deliver from average response time calculation
  requests_error_omit <- requests %>% filter(described_state != 'error_message')
  avg_response <- round(mean(na.omit(requests_error_omit$days_until_response)), digits = 2)
  
  valueBox(paste(county_response_time,'days'), 
           icon = "fa-clock",
           color = ifelse(avg_response > 7, "warning", "primary"))
  })

```

### Average response time for all counties


```{r}
renderValueBox({
  all_counties_response_time <- round(mean(counties$average_response_time), digits = 2)
  valueBox(paste(all_counties_response_time,'days'), 
           icon = "fa-clock",
           color = ifelse(all_counties_response_time > 7, "warning", "primary"))
  })

```

Row
-----------------------------------------------------------------------

```{r}
 renderUI(tags$h1(paste(input$county_name,'County at a glance')))

```

```{r}
renderUI({
county_tag <- paste0(input$county_name, 'County')

county_requests <- requests %>% filter(str_detect(tag1, county_tag) | str_detect(tag2, county_tag) |  str_detect(tag3, county_tag) | str_detect(tag4, county_tag)) %>% filter(described_state != 'error_message')

county_authorities <- county_requests %>% count(vars = requested_from) %>% arrange(desc(n))

# Get top 10 authorities by request count
top10 <- county_authorities %>% top_n(10, wt=n) %>% arrange(desc(n))

# Make an ordered factor
top10$vars <- factor(top10$vars, levels = top10$vars)

# Plot them with Plotly
fig <- plot_ly(
  x = top10$vars,
  y = top10$n,
  name = "Requests by authority",
  type = "bar"
)
fig
})
```

