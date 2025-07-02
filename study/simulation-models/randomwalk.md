# Random Walk Hypothesis Study

The **Random Walk Hypothesis** suggests that **stock prices move randomly and are not predictable** in the short term. This means past price movements **cannot be used** to forecast future prices.


## 🧩 Key Concepts

| Concept                               | Description                                                                                                                                            |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Random Walk**                       | A sequence where each step is random and independent of the previous one. In finance, it models asset prices.                                          |
| **Efficient Market Hypothesis (EMH)** | RWH is a **consequence** of EMH, especially its **weak form**, which states that all past price information is already reflected in the current price. |
| **Martingale Process**                | A stochastic process where the best prediction for tomorrow’s price is today’s price — often associated with RWH.                                      |


## 📉 Mathematical Formulation

Let $P_t$ be the stock price at time $t$, then:

$$
P_{t+1} = P_t + \epsilon_t
$$

Where:

* $\epsilon_t \sim N(0, \sigma^2)$ (normally distributed noise)
* Each $\epsilon_t$ is independent and identically distributed (i.i.d.)


## ✅ Implications

* **Technical analysis** is ineffective (since past patterns don’t repeat predictably).
* **Active management** is unlikely to consistently outperform the market.
* **Buy-and-hold strategies** are often advocated for long-term investors.


## 📊 Empirical Evidence

| Evidence Type  | Findings                                                                 |
| -------------- | ------------------------------------------------------------------------ |
| **Short-term** | Prices exhibit near-random movement; hard to beat market consistently.   |
| **Long-term**  | Some evidence of mean reversion or momentum (conflicting with pure RWH). |


## 🚫 Criticism

* **Behavioral finance** shows markets aren’t always rational (e.g., bubbles, overreactions).
* **Momentum strategies** sometimes outperform, suggesting patterns **do** exist temporarily.
* **Noise trading & anomalies** like January Effect challenge the hypothesis.


## 🧪 Testing Random Walk

Common statistical tests:

* **Runs Test** (tests randomness)
* **Autocorrelation** (tests for serial dependence)
* **Variance Ratio Test** (compares variance over different horizons)


## 🧭 Practical Use

| Domain               | Use                                                           |
| -------------------- | ------------------------------------------------------------- |
| **Finance**          | To design passive index strategies, risk-neutral simulations. |
| **Machine Learning** | Used as a baseline or null model for stock prediction.        |
| **Quant Research**   | Tests if a strategy truly beats randomness.                   |



