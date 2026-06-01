import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex_app/auth_screen.dart';

void main() {
  testWidgets('AuthScreen exibe formulario de login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(debugShowCheckedModeBanner: false, home: AuthScreen()),
    );

    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
