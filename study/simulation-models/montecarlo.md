
## Montecarlo Simulation

Monte Carlo simulation models the probabilistic behavior of complex systems by generating many random scenarios to estimate outcomes, commonly used in finance to simulate asset prices or value options.

### 🔢 Parameters

| Parameter       | Meaning                  | Role in Simulation                                                                        |
| --------------- | ------------------------ | ----------------------------------------------------------------------------------------- |
| **S₀** (`S0`)   | Initial stock price      | Starting price of the asset at time = 0                                                   |
| **μ** (`mu`)    | Expected return (drift)  | Average rate of return of the asset over time. Drives the upward trend in the simulation  |
| **σ** (`sigma`) | Volatility               | Standard deviation of returns. Controls randomness/fluctuation of the asset price         |
| **T**           | Time horizon             | Total time (in years) for which the simulation runs. Typically 1 year                     |
| **steps**       | Number of time intervals | The simulation divides the total time `T` into discrete steps (e.g., 252 trading days)    |
| **paths**       | Number of simulations    | Number of independent asset price paths to simulate (e.g., 50 different possible futures) |

---

### 📘 Example Context (Finance)

Say you're pricing a **European Call Option** or testing how a portfolio behaves under different market scenarios:

* `S0 = 100`: The stock is currently priced at \$100.
* `mu = 0.07`: You expect a 7% annual return.
* `sigma = 0.2`: The stock has 20% annual volatility.
* `T = 1`: You're simulating for the next 1 year.
* `steps = 252`: There are 252 trading days in a year.
* `paths = 50`: You want to simulate 50 different price evolutions (trajectories).

---

### 📈 Mathematical Background

Each price path is calculated using the **Geometric Brownian Motion (GBM)** model:

$$
S_t = S_0 \cdot \exp\left(\left(\mu - \frac{1}{2}\sigma^2\right)t + \sigma W_t \right)
$$

In discrete form (per step):

$$
S_{t+1} = S_t \cdot \exp\left((\mu - 0.5\sigma^2) \cdot \Delta t + \sigma \cdot \sqrt{\Delta t} \cdot Z \right)
$$

* $Z \sim \mathcal{N}(0, 1)$ is a random number from standard normal distribution.
