class DetectionResult {
  final String image;
  final List<Detection> detections;

  DetectionResult({required this.image, required this.detections});

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    var detectionList = json['detections'] as List;
    List<Detection> detections = detectionList.map((i) => Detection.fromJson(i)).toList();

    return DetectionResult(
      image: json['image'],
      detections: detections,
    );
  }
}

class Detection {
  final List<int> box;
  final double score;

  Detection({required this.box, required this.score});

  factory Detection.fromJson(Map<String, dynamic> json) {
    return Detection(
      box: List<int>.from(json['box']),
      score: json['score'].toDouble(),
    );
  }
}
