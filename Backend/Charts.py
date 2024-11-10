# Charts.py

import plotly.graph_objects as go
import plotly.io as pio
from io import BytesIO
from IPython.display import SVG

def makeChart(labels, data):
    """
    Creates a radar chart with the given labels and data, and saves it as an SVG in memory.

    Parameters:
    - labels: List of strings representing each axis label.
    - data: List of values corresponding to each label.

    Returns:
    - img_bytes: BytesIO object containing the SVG data.
    """
    labels = labels + [labels[0]]
    data = data + [data[0]]
    
    fig = go.Figure(
        data=go.Scatterpolar(
            r=data,
            theta=labels,
            fill='toself',
            name='Data'
        )
    )

    fig.update_layout(
        polar=dict(
            radialaxis=dict(
                visible=True,
                range=[0, max(data)]
            )
        ),
    )
    
    img_bytes = BytesIO()
    img_bytes.write(pio.to_image(fig, format="svg"))
    img_bytes.seek(0)  

    return img_bytes

