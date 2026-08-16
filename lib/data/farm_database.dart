import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/farm_models.dart';

class FarmDatabase {
  FarmDatabase._();

  static final FarmDatabase instance = FarmDatabase._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'farm_management.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        role TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE parcels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        surface_ha REAL NOT NULL,
        location TEXT NOT NULL,
        crop_type TEXT NOT NULL,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE crops (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        season TEXT NOT NULL,
        area_ha REAL NOT NULL,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE seeds (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        variety TEXT NOT NULL,
        quantity_kg REAL NOT NULL,
        supplier TEXT NOT NULL,
        is_certified INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE fertilizers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        quantity_kg REAL NOT NULL,
        unit_cost REAL NOT NULL,
        supplier TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE harvests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        crop_name TEXT NOT NULL,
        parcel_name TEXT NOT NULL,
        quantity_kg REAL NOT NULL,
        harvest_date TEXT NOT NULL,
        moisture REAL NOT NULL,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        label TEXT NOT NULL,
        category TEXT NOT NULL,
        amount REAL NOT NULL,
        expense_date TEXT NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE yield_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parcel_name TEXT NOT NULL,
        crop_name TEXT NOT NULL,
        yield_kg REAL NOT NULL,
        productivity REAL NOT NULL,
        notes TEXT
      )
    ''');

    await db.insert(
      'users',
      const FarmUser(
        name: 'Amina K.',
        email: 'admin@ferme.com',
        role: 'Administrateur',
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'users',
      const FarmUser(
        name: 'Yacine B.',
        email: 'agriculteur@ferme.com',
        role: 'Agriculteur',
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'parcels',
      const Parcel(
        name: 'Lot Nord',
        surfaceHa: 8.5,
        location: 'Meknes',
        cropType: 'Blé',
        notes: 'Bonne exposition',
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'parcels',
      const Parcel(
        name: 'Lot Sud',
        surfaceHa: 5.2,
        location: 'Agadir',
        cropType: 'Tomate',
        notes: 'Irrigation goutte à goutte',
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'crops',
      const Crop(
        name: 'Blé',
        type: 'Céréale',
        season: 'Printemps',
        areaHa: 6.4,
        notes: 'Culture principale',
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'crops',
      const Crop(
        name: 'Tomate',
        type: 'Légume',
        season: 'Automne',
        areaHa: 3.7,
        notes: 'Très rentable',
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'seeds',
      const Seed(
        name: 'Semence blé',
        variety: 'Sahara 12',
        quantityKg: 120,
        supplier: 'AgriSup',
        isCertified: true,
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'fertilizers',
      const Fertilizer(
        name: 'Engrais NPK',
        type: 'Composé',
        quantityKg: 400,
        unitCost: 18.5,
        supplier: 'GreenPlus',
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'harvests',
      Harvest(
        cropName: 'Blé',
        parcelName: 'Lot Nord',
        quantityKg: 2800,
        harvestDate: DateTime.now().subtract(const Duration(days: 18)),
        moisture: 12.4,
        notes: 'Récolte satisfaisante',
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'expenses',
      Expense(
        label: 'Fuel',
        category: 'Transport',
        amount: 540,
        expenseDate: DateTime.now().subtract(const Duration(days: 10)),
        description: 'Essence pour tracteurs',
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'yield_records',
      YieldRecord(
        parcelName: 'Lot Nord',
        cropName: 'Blé',
        yieldKg: 1320,
        productivity: 155,
        notes: 'Rendement moyen',
      ).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Parcel>> getParcels() async {
    final db = await database;
    final rows = await db.query('parcels', orderBy: 'id DESC');
    return rows.map(Parcel.fromMap).toList();
  }

  Future<int> insertParcel(Parcel parcel) async {
    final db = await database;
    return db.insert(
      'parcels',
      parcel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateParcel(Parcel parcel) async {
    final db = await database;
    return db.update(
      'parcels',
      parcel.toMap(),
      where: 'id = ?',
      whereArgs: [parcel.id],
    );
  }

  Future<int> deleteParcel(int id) async {
    final db = await database;
    return db.delete('parcels', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Crop>> getCrops() async {
    final db = await database;
    final rows = await db.query('crops', orderBy: 'id DESC');
    return rows.map(Crop.fromMap).toList();
  }

  Future<int> insertCrop(Crop crop) async {
    final db = await database;
    return db.insert(
      'crops',
      crop.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCrop(Crop crop) async {
    final db = await database;
    return db.update(
      'crops',
      crop.toMap(),
      where: 'id = ?',
      whereArgs: [crop.id],
    );
  }

  Future<int> deleteCrop(int id) async {
    final db = await database;
    return db.delete('crops', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Seed>> getSeeds() async {
    final db = await database;
    final rows = await db.query('seeds', orderBy: 'id DESC');
    return rows.map(Seed.fromMap).toList();
  }

  Future<int> insertSeed(Seed seed) async {
    final db = await database;
    return db.insert(
      'seeds',
      seed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateSeed(Seed seed) async {
    final db = await database;
    return db.update(
      'seeds',
      seed.toMap(),
      where: 'id = ?',
      whereArgs: [seed.id],
    );
  }

  Future<int> deleteSeed(int id) async {
    final db = await database;
    return db.delete('seeds', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Fertilizer>> getFertilizers() async {
    final db = await database;
    final rows = await db.query('fertilizers', orderBy: 'id DESC');
    return rows.map(Fertilizer.fromMap).toList();
  }

  Future<int> insertFertilizer(Fertilizer fertilizer) async {
    final db = await database;
    return db.insert(
      'fertilizers',
      fertilizer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateFertilizer(Fertilizer fertilizer) async {
    final db = await database;
    return db.update(
      'fertilizers',
      fertilizer.toMap(),
      where: 'id = ?',
      whereArgs: [fertilizer.id],
    );
  }

  Future<int> deleteFertilizer(int id) async {
    final db = await database;
    return db.delete('fertilizers', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Harvest>> getHarvests() async {
    final db = await database;
    final rows = await db.query('harvests', orderBy: 'id DESC');
    return rows.map(Harvest.fromMap).toList();
  }

  Future<int> insertHarvest(Harvest harvest) async {
    final db = await database;
    return db.insert(
      'harvests',
      harvest.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateHarvest(Harvest harvest) async {
    final db = await database;
    return db.update(
      'harvests',
      harvest.toMap(),
      where: 'id = ?',
      whereArgs: [harvest.id],
    );
  }

  Future<int> deleteHarvest(int id) async {
    final db = await database;
    return db.delete('harvests', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final rows = await db.query('expenses', orderBy: 'id DESC');
    return rows.map(Expense.fromMap).toList();
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await database;
    return db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<YieldRecord>> getYieldRecords() async {
    final db = await database;
    final rows = await db.query('yield_records', orderBy: 'id DESC');
    return rows.map(YieldRecord.fromMap).toList();
  }

  Future<int> insertYieldRecord(YieldRecord record) async {
    final db = await database;
    return db.insert(
      'yield_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateYieldRecord(YieldRecord record) async {
    final db = await database;
    return db.update(
      'yield_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteYieldRecord(int id) async {
    final db = await database;
    return db.delete('yield_records', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FarmUser>> getUsers() async {
    final db = await database;
    final rows = await db.query('users', orderBy: 'id DESC');
    return rows.map(FarmUser.fromMap).toList();
  }
}
