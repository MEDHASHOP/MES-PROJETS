import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'vue/endroits_interface.dart';
import 'vue/ajout_endroit.dart';

void main() {
  runApp(const ProviderScope(child: MonApplication()));
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mes endroits préférés',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => const EndroitsInterface(),
        '/ajout': (context) => const AjoutEndroitPage(),
        // detail route will be pushed with Navigator.push
      },
    );
  }
}
