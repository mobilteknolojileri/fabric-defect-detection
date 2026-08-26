import cv2
import numpy as np

def non_max_suppression(boxes, scores, nms_threshold):
    try:
        x1 = boxes[:, 0]
        y1 = boxes[:, 1]
        x2 = boxes[:, 2]
        y2 = boxes[:, 3]
        widths = x2 - x1
        heights = y2 - y1
        boxes_cv2 = np.stack([x1, y1, widths, heights], axis=1)
        score_threshold = 0.0
        indices = cv2.dnn.NMSBoxes(
            bboxes=boxes_cv2.tolist(),
            scores=scores.tolist(),
            score_threshold=score_threshold,
            nms_threshold=nms_threshold
        )
        if len(indices) == 0:
            return []
        indices = np.array(indices).flatten()
        return indices
    except Exception:
        return []

def postprocess(outputs, original_width, original_height, conf_threshold=0.2, nms_threshold=0.4):
    try:
        predictions = outputs[0]
        predictions = np.squeeze(predictions)
        predictions = predictions.transpose(1, 0)
        if predictions.ndim == 2:
            num_preds, num_cols = predictions.shape
            if num_cols == 5:
                boxes = predictions[:, :4]
                scores = predictions[:, 4]
                class_ids = np.zeros_like(scores, dtype=int)
            else:
                return np.array([]), np.array([]), np.array([])
            conf_mask = scores > conf_threshold
            boxes = boxes[conf_mask]
            scores = scores[conf_mask]
            class_ids = class_ids[conf_mask]
            scale_x = original_width / 640
            scale_y = original_height / 640
            x_center = boxes[:, 0] * scale_x
            y_center = boxes[:, 1] * scale_y
            width = boxes[:, 2] * scale_x
            height = boxes[:, 3] * scale_y
            x1 = x_center - width / 2
            y1 = y_center - height / 2
            x2 = x_center + width / 2
            y2 = y_center + height / 2
            boxes_xyxy = np.stack([x1, y1, x2, y2], axis=1)
            if len(boxes_xyxy) > 0:
                indices_nms = non_max_suppression(boxes_xyxy, scores, nms_threshold)
                if len(indices_nms) > 0:
                    boxes_xyxy = boxes_xyxy[indices_nms]
                    scores = scores[indices_nms]
                    class_ids = class_ids[indices_nms]
                else:
                    boxes_xyxy = np.array([])
                    scores = np.array([])
                    class_ids = np.array([])
            else:
                boxes_xyxy = np.array([])
                scores = np.array([])
                class_ids = np.array([])
            return boxes_xyxy, scores, class_ids
        else:
            return np.array([]), np.array([]), np.array([])
    except Exception:
        return np.array([]), np.array([]), np.array([])
