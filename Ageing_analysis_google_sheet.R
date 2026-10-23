library(googlesheets4)
library(dplyr)
library(FSA)

# Set sheet URL and tab name
sheet_url <- "https://docs.google.com/spreadsheets/d/1Q09ICWC7TnH_AsCLe3mP-A35gof1jw-aosp-B-xGcEc/edit?gid=0#gid=0"
target_sheet <- "Reader comparisions"

# 1. Read sheet data
sheet_data <- read_sheet(sheet_url, sheet = target_sheet)

# 2. Filter rows where both readers have entered an age estimate
complete_reads <- sheet_data %>% 
  filter(!is.na(r1_age) & !is.na(r2_age))

# 3. Calculate Ageing Precision using FSA package (APE and CV)
prec <- agePrecision(~ r1_age + r2_age, data = complete_reads)

# Extract summary metrics safely
pa_0 <- prec$pa[["PA0"]]
pa_1 <- prec$pa[["PA1"]]
mean_ape <- prec$APE

cat(sprintf("Percent Agreement (Exact): %.2f%%\n", pa_0))
cat(sprintf("Percent Agreement (+/- 1yr): %.2f%%\n", pa_1))
cat(sprintf("Mean APE: %.2f%%\n", mean_ape))

# 4. Update sheet_data with age difference and re-read flags
updated_sheet_data <- sheet_data %>%
  mutate(
    age_diff = abs(r1_age - r2_age),
    needs_reread = ifelse(!is.na(age_diff) & age_diff > 1, TRUE, FALSE)
  )

# 5. Write the updated data frame back to the specific sheet tab
sheet_write(updated_sheet_data, ss = sheet_url, sheet = target_sheet)

# Optional: Write a separate summary table to a new tab called "Summary Metrics"
summary_df <- tibble(
  Metric = c("Percent Agreement (Exact)", "Percent Agreement (+/- 1yr)", "Mean APE (%)"),
  Value = c(round(pa_0, 2), round(pa_1, 2), round(mean_ape, 2))
)
sheet_write(summary_df, ss = sheet_url, sheet = "Summary Metrics")

