import 'package:flutter/material.dart';

import '../models/livre.dart';
import '../services/api_service.dart';
import '../widgets/disponibilite_chip.dart';
import 'reservation_screen.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.livre, required this.api});

  final Livre livre;
  final ApiService api;

  @override
  Widget build(BuildContext context) {
    final textes = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(livre.titre)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(livre.titre, style: textes.headlineSmall),
          const SizedBox(height: 4),
          Text(livre.auteur, style: textes.titleMedium),
          const SizedBox(height: 4),
          Text('Année : ${livre.annee ?? 'inconnue'}'),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: DisponibiliteChip(disponible: livre.disponible),
          ),
          const SizedBox(height: 16),
          Text('Résumé : ${livre.resume ?? "Aucun résumé disponible"}'),
          const SizedBox(height: 24),
          FilledButton.icon(
            // `null` désactive le bouton lorsque le livre est emprunté.
            onPressed: livre.disponible
                ? () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ReservationScreen(livre: livre, api: api),
                      ),
                    )
                : null,
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('Réserver'),
          ),
        ],
      ),
    );
  }
}
