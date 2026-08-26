from datetime import datetime

from fastapi import FastAPI, File, UploadFile
from fastapi.responses import HTMLResponse

from app.services.detection_service import detect_holes

app = FastAPI()


@app.get("/", response_class=HTMLResponse)
def read_root():
    html_content = f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kumaş Delik Tespit API</title>
        <link rel="icon" href="https://cdn-icons-png.freepik.com/256/9733/9733176.png?semt=ais_hybrid" type="image/png">
        <style>
            body {{
                font-family: Arial, sans-serif;
                background-color: #f4f4f9;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }}
            .container {{
                text-align: center;
                background: white;
                padding: 40px 80px;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }}
            h1 {{
                color: black;
                font-size: 24px;
                margin-bottom: 10px;
            }}
            p {{
                color: black;
                font-size: 18px;
                margin: 5px 0;
            }}
            .timestamp {{
                font-style: italic;
                color: black;
                font-size: 14px;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Kumaş Delik Tespit API</h1>
            <p>Backend şu anda çalışıyor.</p>
            <p class="timestamp">Son kontrol: {datetime.now().strftime('%d-%m-%Y %H:%M:%S')}</p>
        </div>
    </body>
    </html>
    """
    return html_content


@app.post("/detect")
async def detect(file: UploadFile = File(...)):
    image_bytes = await file.read()
    processed_image, detections = detect_holes(image_bytes)
    return {"detections": detections, "image": processed_image}
