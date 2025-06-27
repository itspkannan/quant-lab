import pandas as pd
import yfinance as yf
import matplotlib.pyplot as plt

# Fetch data
df = yf.download("AAPL", start="2022-01-01", end="2024-01-01")
df['Low20'] = df['Low'].rolling(20).min()
df['Volume20'] = df['Volume'].rolling(20).mean()
df['Spring'] = (df['Close'] < df['Low20']) & (df['Volume'] > 1.5 * df['Volume20'])

# Backtest: Buy on Spring, Sell after 10 days
df['Position'] = df['Spring'].shift(1)
df['Return'] = df['Close'].pct_change()
df['Strategy'] = df['Return'] * df['Position'].fillna(0)

# Cumulative returns
df[['Return', 'Strategy']].cumsum().plot(title="Wyckoff Spring Strategy vs Buy & Hold")
plt.show()
