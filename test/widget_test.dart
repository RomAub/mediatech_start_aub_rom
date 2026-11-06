import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mediatech/main.dart';
import 'package:mediatech/services/api_service.dart';

http.Response _json(Object corps, int code) => http.Response(
      jsonEncode(corps),
      code,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

ApiService _service(http.Response Function() reponse) => ApiService(
      client: MockClient((_) async => reponse()),
      baseUrl: 'http://test',
    );

final _troisLivres = [
  {
    'id': 1,
    'titre': 'Le Petit Prince',
    'auteur': 'Saint-Exupery',
    'annee': 1943,
    'resume': 'Un pilote rencontre un petit garcon.',
    'disponible': true,
  },
  {
    'id': 2,
    'titre': 'Les Miserables',
    'auteur': 'Victor Hugo',
    'annee': 1862,
    'resume': 'Le destin de Jean Valjean.',
    'disponible': false,
  },
  {
    'id': 3,
    'titre': 'Candide',
    'auteur': 'Voltaire',
    'annee': 1759,
    'resume': 'Le jeune Candide parcourt le monde.',
    'disponible': true,
  },
];

void main() {
  testWidgets('le catalogue affiche le titre et un livre', (tester) async {
    await tester.pumpWidget(
      MediaTechApp(api: _service(() => _json(_troisLivres, 200))),
    );
    await tester.pumpAndSettle();

    expect(find.text('MediaTech'), findsOneWidget);
    expect(find.text('Le Petit Prince'), findsOneWidget);
  });

  testWidgets('une erreur serveur affiche un message et « Réessayer »',
      (tester) async {
    await tester.pumpWidget(
      MediaTechApp(api: _service(() => _json({'erreur': 'x'}, 500))),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('réessayez plus tard'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
  });

  testWidgets('une liste vide affiche un message dédié', (tester) async {
    await tester.pumpWidget(
      MediaTechApp(api: _service(() => _json([], 200))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aucun livre dans le catalogue.'), findsOneWidget);
  });

  testWidgets('un appui sur un livre ouvre son détail', (tester) async {
    await tester.pumpWidget(
      MediaTechApp(api: _service(() => _json(_troisLivres, 200))),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Le Petit Prince'));
    await tester.pumpAndSettle();

    expect(find.text('Année : 1943'), findsOneWidget);
  });
}
