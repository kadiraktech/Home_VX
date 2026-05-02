# Outputs

This directory stores generated analysis artifacts.

Run the scripts from the repository root:

```bash
Rscript scripts/01_data_profile.R
Rscript scripts/02_data_storytelling.R
Rscript scripts/03_model_baseline.R
```

Expected generated files:

- `data_profile_summary.csv`
- `storytelling_insights.md`
- `model_metrics.csv`
- `model_summary.txt`
- `plots/*.png`

Generated outputs are intentionally ignored by Git so the repository stays small
and reproducible. Re-run the scripts to regenerate them locally.
