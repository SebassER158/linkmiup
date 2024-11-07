import 'package:flutter/material.dart';
import 'package:linkmiup/inescreen.dart';

class GuiaScreen extends StatefulWidget {
  const GuiaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GuiaScreenState createState() => _GuiaScreenState();
}

class _GuiaScreenState extends State<GuiaScreen> {
  final PageController _pageController = PageController();
  bool _acceptedTerms = false;
  int _currentPage = 0;

  final List<String> _images = [
    'assets/guide_image_1.png',
    'assets/guide_image_2.png',
    'assets/guide_image_3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Carrusel de imágenes
          PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(
                _images[index],
                fit: BoxFit.contain,
              );
            },
          ),
          // Indicadores de página
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _images.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == entry.key ? Colors.blue : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ),
          // Términos y condiciones y botón de avanzar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: const Color.fromARGB(255, 2, 58, 143), // Color verde azulado
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Switch(
                        value: _acceptedTerms,
                        onChanged: (bool value) {
                          setState(() {
                            _acceptedTerms = value;
                          });
                        },
                        activeColor: Colors.white,
                      ),
                      const Expanded(
                        child: Text(
                          'Acepto los términos y condiciones',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _acceptedTerms ? () {
                      // Navegar a la siguiente pantalla
                      // Navigator.of(context).pushReplacementNamed('/take_photo');
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => IneScreen()),
                      );
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _acceptedTerms ? Colors.white : Colors.blue[900],
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text('Avanzar', style: TextStyle(color: _acceptedTerms ? Colors.blue[900] : Colors.grey),),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}