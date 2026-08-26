import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../services/api_service.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  bool _isLoading = false;

  final ImagePicker picker = ImagePicker();

  Future<void> _getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (!mounted) return;

    if (pickedFile != null) {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        minWidth: 1280,
        minHeight: 720,
        quality: 80,
      );
      if (compressedBytes != null) {
        final compressedFilePath = '${pickedFile.path}_compressed.jpg';
        final compressedFile = File(compressedFilePath);
        await compressedFile.writeAsBytes(compressedBytes);

        setState(() {
          _image = compressedFile;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;

    if (pickedFile != null) {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        minWidth: 1280,
        minHeight: 720,
        quality: 80,
      );
      if (compressedBytes != null) {
        final compressedFilePath = '${pickedFile.path}_compressed.jpg';
        final compressedFile = File(compressedFilePath);
        await compressedFile.writeAsBytes(compressedBytes);

        setState(() {
          _image = compressedFile;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _detectHoles() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final bytes = await _image!.readAsBytes();
      final result = await ApiService.detectHolesInImage(bytes);

      if (!mounted) return;

      Navigator.pushNamed(context, '/detection', arguments: result);
    } catch (e) {
      debugPrint('Hata: $e');
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hata'),
          content: const Text('Görseli işlerken bir hata oluştu.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kumaş Delik Tespiti',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _image != null
                  ? Image.file(_image!)
                  : const Text('Görsel seçiniz veya çekiniz'),
            ),
          ),
          if (_isLoading) const LoadingIndicator(),
          if (!_isLoading)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _getImageFromCamera,
                      icon: const Icon(Icons.camera),
                      label: const Text(
                        'Kamerayla çek',
                        style: TextStyle(fontFamily: 'Alice', fontWeight: FontWeight.w600),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _getImageFromGallery,
                      icon: const Icon(Icons.photo),
                      label: const Text(
                        'Galeriden seç',
                        style: TextStyle(fontFamily: 'Alice', fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _detectHoles,
                  child: const Text('Delikleri Tespit Et',
                    style: TextStyle(fontFamily: 'Alice', fontSize: 21, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
        ],
      ),
    );
  }
}
