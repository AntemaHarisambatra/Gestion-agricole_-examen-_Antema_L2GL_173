import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_2_examen/main.dart';

void main() {
  testWidgets('L’application affiche l’écran de connexion avec le titre', (
    tester,
  ) async {
    await tester.pumpWidget(const FarmApp());

    expect(find.text('Gestion agricole'), findsOneWidget);
    expect(find.text('Connexion'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
  });
}
