# SPALB 2024 Ensemble

Download SPALB 2024 assessment report:

- **Stock assessment of South Pacific albacore tuna in the western and central Pacific Ocean: 2024**\
  **[WCPFC-SC20-2024/SA-WP-02](https://meetings.wcpfc.int/node/23119)**

Download SPALB 2024 diagnostic model:

- Clone the **[alb-2024-diagnostic](https://github.com/PacificCommunity/ofp-sam-alb-2024-diagnostic)** repository or download as **[main.zip](https://github.com/PacificCommunity/ofp-sam-alb-2024-diagnostic/archive/refs/heads/main.zip)** file

Download SPALB 2024 ensemble results:

- Clone the **[alb-2024-ensemble](https://github.com/PacificCommunity/ofp-sam-alb-2024-ensemble)** repository or download as **[main.zip](https://github.com/PacificCommunity/ofp-sam-alb-2024-ensemble/archive/refs/heads/main.zip)** file

## Uncertainty

The SPALB 2024 assessment uncertainty was estimated using a Monte Carlo model ensemble approach in which 100 models incorporated uncertainty in average natural mortality, stock-recruitment steepness and estimation error for individual models:

## Ensemble results

This repository contains all files necessary to run or browse the SPALB 2024 ensemble.

The ensemble models are run from a par file, as described in the corresponding `doitall.sh` script.

The final par and rep files are consistently named `09.par` and `plot-09.par.rep` to facilitate harvesting results from across the 100 ensemble models.

## Estimating uncertainty

See also Section 8, Section 10.6 and Table 9 in the SPALB 2024 stock assessment [report](https://meetings.wcpfc.int/node/23119).

The `estimate_uncertainty.R` script requires two R packages that are available on GitHub:

```
install_github("flr/FLCore")
install_github("PacificCommunity/FLR4MFCL")
```
