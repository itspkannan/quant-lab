import numpy as np

def sharpe_ratio(returns, risk_free_rate=0.0, periods_per_year=252):
    excess_returns = returns - risk_free_rate / periods_per_year
    return np.mean(excess_returns) / np.std(excess_returns) * np.sqrt(periods_per_year)
