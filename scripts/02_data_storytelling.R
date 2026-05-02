options(stringsAsFactors = FALSE)

data_path <- "ev.csv"
output_dir <- "outputs"
plot_dir <- file.path(output_dir, "plots")
dir.create(plot_dir, showWarnings = FALSE, recursive = TRUE)

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

save_png <- function(filename, expr) {
  png(file.path(plot_dir, filename), width = 1100, height = 760)
  on.exit(dev.off(), add = TRUE)
  eval.parent(substitute(expr))
}

money <- function(x) {
  paste0("TRY ", format(round(x, 0), big.mark = ",", scientific = FALSE))
}

home_data <- read_home_data(data_path)

district_mean <- aggregate(price ~ district, home_data, mean)
district_mean <- district_mean[order(district_mean$price, decreasing = TRUE), ]

type_mean <- aggregate(price ~ property_type, home_data, mean)
type_mean <- type_mean[order(type_mean$price, decreasing = TRUE), ]

rooms_mean <- aggregate(price ~ rooms, home_data, mean)
rooms_mean <- rooms_mean[order(rooms_mean$price, decreasing = TRUE), ]

heating_mean <- aggregate(price ~ heating, home_data, mean)
heating_mean <- heating_mean[order(heating_mean$price, decreasing = TRUE), ]

balcony_mean <- aggregate(price ~ balcony, home_data, mean)
balcony_mean <- balcony_mean[order(balcony_mean$price, decreasing = TRUE), ]

save_png("01_price_distribution.png", {
  hist(
    home_data$price,
    breaks = 30,
    col = "#256f5c",
    border = "white",
    main = "Price Distribution",
    xlab = "Listing price (TRY)"
  )
})

save_png("02_price_per_square_meter.png", {
  hist(
    home_data$price_per_sqm,
    breaks = 30,
    col = "#c77d2d",
    border = "white",
    main = "Price per Square Meter Distribution",
    xlab = "TRY per square meter"
  )
})

save_png("03_average_price_by_district.png", {
  barplot(
    district_mean$price,
    names.arg = district_mean$district,
    las = 2,
    col = "#2f6f9f",
    main = "Average Price by District",
    ylab = "Average price (TRY)"
  )
})

save_png("04_average_price_by_property_type.png", {
  barplot(
    type_mean$price,
    names.arg = type_mean$property_type,
    las = 2,
    col = "#7c5c9b",
    main = "Average Price by Property Type",
    ylab = "Average price (TRY)"
  )
})

save_png("05_square_meters_vs_price.png", {
  plot(
    home_data$square_meters,
    home_data$price,
    pch = 19,
    col = rgb(37, 111, 92, 120, maxColorValue = 255),
    main = "Square Meters vs Price",
    xlab = "Square meters",
    ylab = "Price (TRY)"
  )
  abline(lm(price ~ square_meters, data = home_data), col = "#c0392b", lwd = 2)
})

save_png("06_average_price_by_room_count.png", {
  barplot(
    rooms_mean$price,
    names.arg = rooms_mean$rooms,
    las = 2,
    col = "#5f7f3f",
    main = "Average Price by Room Count",
    ylab = "Average price (TRY)"
  )
})

top_district <- district_mean[1, ]
top_type <- type_mean[1, ]
avg_price <- mean(home_data$price, na.rm = TRUE)
median_price <- median(home_data$price, na.rm = TRUE)
avg_price_per_sqm <- mean(home_data$price_per_sqm, na.rm = TRUE)
cor_sqm_price <- cor(home_data$square_meters, home_data$price, use = "complete.obs")

insights <- c(
  "# Home_VX Storytelling Insights",
  "",
  paste("- Dataset contains", nrow(home_data), "rows and", ncol(home_data), "analysis columns after derived features."),
  paste("- Average listing price:", money(avg_price), "and median listing price:", money(median_price), "."),
  paste("- Average price per square meter:", money(avg_price_per_sqm), "."),
  paste("- Highest average district price in this dataset:", top_district$district, "at", money(top_district$price), "."),
  paste("- Highest average property type price:", top_type$property_type, "at", money(top_type$price), "."),
  paste("- Correlation between square meters and price:", round(cor_sqm_price, 3), "."),
  paste("- District coverage is limited to", paste(unique(home_data$district), collapse = ", "), "within", unique(home_data$city)[1], "."),
  "",
  "## Limitations",
  "",
  "- These insights describe the available dataset only and should not be generalized to the full housing market.",
  "- Some categories have very few records, so their averages can be unstable.",
  "- Listing price can be influenced by variables not present here, such as exact neighborhood, building age, floor, view, and renovation quality."
)

writeLines(insights, file.path(output_dir, "storytelling_insights.md"), useBytes = TRUE)

cat("Plots saved to outputs/plots/\n")
cat("Insights saved to outputs/storytelling_insights.md\n")
