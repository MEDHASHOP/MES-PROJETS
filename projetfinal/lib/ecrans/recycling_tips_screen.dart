import 'package:flutter/material.dart';
import '../data/donnees_test.dart';

class RecyclingTipsScreen extends StatelessWidget {
  const RecyclingTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text('Conseils de recyclage'),
          ],
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: conseilsTest.length,
        itemBuilder: (context, index) {
          final conseil = conseilsTest[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Text(
                  conseil.icone,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              title: Text(
                conseil.titre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    conseil.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}