library(stringr)

# Read issue body text passed from GitHub Environment
issue_body <- Sys.getenv("ISSUE_BODY")

# Extract numeric values for ages using regex
r1_age <- as.numeric(str_extract(str_match(issue_body, "Reader 1 Age Estimate\\n\\n(\\d+)")[,2], "\\d+"))
r2_age <- as.numeric(str_extract(str_match(issue_body, "Reader 2 Age Estimate\\n\\n(\\d+)")[,2], "\\d+"))

diff <- abs(r1_age - r2_age)
cat("Age difference calculated:", diff, "\n")

# Set GitHub Action step output
gh_output <- Sys.getenv("GITHUB_OUTPUT")
if (diff > 1) {
  write(paste0("disagreement=true"), file = gh_output, append = TRUE)
  write(paste0("diff_val=", diff), file = gh_output, append = TRUE)
} else {
  write(paste0("disagreement=false"), file = gh_output, append = TRUE)
}
