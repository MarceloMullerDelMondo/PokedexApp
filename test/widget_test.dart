import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/home_screen.dart';

void main() {
  testWidgets('HomeScreen exibe lista de Pokémon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
    );

    // Verifica que os três Pokémon aparecem na tela
    expect(find.text('Gengar'), findsOneWidget);
    expect(find.text('Charizard'), findsOneWidget);
    expect(find.text('Pikachu'), findsOneWidget);
  });
}
