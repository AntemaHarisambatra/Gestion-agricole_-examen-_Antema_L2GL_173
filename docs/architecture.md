# Documentation technique

## Vue d’ensemble
Cette application suit une architecture légère et maintenable basée sur le pattern MVVM orienté Provider.

## Composants
- `main.dart` : point d’entrée de l’application
- `models/farm_models.dart` : modèles de domaine
- `data/farm_database.dart` : couche SQLite locale
- `providers/farm_provider.dart` : logique métier et gestion d’état
- `screens/farm_screens.dart` : écrans de navigation et formulaires

## Flux de donnée
1. L’utilisateur se connecte via l’écran d’authentification.
2. Le provider valide les identifiants.
3. Le provider charge les données SQLite et expose l’état à l’UI.
4. À chaque action CRUD, le provider met à jour la base et rafraîchit l’écran.

## Base de données
SQLite local avec tables :
- users
- parcels
- crops
- seeds
- fertilizers
- harvests
- expenses
- yield_records

## Sécurité
L’application utilise un mécanisme d’authentification simple en mémoire et une validation locale des identifiants.

## Évolutions possibles
- Authentification JWT via API REST
- Backend Symfony / Node.js
- PostgreSQL
- Notifications push Firebase
