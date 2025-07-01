import numpy as np

def annualized_volatility(returns, periods_per_year=252):
    return np.std(returns) * np.sqrt(periods_per_year)
