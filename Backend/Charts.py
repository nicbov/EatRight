import plotly.graph_objects as go
from io import BytesIO
import plotly.io as pio

def makeChart(labels, data):
    labels = labels + [labels[0]]  # Close the radar chart
    data = data + [data[0]]  # Close the radar chart

    fig = go.Figure(
        data=go.Scatterpolar(
            r=data,
            theta=labels,
            fill='toself',
            name='Data'
        )
    )

    # Update layout with larger label text and hide scale numbers
    fig.update_layout(
        polar=dict(
            radialaxis=dict(
                visible=True,
                range=[0, max(data)],
                showticklabels=False  # Hide numbers on the scale
            ),
            angularaxis=dict(
                tickfont=dict(
                    size=18,  # Set label font size
                    color="black"  # Optionally set the color of the label
                )
            )
        ),
    )

    # Save the figure as an SVG to a BytesIO object
    img_bytes = BytesIO()
    img_bytes.write(pio.to_image(fig, format="svg"))
    img_bytes.seek(0)

    return img_bytes

