import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageTextExtractor extends StatefulWidget {
  @override
  _ImageTextExtractorState createState() => _ImageTextExtractorState();
}

class _ImageTextExtractorState extends State<ImageTextExtractor> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String _extractedText = "";

  Future<void> _pickImageAndExtractText() async {
    setState(() {
      _isLoading = true;
    });

    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      File _image = File(photo.path);
      Uint8List imageBytes = await _image.readAsBytes();

      final inputImage = InputImage.fromFilePath(photo.path);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();

      try {
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
        setState(() {
          _extractedText = recognizedText.text;
        });
      } catch (e) {
        setState(() {
          _extractedText = "Error al procesar la imagen: $e";
        });
      } finally {
        textRecognizer.close();
      }
    } else {
      setState(() {
        _extractedText = "No se seleccionó ninguna imagen";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Extracción de Texto de Imagen')),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _pickImageAndExtractText,
                    child: Text('Seleccionar Imagen'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _extractedText.isNotEmpty
                        ? 'Texto extraído: $_extractedText'
                        : 'Seleccione una imagen para extraer el texto',
                  ),
                ],
              ),
      ),
    );
  }
}
