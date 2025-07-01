import plotly.graph_objs as go
from plotly.subplots import make_subplots
from scipy.stats import norm
import numpy as np

def build_dashboard(df, metrics):
    fig = make_subplots(
        rows=2, cols=2,
        subplot_titles=("Price Animation", "Return Distribution",
                        "Rolling Volatility", "Metrics"),
        specs=[[{"type": "scatter"}, {"type": "xy"}],
               [{"type": "scatter"}, {"type": "table"}]]
    )

    frames = [go.Frame(data=[go.Scatter(y=df['Price'][:k+1])]) for k in range(1, len(df))]
    fig.add_trace(go.Scatter(y=[df['Price'][0]], mode='lines', name='Price'), row=1, col=1)

    returns = df['Return'].dropna()
    x_range = np.linspace(returns.min(), returns.max(), 100)
    pdf = norm.pdf(x_range, returns.mean(), returns.std())
    fig.add_trace(go.Histogram(x=returns, nbinsx=50, histnorm='probability density'), row=1, col=2)
    fig.add_trace(go.Scatter(x=x_range, y=pdf, mode='lines', name="Normal"), row=1, col=2)

    fig.add_trace(go.Scatter(y=df['Volatility'], name="Volatility"), row=2, col=1)

    fig.add_trace(go.Table(
        header=dict(values=["Metric", "Value"]),
        cells=dict(values=[
            list(metrics.keys()),
            [f"{v:.4f}" if isinstance(v, float) else v for v in metrics.values()]
        ])
    ), row=2, col=2)

    fig.frames = frames
    fig.update_layout(
        title="Random Walk Price Dashboard (Animated)",
        updatemenus=[dict(
            type="buttons",
            buttons=[dict(label="Play", method="animate", args=[None, {"frame": {"duration": 40, "redraw": True}}])]
        )],
        height=800,
        showlegend=False
    )

    return fig

def save_dashboard_html(fig, output_path="plot.html"):
    fig.write_html(output_path, include_plotlyjs='cdn', full_html=True)
