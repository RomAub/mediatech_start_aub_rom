# Rapport de corrections – NOM Prénom

Une ligne par anomalie corrigée. Soyez précis : une explication correcte vaut autant que la correction.

Exemple (sans rapport avec ce projet) :

| N° | Fichier | Symptôme observé | Cause | Correction apportée |
| --- | --- | --- | --- | --- |
| 0 | `lib/exemple.dart` | L'écran reste blanc au lancement | Le widget racine renvoie `Container()` sans enfant | Retourne `Scaffold(...)` avec le contenu |

À vous :

| N° | Fichier | Symptôme observé | Cause | Correction apportée |
| --- | --- | --- | --- | --- |
| 1 | `detail_screen` | Bouton de reservation grisé lorsqu'il est disponible et activé lorsqu'il est emprunté |  condition inversé `onPressed: !livre.disponible` | enlevé le `!`|

| 2 | `reservation_screen.dart` | La reservation pointe sur le mauvais livre (le livre d'après) | `livreId: widget.livre.id + 1` contient un +1 inutile| Il suffit de l'enlever |

| 3 | `detail_screen` | Si le livre n'a aucun resumé, il est écris "null" | Il n'y a pas de check si la valeur est null | Ajout d'un case si resumé est null code de base : `Text('Résumé : ${livre.resume}'),` code modifié : `Text('Résumé : ${livre.resume ?? "Aucun résumé disponible"}'),`|

| 4 | `livre_tile.dart` | Si l'année d'un livre est null, il affiche (0) sur le menu principale | Il est mis "0" si nul `subtitle: Text('${livre.auteur} (${livre.annee ?? 0})'),` | `subtitle: Text('${livre.auteur} (${livre.annee ?? "Année inconnue"})'),` Message plus clair |

| 5 | `catalogue_screen.dart` | Il manque 1 livre au premier chargement | Il y a un "-1" en trop dans `itemCount: _livres.length - 1,` | On enléve le "-1" `itemCount: _livres.length,`|

| 6 | `catalogue_screen.dart` | a chaque rechargement, l'ancienne liste reste et les livres s'empilent en double | `_livres = [..._livres, ...livres];` fusionne la nouvelle liste à l'ancienne au lieu de la remplacer | Remplacer par `_livres = livres;` |

| 7 | `reservation_screen.dart` | Le nom et l'e-mail du client apparaissent dans les logs | `debugPrint('Réservation de ${_nomCtrl.text} <${_emailCtrl.text}>...')` | Retiré le nom et l'e-mail du log : `debugPrint('Réservation en cours pour le livre ${widget.livre.id}');` |

| 8 | `catalogue_screen.dart` | En cas d'erreur réseau, la liste déjà affichée disparaît et la barre d'avertissement ne s'affiche jamais | dans `_signalerErreur`, `_livres = []` vide la liste avant le test `if (_livres.isNotEmpty)`, qui est donc toujours false | tester `_livres.isNotEmpty` si une liste existe, on la garde et on affiche le SnackBar sinon on bascule sur l'erreur |

| 9 | `reservation_screen.dart` | un nom avec uniquement des espaces est accepté par le formulaire, puis refusé par le serveur (422) | `_validerNom` teste `valeur.isEmpty` (sans trim) alors que le serveur teste `nom.strip()` : "`  `" passe côté client | tester `valeur.trim().isEmpty` pour s'aligner sur le serveur |

| 10 | `api_service.dart` | En cas d'erreur, le message affiché est le json brut (example: `{erreur: Données invalides., details: {...}}`) | `_detail` renvoie `corps.toString()` au lieu d'extraire les messages | construire un message lisible on prend `corps['erreur']` + toutes les valeurs de `corps['details']`, puis `parts.join(' ')` (repli sur le message par défaut si rien) |

| 11 | `reservation_screen.dart` | Le message de confirmation affiche l'auteur au lieu du titre du livre | `Text('Réservation confirmée pour « ${widget.livre.auteur} »')` utilise `auteur` | remplacer par `widget.livre.titre` |

| 12 | `reservation_screen.dart` | Le bouton reste cliquable pendant l'envoi -> double réservation possible (double clic) | `onPressed: _envoyer` n'est jamais désactivé pendant `_envoi` | `onPressed: _envoi ? null : _envoyer` |

| 13 | `reservation_screen.dart` | Des e-mails valides sont refusés (ceux avec chiffres, majuscules ou plusieurs points, example `castor87@gmail.com`) | La regex `^[a-z]+@[a-z]+\.[a-z]+$` n'autorise que des minuscules sans chiffre ni point multiple, bien plus stricte que le serveur | aligner sur le serveur : `RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')` |

| 14 | `reservation_screen.dart` | Si on quitte l'écran pendant l'envoi, la réservation réussie ferme par erreur l'écran de détail et renvoie au catalogue | Le chemin de succès de `_envoyer` ne vérifie pas `mounted` avant `navigateur.pop()` (contrairement aux blocs `catch`) | ajouter `if (!mounted) return;` juste après l'`await` de `reserver`, avant le SnackBar et le `pop()` |

| 15 |  |  |  | |

## État final

- `flutter analyze` : No issues found!
- `flutter test` : All tests passed! (9/9)
- Éventuelles anomalies repérées mais non corrigées, et pourquoi : aucune anomalie restante repérée. (Note : `flutter test` échoue si un proxy est actif pour localhost ; lancer avec `NO_PROXY=127.0.0.1,localhost` — ce n'est pas un bug de l'application.)

Parti 4 :

4.1

lib/
|-- main.dart
|-- models/
│   |--- livre.dart    
|-- services/
│   |-- api_config.dart         
│   |-- api_service.dart         
|-- widgets/
|   |-- disponibilite_chip.dart  
|    |-- livre_tile.dart 
|-- screens/
│   |-- catalogue_screen.dart  
│   |-- detail_screen.dart    
│   |-- reservation_screen.dart  

Les code d'appel API ne doivent pas être dans les widget d'écran pour empêcher les injections, on pourrais mettre les requête dans un dossier API
    
4.2

- 
- 
-

4.3