import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:linkmiup/infoscreen.dart';

class IneScreen extends StatefulWidget {
  const IneScreen({Key? key}) : super(key: key);

  @override
  _IneScreenState createState() => _IneScreenState();
}

class _IneScreenState extends State<IneScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  String _extractedText = "";
  List<String> _detectedWords = [];
  Map<String, String> extractedInfo = {
    'Nombre': '',
    'Apellido Paterno': '',
    'Apellido Materno': '',
    'CURP': '',
    'Código Postal': '',
    'Fecha de Nacimiento': '',
    'Sexo': '',
  };

  // Lista para los selectores
  Map<String, String?> selectedValues = {
    'Nombre': null,
    'Apellido Paterno': null,
    'Apellido Materno': null,
    'CURP': null,
    'Código Postal': null,
    'Fecha de Nacimiento': null,
    'Sexo': null,
  };

  Future<void> _takePhoto() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

      if (photo != null) {
        final inputImage = InputImage.fromFilePath(photo.path);
        final textRecognizer = GoogleMlKit.vision.textRecognizer();

        try {
          final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
          setState(() {
            _extractedText = recognizedText.text;
            _detectedWords = _extractedText.split(RegExp(r'\s+'));
            _extractInformation(_extractedText);
          });
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => InfoScreen(extractedText: _extractedText),
            ),
          );

        } catch (e) {
          setState(() {
            _errorMessage = "Error al procesar la imagen: $e";
          });
        } finally {
          textRecognizer.close();
        }
      } else {
        setState(() {
          _extractedText = "No se seleccionó ninguna imagen";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error al procesar la imagen: $e";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Método para extraer información usando expresiones regulares
  void _extractInformation(String text) {
    RegExp curpRegex = RegExp(r'([A-Z]{4}\d{6}[HM][A-Z]{5}\d{2})');
    RegExp cpRegex = RegExp(r'CP[:\s]?(\d{5})');
    RegExp fechaNacimientoRegex = RegExp(r'(\d{2}/\d{2}/\d{4})');
    RegExp sexoRegex = RegExp(r'\b(HOMBRE|MUJER)\b');

    // Extraer CURP
    var curpMatch = curpRegex.firstMatch(text);
    if (curpMatch != null) {
      extractedInfo['CURP'] = curpMatch.group(1)!.trim();
    }

    // Extraer Código Postal
    var cpMatch = cpRegex.firstMatch(text);
    if (cpMatch != null) {
      extractedInfo['Código Postal'] = cpMatch.group(1)!.trim();
    }

    // Extraer Fecha de Nacimiento
    var fechaMatch = fechaNacimientoRegex.firstMatch(text);
    if (fechaMatch != null) {
      extractedInfo['Fecha de Nacimiento'] = fechaMatch.group(1)!.trim();
    }

    // Extraer Sexo
    var sexoMatch = sexoRegex.firstMatch(text);
    if (sexoMatch != null) {
      extractedInfo['Sexo'] = sexoMatch.group(1)!.trim();
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 2, 97),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Empecemos!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Es hora de tomar una foto de tu INE',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                child: const Text('Tomar Foto', style: TextStyle(color: Color.fromARGB(255, 10, 2, 97))),
                onPressed: _isLoading ? null : _takePhoto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4A3AFF),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red[300], fontSize: 16),
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
