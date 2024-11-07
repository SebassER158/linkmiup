import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:convert';

class CamaraScreen extends StatefulWidget {
  const CamaraScreen({Key? key}) : super(key: key);

  @override
  _CamaraScreenState createState() => _CamaraScreenState();
}

class _CamaraScreenState extends State<CamaraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isProcessing = false;
  CameraDescription? camera;

  final credentialsJson = {
    "type": "service_account",
    "project_id": "linkmiine",
    // Las credenciales continúan aquí...
  };

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    setState(() {
      camera = cameras.first;
      _controller = CameraController(
        camera!,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller.initialize();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      await _initializeControllerFuture;
      // Implementación de la captura de la imagen
    } catch (e) {
      print('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al capturar la imagen: $e')));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<Map<String, String>> _extractDataFromImage(Uint8List imageData) async {
    try {
      final credentials = auth.ServiceAccountCredentials.fromJson(credentialsJson);
      final client = await auth.clientViaServiceAccount(credentials, [vision.VisionApi.cloudVisionScope]);
      final visionApi = vision.VisionApi(client);

      // Implementación de la extracción de datos...

      client.close();
      return {"Resultado": "Datos extraídos con éxito"};
    } catch (e) {
      print('Error en _extractDataFromImage: $e');
      return {"Error": e.toString()};
    }
  }

  @override
  Widget build(BuildContext context) {
    if (camera == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: Text('Capturar INE')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isProcessing ? null : _takePicture,
        child: Icon(_isProcessing ? Icons.hourglass_empty : Icons.camera_alt),
      ),
    );
  }
}
