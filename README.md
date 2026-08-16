Nom     :   RAKOTONANDRIANINA
Prenom  :   Zionasoa Antema Harisambatra
Classe  :   L2GL
N°      :   173/LA

# Gestion agricole

Application mobile Flutter pour gérer une exploitation agricole.

## Fonctionnalités
- Parcelles
- Cultures
- Semences
- Engrais
- Récoltes
- Dépenses
- Rendements
- Authentification simple par e-mail / mot de passe
- Recherche et filtrage par écran
- CRUD complet dans SQLite local
- Tableau de bord de statistiques
- Validation des formulaires

## Démarrage rapide
1. Installer Flutter SDK 3.12+
2. Ouvrir le projet
3. Lancer :
	```bash
	flutter pub get
	flutter test
	flutter run
	```
4. Connectez-vous avec :
	- `admin@ferme.com` / `admin123`
	- `agriculteur@ferme.com` / `agri123`

## Structure du projet
```
lib/
  data/
  models/
  providers/
  screens/
main.dart
```

## Résumé des étapes réalisées

Voici un récapitulatif concis des actions effectuées durant le développement du projet :

- Inspection initiale du dépôt et vérification de l’environnement Flutter/Git.
- Mise à jour de `pubspec.yaml` : ajout des dépendances nécessaires (`sqflite`, `path`, `path_provider`, `provider`, `intl`).
- Conception des modèles métier dans `lib/models/farm_models.dart` (utilisateur, parcelle, culture, semence, engrais, récolte, dépense, rendement).
- Implémentation de la couche SQLite dans `lib/data/farm_database.dart` (création des tables, méthodes CRUD, jeux de données de démarrage).
- Implémentation du provider `lib/providers/farm_provider.dart` pour la gestion d'état, authentification simple et opérations CRUD centralisées.
- Développement des écrans et formulaires dans `lib/screens/farm_screens.dart` : écran de connexion, tableau de bord, listes, formulaires avec validation, recherche/filtrage, dialogues d'édition.
- Intégration du point d'entrée de l'application dans `lib/main.dart` et configuration de `Provider`.
- Ajout et exécution de tests unitaires/widget dans `test/widget_test.dart` (tests passés).
- Analyse statique et corrections (`flutter analyze`) pour garantir la qualité du code.
- Rédaction de la documentation technique et des diagrammes UML dans `docs/` (architecture, diagrammes mermaid).
- Préparation du `README.md` et des instructions d'utilisation.
- Initialisation d'un dépôt Git local (`git init`) — prêt à être poussé vers GitHub.

## Vérification effectuée
- Tests : `flutter test` (1 test métier exécuté et réussi)
- Analyse : `flutter analyze` (aucun problème restant)

## Prochaines options (je peux réaliser)
- Créer le dépôt GitHub distant et pousser le code.
- Préparer une build release / APK.
- Ajouter un backend API REST (Symfony/Node) avec JWT et synchronisation PostgreSQL.

---




