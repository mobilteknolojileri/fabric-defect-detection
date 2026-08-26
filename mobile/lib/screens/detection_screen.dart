import 'dart:convert';
import 'package:flutter/material.dart';

class DetectionScreen extends StatelessWidget {
  const DetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> detectionResult =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String? imageBase64 = detectionResult['image'] as String?;
    final List<dynamic>? detections =
        detectionResult['detections'] as List<dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tespit Sonucu',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color.fromARGB(255, 17, 142, 244),
      ),
      backgroundColor: Colors.blue[400],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (imageBase64 != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(base64Decode(imageBase64)),
                  ),
                ),
              const SizedBox(height: 20),
              if (detections != null && detections.isNotEmpty)
                detections.length == 1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.check_circle,
                              color: Color.fromARGB(255, 0, 253, 13),
                              size: 32,
                            ),
                            title: const Text(
                              '1 delik tespit edildi.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 12, 101, 255),
                              ),
                            ),
                            subtitle: Text(
                              'Doğruluk Oranı: %${(detections[0]['score'] * 100).toInt()}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(223, 0, 0, 0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: detections.asMap().entries.map((entry) {
                          final int index = entry.key + 1;
                          final double score = entry.value['score'] as double;
                          final int accuracy = (score * 100).toInt();

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              color: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.check_circle,
                                  color: Color.fromARGB(255, 0, 242, 12),
                                  size: 32,
                                ),
                                title: Text(
                                  '$index. Delik tespit edildi',
                                  style: const TextStyle(
                                    fontSize: 18.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 6, 97, 255),
                                  ),
                                ),
                                subtitle: Text(
                                  'Doğruluk Oranı: %$accuracy',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(221, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
              else
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Hiç delik tespit edilmedi.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
