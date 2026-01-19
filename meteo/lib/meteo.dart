import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'donnees.dart';

class PrevisionsMeteoPage extends StatefulWidget {
  const PrevisionsMeteoPage({super.key});

  @override
  State<PrevisionsMeteoPage> createState() => _PrevisionsMeteoPageState();
}

class _PrevisionsMeteoPageState extends State<PrevisionsMeteoPage> {
  final String _apiKey =
      "c1a8a9ffcf1eb7a187b6dd8a7e0bf520"; // Remplacez par votre clé
  bool _isLoading = false;
  Map<String, dynamic>? _donneesMeteo;

  // Recherche de villes pour l'auto-complétion
  Future<Iterable<String>> _rechercherVilles(String query) async {
    if (query.length < 3) return const Iterable<String>.empty();
    final url = Uri.parse(
      'http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$_apiKey',
    );
    try {
      final reponse = await http.get(url);
      if (reponse.statusCode == 200) {
        final List villes = json.decode(reponse.body);
        return villes.map((v) => "${v['name']}, ${v['country']}");
      }
    } catch (e) {
      return const Iterable<String>.empty();
    }
    return const Iterable<String>.empty();
  }

  // Récupération des prévisions complètes
  Future<void> _recupererMeteo(String ville) async {
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?q=$ville&appid=$_apiKey&units=metric&lang=fr',
    );
    try {
      final reponse = await http.get(url);
      if (reponse.statusCode == 200) {
        setState(() {
          _donneesMeteo = json.decode(reponse.body);
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Météo Pro")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Autocomplete<String>(
              optionsBuilder: (textValue) => _rechercherVilles(textValue.text),
              onSelected: (selection) => _recupererMeteo(selection),
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: "Entrez une ville...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    );
                  },
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_donneesMeteo != null)
            Expanded(child: DonneesMeteoWidget(donneesMeteo: _donneesMeteo!))
          else
            const Expanded(
              child: Center(
                child: Text("Recherchez une ville pour voir la météo."),
              ),
            ),
        ],
      ),
    );
  }
}
