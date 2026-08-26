import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://fabric-inspector-backend.onrender.com";

  static Future<Map<String, dynamic>> detectHolesInImage(Uint8List imageBytes) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/detect'));
    request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg'));

    final response = await request.send();
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);

    if (response.statusCode == 200) {
      return json.decode(responseString) as Map<String, dynamic>;
    } else {
      throw Exception('Delik tespiti API isteği başarısız oldu, durum kodu: ${response.statusCode}');
    }
  }
}
