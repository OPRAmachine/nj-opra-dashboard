# NJ OPRA Dashboard
 This is a dashboard for analyzing trends in NJ OPRA requests using data produced from [OPRAmachine](https://opramachine.com/) for research regarding how well public authorities comply with the New Jersey Open Public Records Act (OPRA) as well as trends in the frequency & content of public records requests.

## Components
The main dashboard is contained within the file opra-dashboard.Rmd, and utilizes shiny and flexdashboard to create an interactive dashboard for visualizing the data.

The dashboard expects a CSV file with data generated from the process-data.R script, which is stored in data/output.csv. The script processes the raw data and generates HTML for the table used in the dashboard.

 The script also calculates the amount of time between when requests were originally submitted and when a response was received.