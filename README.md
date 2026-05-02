# Home_VX

Home_VX is a focused R-based data storytelling project about real estate prices
in a small Izmir housing dataset. The goal is to answer one practical business
question:

> What factors appear to influence house prices in this dataset?

The repository is intentionally lightweight. It is not a production valuation
engine, Shiny app, API, or full-stack product. It is a reproducible analysis
project designed for portfolio and CV review.

## Dataset Summary

The dataset is stored in `ev.csv`.

- Format: semicolon-delimited CSV
- Encoding: UTF-8
- Rows: 508
- Columns: 9
- Missing cells in quick profile: 0
- Duplicate full rows in quick profile: 0
- City coverage: Izmir
- District coverage: Buca, Cesme, Menemen
- Main target column: `fiyat`

Columns:

```text
ıd, fiyat, tip, mkare, oda, ısıtma, balkon, konum, ilce
```

Note: the original CSV keeps Turkish column names. The R scripts normalize them
internally to safer English names for analysis.

## Project Structure

```text
.
|-- ev.csv
|-- README.md
|-- CHANGELOG.md
|-- ROADMAP.md
|-- docs/
|   |-- data-dictionary.md
|   |-- modeling-notes.md
|   |-- project-audit.md
|   `-- storytelling-report.md
|-- outputs/
|   `-- README.md
`-- scripts/
    |-- 01_data_profile.R
    |-- 02_data_storytelling.R
    `-- 03_model_baseline.R
```

## How To Run

Run scripts from the repository root.

```bash
Rscript scripts/01_data_profile.R
Rscript scripts/02_data_storytelling.R
Rscript scripts/03_model_baseline.R
```

The scripts use base R only, so no package installation is required.

## Generated Outputs

When the scripts are executed, they generate:

- `outputs/data_profile_summary.csv`
- `outputs/storytelling_insights.md`
- `outputs/model_metrics.csv`
- `outputs/model_summary.txt`
- `outputs/plots/*.png`

Generated outputs are ignored by Git and can be reproduced locally.

## Analysis Story

This project examines:

- price distribution
- price per square meter
- average price by district
- average price by property type
- relationship between square meters and price
- room count and price patterns
- balcony and heating categories where useful

## Key Observations From Initial Profiling

- The dataset contains 508 listings from Izmir.
- Cesme has the highest average price in the available district groups.
- Villas and detached-style properties are generally more expensive than flats
  in this dataset.
- Square meters are an important price signal, but price is also affected by
  district and property type.
- The dataset is small and geographically narrow, so results should not be
  generalized to the full Turkish housing market.

## Baseline Model

`scripts/03_model_baseline.R` trains a simple linear regression baseline with an
80/20 train/test split.

Target:

- `fiyat`

Features:

- `mkare`
- `oda`
- `tip`
- `isitma`
- `balkon`
- `konum`
- `ilce`

The script saves MAE, RMSE, and R-squared to `outputs/model_metrics.csv`.
Metrics are intentionally not hardcoded in the README because they should come
from running the script.

## Documentation

- [Data dictionary](docs/data-dictionary.md)
- [Storytelling report](docs/storytelling-report.md)
- [Modeling notes](docs/modeling-notes.md)
- [Project audit](docs/project-audit.md)
- [Roadmap](ROADMAP.md)
- [Changelog](CHANGELOG.md)

## Limitations

- The dataset has 508 rows, not 10K+ records.
- No external market data is included.
- District coverage is limited to Buca, Cesme, and Menemen.
- Some property type categories have very few observations.
- The baseline model is for learning and comparison, not production valuation.

## Portfolio Positioning

Home_VX demonstrates practical data storytelling with a real estate dataset:
data profiling, reproducible scripts, visual analysis, baseline modeling, and
clear documentation without unnecessary product architecture.
