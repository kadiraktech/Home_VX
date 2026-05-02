options(stringsAsFactors = FALSE)

set.seed(42)

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

  raw_data$property_type <- as.factor(raw_data$property_type)
  raw_data$rooms <- as.factor(raw_data$rooms)
  raw_data$heating <- as.factor(raw_data$heating)
  raw_data$balcony <- as.factor(raw_data$balcony)
  raw_data$city <- as.factor(raw_data$city)
  raw_data$district <- as.factor(raw_data$district)

  raw_data
}

rmse <- function(actual, predicted) {
  sqrt(mean((actual - predicted)^2, na.rm = TRUE))
}

mae <- function(actual, predicted) {
  mean(abs(actual - predicted), na.rm = TRUE)
}

r_squared <- function(actual, predicted) {
  1 - sum((actual - predicted)^2, na.rm = TRUE) /
    sum((actual - mean(actual, na.rm = TRUE))^2, na.rm = TRUE)
}

home_data <- read_home_data(data_path)
home_data <- home_data[complete.cases(home_data), ]

all_indices <- seq_len(nrow(home_data))
required_train <- unique(unlist(lapply(
  c("property_type", "rooms", "heating", "balcony", "city", "district"),
  function(column_name) {
    tapply(all_indices, home_data[[column_name]], function(index_values) index_values[1])
  }
)))

target_train_size <- floor(0.8 * nrow(home_data))
remaining_indices <- setdiff(all_indices, required_train)
additional_train <- sample(
  remaining_indices,
  size = max(0, target_train_size - length(required_train))
)
train_index <- sort(unique(c(required_train, additional_train)))
train_data <- home_data[train_index, ]
test_data <- home_data[-train_index, ]

for (column_name in c("property_type", "rooms", "heating", "balcony", "city", "district")) {
  train_data[[column_name]] <- factor(train_data[[column_name]], levels = levels(home_data[[column_name]]))
  test_data[[column_name]] <- factor(test_data[[column_name]], levels = levels(home_data[[column_name]]))
}

baseline_model <- lm(
  price ~ square_meters + rooms + property_type + heating + balcony + city + district,
  data = train_data
)

predictions <- predict(baseline_model, newdata = test_data)

metrics <- data.frame(
  metric = c("MAE", "RMSE", "R_squared"),
  value = c(
    mae(test_data$price, predictions),
    rmse(test_data$price, predictions),
    r_squared(test_data$price, predictions)
  )
)

write.csv(
  metrics,
  file.path(output_dir, "model_metrics.csv"),
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

summary_lines <- c(
  "Home_VX baseline model",
  "======================",
  "",
  "Model type: Linear regression",
  "Target: price",
  "Features: square_meters, rooms, property_type, heating, balcony, city, district",
  paste("Training rows:", nrow(train_data)),
  paste("Test rows:", nrow(test_data)),
  "",
  "Metrics:",
  paste(metrics$metric, round(metrics$value, 4), sep = ": "),
  "",
  "Interpretation:",
  "This is a baseline model intended to create a reproducible benchmark.",
  "It should not be treated as a production valuation engine.",
  "The dataset is small and covers only a limited set of districts and features."
)

writeLines(summary_lines, file.path(output_dir, "model_summary.txt"), useBytes = TRUE)

cat("Metrics saved to outputs/model_metrics.csv\n")
cat("Model summary saved to outputs/model_summary.txt\n")
