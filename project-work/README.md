# Quantative Analysis using R 

# 📊 Quantitative Analysis using R

## 🧠 Project Overview

This project demonstrates how to apply quantitative analysis techniques to financial time series using two R packages:

- **QuantStrat**: for building, backtesting, and analyzing trading strategies.
- **PortfolioAnalytics**: for optimizing and analyzing portfolio performance using risk-return metrics.

The goal is to showcase both **strategy-level backtesting** and **portfolio-level optimization** in a reproducible academic project setting.

---

## 📦 Technologies & Packages Used

- **R** (version ≥ 4.2.0)
- **RStudio** (recommended for ease of use)
- [`quantstrat`](https://github.com/braverock/quantstrat) – Strategy framework for backtesting
- [`PortfolioAnalytics`](https://cran.r-project.org/web/packages/PortfolioAnalytics/index.html) – Portfolio optimization and risk analysis
- Supporting packages:
  - `quantmod`
  - `PerformanceAnalytics`
  - `FinancialInstrument`
  - `blotter`
  - `DEoptim` or `ROI` for optimization

---

## 📁 Project Structure


```bash
├── ProjectReport.Rmd
├── ProjectReport.pdf
├── README.md
└── scripts
    └── strategy
        └── linearregression
            ├── StopLossAndTrailingStopOptimization.R
            ├── StopLossOptimization.R
            ├── load_data.R
            ├── lrc_strategy.R
            ├── sma_strategy.R
            └── visualization.R
```
