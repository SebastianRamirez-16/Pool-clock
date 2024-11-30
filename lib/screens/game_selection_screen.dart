import 'package:flutter/material.dart';

class GameSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona el Modo de Juego'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildGameCard(
              context,
              title: 'Bola 8',
              imagePath: 'assets/images/bola8.png',
              onTap: () {
                Navigator.pushNamed(context, '/bola8');
              },
            ),
            _buildGameCard(
              context,
              title: 'Bola 9',
              imagePath: 'assets/images/bola9.png',
              onTap: () {
                Navigator.pushNamed(context, '/bola9');
              },
            ),
            _buildGameCard(
              context,
              title: 'Bola 10',
              imagePath: 'assets/images/bola10.png',
              onTap: () {
                Navigator.pushNamed(context, '/bola10');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context,
      {required String title,
      required String imagePath,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
