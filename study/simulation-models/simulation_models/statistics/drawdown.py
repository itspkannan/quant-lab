import numpy as np


def max_drawdown(prices):
    cumulative = np.maximum.accumulate(prices)
    drawdown = (prices - cumulative) / cumulative
    return drawdown.min()
