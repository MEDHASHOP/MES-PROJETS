import 'package:flutter/material.dart';
import 'meteo.dart';

void main() {
  runApp(const MonAppMeteo());
}

class MonAppMeteo extends StatelessWidget {
  const MonAppMeteo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application Météo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const PrevisionsMeteoPage(),
    );
  }
}
