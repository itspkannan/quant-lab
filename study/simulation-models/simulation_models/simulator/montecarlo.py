import numpy as np

class MonteCarlo:
    def __init__(self, initial_price: float = 100.0, expected_return: float = 0.04, volatility: float = 0.2, time_step: int = 252,
                 num_simulation: int = 50, time_horizon: float = 1.0):
        """


        :param initial_price:   S₀: Initial stock price
        :param expected_return:   μ: Expected return
        :param volatility:  σ: Volatility
        :param time_step: Number of time steps (e.g., trading days)
        :param num_simulation: Number of simulated paths
        :param time_horizon: Time horizon in years
        """
        self.initial_price: float = initial_price
        self.expected_return: float = expected_return
        self. volatility: float = volatility
        self.time_step: int = time_step
        self.paths: int = num_simulation
        self.time_horizon: float = time_horizon

    @property
    def dt(self) -> float:
        return self.time_horizon / self.time_step

    async def generate(self) -> dict[str, list[list[float]]]:
        simulations = []

        for _ in range(self.paths):
            prices = [self.initial_price]
            for _ in range(1, self.time_step + 1):
                Z = np.random.normal()
                prev = prices[-1]
                next_price = prev * np.exp(
                    (self.expected_return - 0.5 * self.volatility ** 2) * self.dt +
                    self.volatility * np.sqrt(self.dt) * Z
                )
                prices.append(next_price)
            simulations.append(prices)

        return {
            "paths": simulations,
            "steps": self.time_step
        }
