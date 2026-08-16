import 'package:flutter/foundation.dart';

import '../data/farm_database.dart';
import '../models/farm_models.dart';

class FarmProvider extends ChangeNotifier {
  final FarmDatabase _db = FarmDatabase.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  FarmUser? _currentUser;
  FarmUser? get currentUser => _currentUser;

  List<Parcel> parcels = [];
  List<Crop> crops = [];
  List<Seed> seeds = [];
  List<Fertilizer> fertilizers = [];
  List<Harvest> harvests = [];
  List<Expense> expenses = [];
  List<YieldRecord> yieldRecords = [];

  bool get isAuthenticated => _currentUser != null;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await loadAll();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Impossible de charger les données : $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAll() async {
    parcels = await _db.getParcels();
    crops = await _db.getCrops();
    seeds = await _db.getSeeds();
    fertilizers = await _db.getFertilizers();
    harvests = await _db.getHarvests();
    expenses = await _db.getExpenses();
    yieldRecords = await _db.getYieldRecords();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final normalized = email.trim().toLowerCase();
    final users = await _db.getUsers();

    final match = users.firstWhere(
      (user) => user.email.toLowerCase() == normalized,
      orElse: () => const FarmUser(name: '', email: '', role: ''),
    );

    final validCredentials = {
      'admin@ferme.com': 'admin123',
      'agriculteur@ferme.com': 'agri123',
    };

    if (match.email.isEmpty || validCredentials[normalized] != password) {
      _errorMessage =
          'Identifiants incorrects. Utilisez admin@ferme.com / admin123';
      notifyListeners();
      return false;
    }

    _currentUser = match;
    _errorMessage = null;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> createParcel(Parcel parcel) async {
    await _db.insertParcel(parcel);
    await loadAll();
  }

  Future<void> updateParcel(Parcel parcel) async {
    await _db.updateParcel(parcel);
    await loadAll();
  }

  Future<void> deleteParcel(int id) async {
    await _db.deleteParcel(id);
    await loadAll();
  }

  Future<void> createCrop(Crop crop) async {
    await _db.insertCrop(crop);
    await loadAll();
  }

  Future<void> updateCrop(Crop crop) async {
    await _db.updateCrop(crop);
    await loadAll();
  }

  Future<void> deleteCrop(int id) async {
    await _db.deleteCrop(id);
    await loadAll();
  }

  Future<void> createSeed(Seed seed) async {
    await _db.insertSeed(seed);
    await loadAll();
  }

  Future<void> updateSeed(Seed seed) async {
    await _db.updateSeed(seed);
    await loadAll();
  }

  Future<void> deleteSeed(int id) async {
    await _db.deleteSeed(id);
    await loadAll();
  }

  Future<void> createFertilizer(Fertilizer fertilizer) async {
    await _db.insertFertilizer(fertilizer);
    await loadAll();
  }

  Future<void> updateFertilizer(Fertilizer fertilizer) async {
    await _db.updateFertilizer(fertilizer);
    await loadAll();
  }

  Future<void> deleteFertilizer(int id) async {
    await _db.deleteFertilizer(id);
    await loadAll();
  }

  Future<void> createHarvest(Harvest harvest) async {
    await _db.insertHarvest(harvest);
    await loadAll();
  }

  Future<void> updateHarvest(Harvest harvest) async {
    await _db.updateHarvest(harvest);
    await loadAll();
  }

  Future<void> deleteHarvest(int id) async {
    await _db.deleteHarvest(id);
    await loadAll();
  }

  Future<void> createExpense(Expense expense) async {
    await _db.insertExpense(expense);
    await loadAll();
  }

  Future<void> updateExpense(Expense expense) async {
    await _db.updateExpense(expense);
    await loadAll();
  }

  Future<void> deleteExpense(int id) async {
    await _db.deleteExpense(id);
    await loadAll();
  }

  Future<void> createYieldRecord(YieldRecord record) async {
    await _db.insertYieldRecord(record);
    await loadAll();
  }

  Future<void> updateYieldRecord(YieldRecord record) async {
    await _db.updateYieldRecord(record);
    await loadAll();
  }

  Future<void> deleteYieldRecord(int id) async {
    await _db.deleteYieldRecord(id);
    await loadAll();
  }

  double get totalExpenses =>
      expenses.fold(0, (sum, item) => sum + item.amount);

  double get totalSeedVolume =>
      seeds.fold(0, (sum, item) => sum + item.quantityKg);

  double get totalFertilizerVolume =>
      fertilizers.fold(0, (sum, item) => sum + item.quantityKg);

  double get totalHarvestedKg =>
      harvests.fold(0, (sum, item) => sum + item.quantityKg);

  double get averageYield => yieldRecords.isEmpty
      ? 0
      : yieldRecords.fold(0.0, (sum, item) => sum + item.productivity) /
            yieldRecords.length;
}
