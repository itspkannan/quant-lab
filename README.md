# Quant‑Strategy‑Lab

🧠 **Quant-Strategy-Lab** is a research-oriented lab for building, analyzing, and validating quantitative trading strategies using **R**, **PineScript**, and financial data annotations. It includes signal prototyping, risk modeling, and visual evaluation of strategies across technical and macroeconomic regimes.

## 🧪 Key Features

- 🔁 Strategies: **Linear Regression Curves**, **SMA Crossovers**, **Stop Loss Optimization**
- 🧠 **Walk-Forward Optimization** for realistic out-of-sample testing
- 📉 Evaluation Metrics: **Sharpe Ratio**, **Max Drawdown**, **Equity Curve**, and **Monte Carlo simulation**
- 📊 **PineScript Indicators** for TradingView signal visualization
- 🌐 Annotated **macro event studies** (e.g., VIX spikes, tariff shocks, ETF reactions)

## 📁 Project Structure

```

quant-lab/
├── notes/                # Research notes and insights on ETFs, macro events, volatility
│   ├── etf/              # Specific ETF strategy notes (e.g. UVXY)
│   └── news/             # Market reactions to news and policies (e.g. tariffs, VIX spikes)
├── pinescript/           # Scripts and strategies implemented in PineScript
│   ├── notes/            # Documentation or explanations of each script
│   ├── scripts/          # Actual PineScript (.pinescript or .txt format)
│   └── vsa/              # Volume Spread Analysis studies or indicators
├── project-work/         # R-based backtesting, optimization, and strategy evaluation
│   ├── scripts/          # Strategy implementations (SMA, LRC, Stop Loss)
│   ├── ProjectReport.Rmd # Detailed writeup (academic report)
│   └── ProjectReport.pdf # Rendered report with results

```


## 🔍 Studies and Methodologies

- **Walk-Forward Optimization** using `quantstrat::walk.forward`
- **Monte Carlo simulation** for stress testing strategy robustness
- **Volume Spread Analysis** in PineScript for early trend detection
- **Macroeconomic reaction studies** on ETFs like UVXY and event-driven volatility
- 📈 Visual equity curve performance across rebalance windows


## 🛠️ TODO

🚧 Planned future enhancements:

### Priority 1

* [ ] Build a modular backtest engine using Python
* [ ] Import OHLCV data and fundamental data loaders
* [ ] Integrate backtest results with Jupyter notebooks
* [ ] Develop execution models (slippage, fees, leverage)
* [ ] Parameter tuning and optimization engine
* [ ] Live trading hooks via Alpaca / Interactive Brokers

### Priority 2
- [ ] Monte Carlo engine for path-dependent simulations (GBM, VaR)
- [ ] Volatility modeling (e.g., GARCH, regime switching)
- [ ] Macro-event overlays for strategy alignment
- [ ] Interactive dashboard (Shiny or Jekyll) for backtest visualization
- [ ] Standardized research templates for replicable studies


