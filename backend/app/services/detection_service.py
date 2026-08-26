import cv2
import base64
import numpy as np
from app.utils.inference import run_inference

def detect_holes(image_bytes):
    np_arr = np.frombuffer(image_bytes, np.uint8)
    image = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)
    boxes, scores, class_ids = run_inference(image)
    processed_image = draw_boxes(image, boxes, scores, class_ids)
    _, buffer = cv2.imencode('.jpg', processed_image)
    encoded_image = base64.b64encode(buffer).decode()
    detections = []
    for box, score in zip(boxes, scores):
        x1, y1, x2, y2 = box.astype(int)
        detections.append({
            "box": [int(x1), int(y1), int(x2), int(y2)],
            "score": float(score)
        })
    return encoded_image, detections
def draw_boxes(image, boxes, scores, class_ids):
    for idx, box in enumerate(boxes):
        x1, y1, x2, y2 = box.astype(int)
        x1 = max(0, x1)
        y1 = max(0, y1)
        x2 = min(image.shape[1] - 1, x2)
        y2 = min(image.shape[0] - 1, y2)

        cv2.rectangle(image, (x1, y1), (x2, y2), (0, 0, 255), 3)

        label = f'Delik {idx + 1}'
        font_scale = 0.8
        thickness = 2
        cv2.putText(image, label, (x1, y1 - 10),
                    cv2.FONT_HERSHEY_SIMPLEX, font_scale, (0, 0, 255), thickness, cv2.LINE_AA)
    return image
