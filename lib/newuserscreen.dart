import 'package:flutter/material.dart';
import 'package:linkmiup/camara/camarascreen.dart';

class NewUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario Nuevo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Tienes tu INE a la mano?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CamaraScreen()),
                );
              },
              child: Text('Registrar con INE'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla de registro manual
              },
              child: Text('Registro Manual'),
            ),
          ],
        ),
      ),
    );
  }
}
