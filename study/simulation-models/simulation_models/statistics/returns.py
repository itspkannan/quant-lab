
def cagr(prices, periods_per_year=252):
    n_years = len(prices) / periods_per_year
    return (prices[-1] / prices[0])**(1 / n_years) - 1
