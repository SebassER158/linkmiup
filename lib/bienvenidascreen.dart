import 'package:flutter/material.dart';
import 'dart:math';

import 'package:linkmiup/guiascreen.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.grey[300]!],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              size: const Size(150, 150),
              painter: SquaresPainter(),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón de retroceso
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/btl_logo.png', width: 120),
                        const SizedBox(height: 24),
                        const Text(
                          'Bienvenido',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'LINKMI',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue[900],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'LINKMI te permitirá agilizar tu contratación en cuestión de minutos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Spacer(),
                        // Botón Seguir
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const GuiaScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900],
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                            child: const Text('Seguir', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Texto "TU MEJOR ALIADO"
                        Center(
                          child: Text(
                            'TU MEJOR ALIADO',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter para dibujar los cuadrados en la esquina superior derecha
class SquaresPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[900]!
      ..style = PaintingStyle.fill;

    final random = Random();
    for (int i = 0; i < 10; i++) {
      final square = Rect.fromLTWH(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
        random.nextDouble() * 20 + 5,
        random.nextDouble() * 20 + 5,
      );
      canvas.drawRect(square, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}