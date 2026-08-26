import tensorflow as tf
import numpy as np
from app.utils.preprocessing import preprocess
from app.utils.postprocessing import postprocess

interpreter = tf.lite.Interpreter(model_path='app/model/model.tflite')
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

def run_inference(image):
    original_height, original_width = image.shape[:2]
    input_image = preprocess(image, (640, 640))
    if input_image is None:
        return np.array([]), np.array([]), np.array([])
    interpreter.set_tensor(input_details[0]['index'], input_image)
    interpreter.invoke()
    outputs = [interpreter.get_tensor(output_details[0]['index'])]
    boxes, scores, class_ids = postprocess(outputs, original_width, original_height, conf_threshold=0.50, nms_threshold=0.5)
    return boxes, scores, class_ids
