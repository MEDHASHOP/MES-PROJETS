import 'package:flutter/material.dart';
import 'graphique.dart';

class DonneesMeteoWidget extends StatelessWidget {
  final Map<String, dynamic> donneesMeteo;
  const DonneesMeteoWidget({super.key, required this.donneesMeteo});

  BoxDecoration _getDesign(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orange, Colors.blueAccent]),
        );
      case 'rain':
        return const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blueGrey, Colors.black87]),
        );
      default:
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = donneesMeteo['list'] as List;
    final condition = list[0]['weather'][0]['main'];

    return Container(
      decoration: _getDesign(condition),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            donneesMeteo['city']['name'],
            style: const TextStyle(
              fontSize: 35,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "${list[0]['main']['temp']}°C",
            style: const TextStyle(fontSize: 70, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Image.network(
            "https://openweathermap.org/img/wn/${list[0]['weather'][0]['icon']}@4x.png",
            height: 120,
          ),

          const SizedBox(height: 20),
          const Text(
            "Tendance Température",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 180,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: GraphiqueMeteo(previsions: list),
          ),

          const Text(
            "Prévisions 5 jours",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          for (int i = 0; i < 5; i++) ...[
            Card(
              color: Colors.white.withValues(alpha: 0.1),
              child: ListTile(
                leading: Image.network(
                  "https://openweathermap.org/img/wn/${list[i * 8]['weather'][0]['icon']}.png",
                ),
                title: Text(
                  "Jour ${i + 1}",
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  "${list[i * 8]['main']['temp']}°C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
