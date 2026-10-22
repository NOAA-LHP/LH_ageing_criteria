library(googlesheets4)
library(FSA)
library(dplyr)

# Authenticate without prompt (for public or service account link)
gs4_deauth()

# Google Sheet URL or ID
sheet_url <-"https://docs.google.com/spreadsheets/d/15oEcqgalzCddTs9-5ccY0PuW5Qmxprd9d1R0osAH6Y0/edit?gid=2092189648#gid=2092189648"
df <- read_sheet(sheet_url, sheet = "Ages")

# Filter rows where both readers have entered an age estimate
complete_reads <- df %>% filter(!is.na(Reader1_Age) & !is.na(Reader2_Age))

# Calculate Percent Agreement within 0 and 1 year
diffs <- abs(complete_reads$Reader1_Age - complete_reads$Reader2_Age)
pa_0 <- mean(diffs == 0) * 100
pa_1 <- mean(diffs <= 1) * 100

# Calculate Ageing Precision using FSA package (APE and CV)
prec <- agePrecision(~ Reader1_Age + Reader2_Age, data = complete_reads)
ape_val <- prec$detail$APE
mean_ape <- mean(ape_val, na.rm = TRUE)

cat(sprintf("Percent Agreement (Exact): %.2f%%\n", pa_0))
cat(sprintf("Percent Agreement (+/- 1yr): %.2f%%\n", pa_1))
cat(sprintf("Mean APE: %.2f%%\n", mean_ape))

# Find specific samples requiring re-read (> 1 year difference)
discrepancies <- complete_reads %>% filter(abs(Reader1_Age - Reader2_Age) > 1)

# Write summary to GitHub Actions Output file
gh_output <- Sys.getenv("GITHUB_OUTPUT")
write(paste0("pa_0=", round(pa_0, 1)), file = gh_output, append = TRUE)
write(paste0("pa_1=", round(pa_1, 1)), file = gh_output, append = TRUE)
write(paste0("mean_ape=", round(mean_ape, 2)), file = gh_output, append = TRUE)
write(paste0("flagged_count=", nrow(discrepancies)), file = gh_output, append = TRUE)
