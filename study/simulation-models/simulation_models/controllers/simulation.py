
from sanic import Request, HTTPResponse, json

from simulation_models.simulator import generate_price_walk, MonteCarlo
from simulation_models.statistics import sharpe_ratio, max_drawdown, annualized_volatility, cagr


class SimulationController:
    async def metrics(self, request: Request) -> HTTPResponse:
        df = generate_price_walk()
        metrics = {
            "Sharpe Ratio": sharpe_ratio(df['Return'].dropna()),
            "Max Drawdown": max_drawdown(df['Price'].values),
            "CAGR": cagr(df['Price'].values),
            "Volatility (Ann)": annualized_volatility(df['Return'].dropna())
        }
        return json(metrics)

    async def prices(self, request: Request) -> HTTPResponse:
        df = generate_price_walk()
        return json(df.to_dict(orient="records"))

    async def montecarlo(self, request: Request) -> HTTPResponse:
        return json(await MonteCarlo().generate())
