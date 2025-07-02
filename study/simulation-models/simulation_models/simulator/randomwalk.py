import numpy as np
import pandas as pd


def generate_price_walk(steps=252, start_price=100, mu=0.0005, sigma=0.01, seed=42):
    np.random.seed(seed)
    returns = np.random.normal(loc=mu, scale=sigma, size=steps)
    prices = start_price * np.exp(np.cumsum(returns))

    df = pd.DataFrame({
        'Price': prices,
        'Return': returns
    })
    df['Volatility'] = df['Return'].rolling(window=20).std()
    df['Drawdown'] = (df['Price'] / df['Price'].cummax()) - 1
    df = df.replace({np.nan: None})
    return df

