# Storytelling Report

## Executive Summary

Home_VX explores a small Izmir real estate dataset to understand which visible
property attributes appear related to listing prices. The analysis is framed as
data storytelling rather than production forecasting.

The available data suggests that district, property type, and square meters are
important price signals. Cesme has the highest average listing prices among the
included districts, and villas/detached-style properties tend to sit above flats
in average price. These findings should be treated as dataset-specific because
the data covers only 508 rows and three districts.

## Dataset Overview

- Source file: `ev.csv`
- Rows: 508
- Columns: 9
- City: Izmir
- Districts: Buca, Cesme, Menemen
- Target: `fiyat`

The CSV is semicolon-delimited and encoded as UTF-8. The R scripts rename
Turkish columns internally for safer analysis while preserving the source file.

## Key Patterns To Explore

The storytelling script generates plots for:

- price distribution
- price per square meter distribution
- average price by district
- average price by property type
- square meters versus price
- average price by room count

These views are designed to answer the business question:

> What factors appear to influence house prices in this dataset?

## Visual Analysis Explanation

Price distribution helps reveal whether a small number of high-value listings
stretch the market upward. Price per square meter makes properties of different
sizes easier to compare. District and property-type averages show how location
and asset class influence listing prices. The square-meter scatter plot checks
whether larger properties generally command higher prices.

## Initial Data-Based Observations

Based on the inspected dataset:

- Cesme has the highest average price among the three districts.
- Villas have a higher average price than flats.
- The data includes several property types with very low row counts, so those
  category averages should be read cautiously.
- Square meters are important, but they are not the only driver; district and
  property type appear meaningful.

## Baseline Model Interpretation

The baseline script trains a linear regression model with an 80/20 train/test
split. It predicts price from size, rooms, property type, heating, balcony, city,
and district.

This model is included to create a reproducible benchmark. Its metrics should be
read from `outputs/model_metrics.csv` after running the script. No fixed accuracy
claim is made in this report.

## Limitations

- Dataset size is limited to 508 rows.
- Coverage is limited to Izmir listings from Buca, Cesme, and Menemen.
- No listing date is available, so time effects cannot be modeled.
- No exact neighborhood, building age, floor, renovation state, view, or parking
  information is included.
- Some property categories are represented by only a few rows.

## Next Steps

- Run the scripts to generate plots and metrics.
- Review outliers and category sample sizes.
- Add an R Markdown or Quarto report if a single rendered artifact is needed.
- Consider richer models only after the baseline is understood.
