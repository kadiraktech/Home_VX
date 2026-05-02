# Modeling Notes

## Why Baseline Regression

The dataset is small and tabular, so a simple linear regression baseline is a
reasonable first model. It is easy to explain, quick to run, and useful as a
benchmark before trying more complex methods.

The baseline is not meant to be a final valuation engine. It is a reproducible
starting point.

## Target

The target variable is:

- `fiyat` / `price`

Prices are parsed by removing dot thousands separators and converting the result
to numeric.

## Features

The baseline model uses:

- `mkare` / `square_meters`
- `oda` / `rooms`
- `tip` / `property_type`
- `ısıtma` / `heating`
- `balkon` / `balcony`
- `konum` / `city`
- `ilce` / `district`

Categorical variables are converted to factors by R.

## Evaluation

`scripts/03_model_baseline.R` uses a reproducible 80/20 train/test split with
`set.seed(42)`.

Metrics saved:

- MAE: average absolute prediction error
- RMSE: square-root average squared prediction error
- R-squared: variance explained on the test set

## Limitations

- 508 rows is modest for a price prediction model.
- City has no variation because all rows are Izmir.
- Some categories have very small sample sizes.
- Important valuation features are missing, such as building age, exact
  neighborhood, floor, view, condition, parking, and date listed.
- Linear regression may underfit nonlinear housing price patterns.

## Future Modeling Improvements

- Add outlier handling experiments.
- Add cross-validation.
- Compare against random forest or gradient boosting if the dataset grows.
- Engineer better room-count features.
- Add model residual analysis by district and property type.
