import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:test/main.dart';

void main() {
  testWidgets('Test de navigation', (WidgetTester tester) async {
    // Construire le widget principal
    await tester.pumpWidget(const MonApplication());
    // Vérifier que la page d'accueil est affichée
    expect(find.text('Liste des étudiants'), findsOneWidget);
    // Simuler une navigation vers une autre page
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();
    // Ajouter d'autres tests d'intégration générale ici
    expect(
      find.text('Liste des étudiants et de leurs moyennes :'),
      findsOneWidget,
    );
  });
}
