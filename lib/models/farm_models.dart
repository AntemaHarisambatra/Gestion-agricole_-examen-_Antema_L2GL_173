class FarmUser {
  final int? id;
  final String name;
  final String email;
  final String role;

  const FarmUser({
    this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
  };

  factory FarmUser.fromMap(Map<String, dynamic> map) => FarmUser(
    id: map['id'] as int?,
    name: map['name'] as String? ?? '',
    email: map['email'] as String? ?? '',
    role: map['role'] as String? ?? 'Agriculteur',
  );
}

class Parcel {
  final int? id;
  final String name;
  final double surfaceHa;
  final String location;
  final String cropType;
  final String notes;

  const Parcel({
    this.id,
    required this.name,
    required this.surfaceHa,
    required this.location,
    required this.cropType,
    this.notes = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'surface_ha': surfaceHa,
    'location': location,
    'crop_type': cropType,
    'notes': notes,
  };

  factory Parcel.fromMap(Map<String, dynamic> map) => Parcel(
    id: map['id'] as int?,
    name: map['name'] as String? ?? '',
    surfaceHa: (map['surface_ha'] as num?)?.toDouble() ?? 0,
    location: map['location'] as String? ?? '',
    cropType: map['crop_type'] as String? ?? '',
    notes: map['notes'] as String? ?? '',
  );

  Parcel copyWith({
    int? id,
    String? name,
    double? surfaceHa,
    String? location,
    String? cropType,
    String? notes,
  }) => Parcel(
    id: id ?? this.id,
    name: name ?? this.name,
    surfaceHa: surfaceHa ?? this.surfaceHa,
    location: location ?? this.location,
    cropType: cropType ?? this.cropType,
    notes: notes ?? this.notes,
  );
}

class Crop {
  final int? id;
  final String name;
  final String type;
  final String season;
  final double areaHa;
  final String notes;

  const Crop({
    this.id,
    required this.name,
    required this.type,
    required this.season,
    required this.areaHa,
    this.notes = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'type': type,
    'season': season,
    'area_ha': areaHa,
    'notes': notes,
  };

  factory Crop.fromMap(Map<String, dynamic> map) => Crop(
    id: map['id'] as int?,
    name: map['name'] as String? ?? '',
    type: map['type'] as String? ?? '',
    season: map['season'] as String? ?? '',
    areaHa: (map['area_ha'] as num?)?.toDouble() ?? 0,
    notes: map['notes'] as String? ?? '',
  );
}

class Seed {
  final int? id;
  final String name;
  final String variety;
  final double quantityKg;
  final String supplier;
  final bool isCertified;

  const Seed({
    this.id,
    required this.name,
    required this.variety,
    required this.quantityKg,
    required this.supplier,
    required this.isCertified,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'variety': variety,
    'quantity_kg': quantityKg,
    'supplier': supplier,
    'is_certified': isCertified ? 1 : 0,
  };

  factory Seed.fromMap(Map<String, dynamic> map) => Seed(
    id: map['id'] as int?,
    name: map['name'] as String? ?? '',
    variety: map['variety'] as String? ?? '',
    quantityKg: (map['quantity_kg'] as num?)?.toDouble() ?? 0,
    supplier: map['supplier'] as String? ?? '',
    isCertified: (map['is_certified'] as int?) == 1,
  );
}

class Fertilizer {
  final int? id;
  final String name;
  final String type;
  final double quantityKg;
  final double unitCost;
  final String supplier;

  const Fertilizer({
    this.id,
    required this.name,
    required this.type,
    required this.quantityKg,
    required this.unitCost,
    required this.supplier,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'type': type,
    'quantity_kg': quantityKg,
    'unit_cost': unitCost,
    'supplier': supplier,
  };

  factory Fertilizer.fromMap(Map<String, dynamic> map) => Fertilizer(
    id: map['id'] as int?,
    name: map['name'] as String? ?? '',
    type: map['type'] as String? ?? '',
    quantityKg: (map['quantity_kg'] as num?)?.toDouble() ?? 0,
    unitCost: (map['unit_cost'] as num?)?.toDouble() ?? 0,
    supplier: map['supplier'] as String? ?? '',
  );
}

class Harvest {
  final int? id;
  final String cropName;
  final String parcelName;
  final double quantityKg;
  final DateTime harvestDate;
  final double moisture;
  final String notes;

  const Harvest({
    this.id,
    required this.cropName,
    required this.parcelName,
    required this.quantityKg,
    required this.harvestDate,
    required this.moisture,
    this.notes = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'crop_name': cropName,
    'parcel_name': parcelName,
    'quantity_kg': quantityKg,
    'harvest_date': harvestDate.toIso8601String(),
    'moisture': moisture,
    'notes': notes,
  };

  factory Harvest.fromMap(Map<String, dynamic> map) => Harvest(
    id: map['id'] as int?,
    cropName: map['crop_name'] as String? ?? '',
    parcelName: map['parcel_name'] as String? ?? '',
    quantityKg: (map['quantity_kg'] as num?)?.toDouble() ?? 0,
    harvestDate:
        DateTime.tryParse(map['harvest_date'] as String? ?? '') ??
        DateTime.now(),
    moisture: (map['moisture'] as num?)?.toDouble() ?? 0,
    notes: map['notes'] as String? ?? '',
  );
}

class Expense {
  final int? id;
  final String label;
  final String category;
  final double amount;
  final DateTime expenseDate;
  final String description;

  const Expense({
    this.id,
    required this.label,
    required this.category,
    required this.amount,
    required this.expenseDate,
    this.description = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'label': label,
    'category': category,
    'amount': amount,
    'expense_date': expenseDate.toIso8601String(),
    'description': description,
  };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
    id: map['id'] as int?,
    label: map['label'] as String? ?? '',
    category: map['category'] as String? ?? '',
    amount: (map['amount'] as num?)?.toDouble() ?? 0,
    expenseDate:
        DateTime.tryParse(map['expense_date'] as String? ?? '') ??
        DateTime.now(),
    description: map['description'] as String? ?? '',
  );
}

class YieldRecord {
  final int? id;
  final String parcelName;
  final String cropName;
  final double yieldKg;
  final double productivity;
  final String notes;

  const YieldRecord({
    this.id,
    required this.parcelName,
    required this.cropName,
    required this.yieldKg,
    required this.productivity,
    this.notes = '',
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'parcel_name': parcelName,
    'crop_name': cropName,
    'yield_kg': yieldKg,
    'productivity': productivity,
    'notes': notes,
  };

  factory YieldRecord.fromMap(Map<String, dynamic> map) => YieldRecord(
    id: map['id'] as int?,
    parcelName: map['parcel_name'] as String? ?? '',
    cropName: map['crop_name'] as String? ?? '',
    yieldKg: (map['yield_kg'] as num?)?.toDouble() ?? 0,
    productivity: (map['productivity'] as num?)?.toDouble() ?? 0,
    notes: map['notes'] as String? ?? '',
  );
}
