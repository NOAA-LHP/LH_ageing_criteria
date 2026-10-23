library(stringr)
library(gh)

# Read issue body text passed from GitHub Environment
#issue_body <- Sys.getenv("ISSUE_BODY")

# Fetch a specific issue from a repository (replace repo owner, repo name, and issue number)
#issue_data <- gh("GET /repos/{owner}/{repo}/issues/{issue_number}",
#                 owner = "NOAA-LHP",
#                 repo = "LH_ageing_criteria",
#                 issue_number = 3)

library(googlesheets4)
library(stringr)
library(dplyr)

#Read the Google Sheet into R
# Replace with your Google Sheet URL or File ID
sheet_url <- "https://docs.google.com/spreadsheets/d/1Q09ICWC7TnH_AsCLe3mP-A35gof1jw-aosp-B-xGcEc/edit?gid=0#gid=0"
sheet_data <- read_sheet(sheet_url)

r1_age<-sheet_data$r1_age
r2_age<-sheet_data$r2_age
# View the extracted results
print(df_cleaned %>% select(issue_body, r1_age, r2_age))
diff <- abs(r1_age - r2_age)
# 2. Calculate the age difference as a new column
sheet_data <- sheet_data %>%
  mutate(cat = abs(r1_age - r2_age))

# Print the calculation result to console if desired
print(sheet_data %>% select(r1_age, r2_age, cat))

#Write the updated data frame back to Google Sheets
sheet_write(sheet_data, ss = sheet_url, sheet="Reader comparisions")



#working on sending github issues if age reads are off 
# 
# # Set GitHub Action step output
# gh_output <- Sys.getenv("GITHUB_OUTPUT")
# if (diff > 1) {
#   write(paste0("disagreement=true"), file = gh_output, append = TRUE)
#   write(paste0("diff_val=", diff), file = gh_output, append = TRUE)
# } else {
#   write(paste0("disagreement=false"), file = gh_output, append = TRUE)
# }
