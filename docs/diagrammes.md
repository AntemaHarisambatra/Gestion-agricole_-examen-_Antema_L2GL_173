# Diagrammes UML

## Diagramme de cas d’utilisation
```mermaid
flowchart LR
    User[Exploitant] --> Login[Connexion]
    Login --> Dashboard[Dashboard]
    Dashboard --> Parcelles[Gestion des parcelles]
    Dashboard --> Cultures[Gestion des cultures]
    Dashboard --> Semences[Gestion des semences]
    Dashboard --> Engrais[Gestion des engrais]
    Dashboard --> Récoltes[Gestion des récoltes]
    Dashboard --> Dépenses[Gestion des dépenses]
    Dashboard --> Rendements[Gestion des rendements]
```

## Diagramme de classes
```mermaid
classDiagram
    class FarmUser {
        +int id
        +String name
        +String email
        +String role
    }
    class Parcel {
        +int id
        +String name
        +double surfaceHa
        +String location
        +String cropType
    }
    class Crop {
        +int id
        +String name
        +String type
        +String season
        +double areaHa
    }
    class Seed {
        +int id
        +String name
        +String variety
        +double quantityKg
        +bool isCertified
    }
    class Fertilizer {
        +int id
        +String name
        +String type
        +double quantityKg
        +double unitCost
    }
    class Harvest {
        +int id
        +String cropName
        +String parcelName
        +double quantityKg
        +DateTime harvestDate
    }
    class Expense {
        +int id
        +String label
        +String category
        +double amount
        +DateTime expenseDate
    }
    class YieldRecord {
        +int id
        +String cropName
        +String parcelName
        +double yieldKg
        +double productivity
    }
    class FarmDatabase {
        +Future<List<Parcel>> getParcels()
        +Future<int> insertParcel(Parcel)
        +Future<int> updateParcel(Parcel)
        +Future<int> deleteParcel(int)
    }
    class FarmProvider {
        +login()
        +initialize()
        +loadAll()
        +createParcel()
        +updateParcel()
        +deleteParcel()
    }
``` 
