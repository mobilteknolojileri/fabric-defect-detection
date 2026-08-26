import cv2
import numpy as np

def preprocess(image, input_shape):
    try:
        image_resized = cv2.resize(image, input_shape, interpolation=cv2.INTER_LINEAR)
        image_yuv = cv2.cvtColor(image_resized, cv2.COLOR_BGR2YUV)
        image_yuv[:, :, 0] = cv2.equalizeHist(image_yuv[:, :, 0])
        image_eq = cv2.cvtColor(image_yuv, cv2.COLOR_YUV2BGR)
        image_rgb = cv2.cvtColor(image_eq, cv2.COLOR_BGR2RGB)
        image_normalized = image_rgb / 255.0
        image_transposed = np.transpose(image_normalized, (2, 0, 1))
        image_expanded = np.expand_dims(image_transposed, axis=0).astype(np.float32)
        return image_expanded
    except Exception:
        return None
