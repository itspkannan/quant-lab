from random_walk.simulator import generate_price_walk
from random_walk.statistics import sharpe_ratio, max_drawdown, cagr, annualized_volatility
from scripts.dashboard import build_dashboard

def simulate_and_build_dashboard():
    df = generate_price_walk()
    metrics = {
        "Sharpe Ratio": sharpe_ratio(df['Return'].dropna()),
        "Max Drawdown": max_drawdown(df['Price'].values),
        "CAGR": cagr(df['Price'].values),
        "Volatility (Ann)": annualized_volatility(df['Return'].dropna())
    }

    fig = build_dashboard(df, metrics)
    fig.show()

simulate_and_build_dashboard()
