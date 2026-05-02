# Data Dictionary

The source dataset is `ev.csv`, a UTF-8 semicolon-delimited CSV.

The original file uses Turkish column names. Scripts rename columns internally
to safer English names for reproducible analysis.

| Original column | Script name | Expected type | Business meaning | Modeling relevance |
| --- | --- | --- | --- | --- |
| `ıd` | `id` | Integer/string identifier | Listing identifier | Not used as a predictive feature |
| `fiyat` | `price` | Numeric after removing thousands separators | Listing price in TRY | Target variable |
| `tip` | `property_type` | Categorical | Property category such as flat, villa, detached house | Important location/asset class signal |
| `mkare` | `square_meters` | Numeric | Property size in square meters | Core price driver |
| `oda` | `rooms` | Categorical | Room count such as `1+1`, `2+1`, `3+1` | Proxy for size and property segment |
| `ısıtma` | `heating` | Categorical | Heating type | Possible comfort/quality signal |
| `balkon` | `balcony` | Categorical | Whether balcony exists | Possible amenity signal |
| `konum` | `city` | Categorical | City value; all rows are Izmir in this dataset | Low variation in current data |
| `ilce` | `district` | Categorical | District such as Buca, Cesme, Menemen | Strong local market signal |

## Derived Fields

| Field | Meaning |
| --- | --- |
| `price_per_sqm` | `price / square_meters`; used for price density analysis |

## Data Notes

- `price` is stored with dot thousands separators in the CSV and must be parsed
  before numeric analysis.
- The dataset is geographically narrow, so district-level insights describe only
  the included districts.
- Some property types have very few rows, making averages unstable.
