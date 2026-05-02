options(stringsAsFactors = FALSE)

data_path <- "ev.csv"
output_dir <- "outputs"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

read_home_data <- function(path) {
  raw_data <- read.csv(
    path,
    sep = ";",
    fileEncoding = "UTF-8",
    check.names = FALSE,
    stringsAsFactors = FALSE
  )

  names(raw_data) <- c("id", "price", "property_type", "square_meters",
                       "rooms", "heating", "balcony", "city", "district")

  raw_data$price <- as.numeric(gsub("\\.", "", raw_data$price))
  raw_data$square_meters <- as.numeric(raw_data$square_meters)
  raw_data$price_per_sqm <- raw_data$price / raw_data$square_meters

  raw_data
}

format_number <- function(x) {
  format(round(x, 2), big.mark = ",", scientific = FALSE)
}

home_data <- read_home_data(data_path)

row_count <- nrow(home_data)
column_count <- ncol(home_data)
missing_by_column <- colSums(is.na(home_data) | home_data == "")
duplicate_count <- sum(duplicated(home_data))

cat("Home_VX data profile\n")
cat("====================\n")
cat("Rows:", row_count, "\n")
cat("Columns:", column_count, "\n")
cat("Column names:", paste(names(home_data), collapse = ", "), "\n")
cat("Duplicate full rows:", duplicate_count, "\n\n")

cat("Missing values by column:\n")
print(missing_by_column)

cat("\nDistrict distribution:\n")
print(sort(table(home_data$district), decreasing = TRUE))

cat("\nProperty type distribution:\n")
print(sort(table(home_data$property_type), decreasing = TRUE))

summary_rows <- data.frame(
  metric = c(
    "row_count",
    "column_count",
    "duplicate_full_rows",
    "missing_cells_total",
    "min_price",
    "max_price",
    "mean_price",
    "median_price",
    "mean_square_meters",
    "mean_price_per_sqm"
  ),
  value = c(
    row_count,
    column_count,
    duplicate_count,
    sum(missing_by_column),
    min(home_data$price, na.rm = TRUE),
    max(home_data$price, na.rm = TRUE),
    mean(home_data$price, na.rm = TRUE),
    median(home_data$price, na.rm = TRUE),
    mean(home_data$square_meters, na.rm = TRUE),
    mean(home_data$price_per_sqm, na.rm = TRUE)
  )
)

write.csv(
  summary_rows,
  file.path(output_dir, "data_profile_summary.csv"),
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

cat("\nSummary saved to outputs/data_profile_summary.csv\n")
