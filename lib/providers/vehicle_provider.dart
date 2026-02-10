import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vehicle_model.dart';

class VehicleProvider with ChangeNotifier {
  // CONFIG: The URL pointing to your GitHub repository's raw vehicles.json
  static const String _dataUrl = 'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/vehicles.json'; 

  List<Vehicle> _remoteVehicles = [];
  List<Vehicle> _customVehicles = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _lastFetchTime;

  List<Vehicle> get vehicles => [..._remoteVehicles, ..._customVehicles];
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastFetchTime => _lastFetchTime;

  // Fallback data (Offline cache)
  final List<Vehicle> _fallbackVehicles = [
    const Vehicle(
      id: 'v1',
      brand: 'Toyota',
      model: 'Corolla Altis 1.8 汽油尊爵',
      price: 885000,
      displacement: 1798,
      horsepower: 140.0,
      torque: 17.5,
      avgFuelConsumption: 14.9,
      transmission: 'Super CVT-i 無段變速',
      frontSuspension: '麥花臣',
      rearSuspension: '扭力樑',
      engineType: '自然進氣',
      maintenanceCost60k: 24000,
      partsPrices: {'前保桿': 4500, '頭燈總成': 6000, '照後鏡': 2500},
      reliabilityScore: 92,
    ),
    const Vehicle(
      id: 'v2',
      brand: 'Ford',
      model: 'Focus 5D ST-Line Vignale',
      price: 979000,
      displacement: 1497,
      horsepower: 182.0,
      torque: 24.5,
      avgFuelConsumption: 16.7, 
      transmission: 'SelectShift™ 8速手自排',
      frontSuspension: '麥花臣',
      rearSuspension: '多連桿',
      engineType: '渦輪增壓',
      maintenanceCost60k: 35040,
      partsPrices: {'前保桿': 5500, '頭燈總成': 12000, '照後鏡': 3500},
      reliabilityScore: 78,
    ),
    const Vehicle(
      id: 'v3',
      brand: 'Honda',
      model: 'CR-V 1.5 VTi-S',
      price: 1059000,
      displacement: 1498,
      horsepower: 193.0,
      torque: 24.8,
      avgFuelConsumption: 14.7,
      transmission: 'CVT 無段變速',
      frontSuspension: '麥花臣',
      rearSuspension: '多連桿',
      engineType: '渦輪增壓',
      maintenanceCost60k: 30497,
      partsPrices: {'前保桿': 6500, '頭燈總成': 9500, '照後鏡': 4000},
      reliabilityScore: 88,
    ),
     const Vehicle(
      id: 'v4',
      brand: 'Toyota',
      model: 'Corolla Altis Hybrid 旗艦',
      price: 930000,
      displacement: 1798,
      horsepower: 122.0, 
      torque: 14.5, 
      avgFuelConsumption: 25.3,
      transmission: 'E-CVT 電子控制無段變速',
      frontSuspension: '麥花臣',
      rearSuspension: '扭力樑',
      engineType: '油電混合',
      maintenanceCost60k: 26000,
      partsPrices: {'前保桿': 4500, '頭燈總成': 8000, '照後鏡': 2500},
      reliabilityScore: 94,
    ),
    const Vehicle(
      id: 'v5',
      brand: 'Kia',
      model: 'Stonic 1.0T 智慧油電 GT-line',
      price: 889000,
      displacement: 998,
      horsepower: 120.0,
      torque: 20.4,
      avgFuelConsumption: 19.9,
      transmission: '7 速雙離合器自手排',
      frontSuspension: '麥花臣式',
      rearSuspension: '扭力樑式',
      engineType: '渦輪增壓直列 3 缸 + 48V 輕油電系統',
      maintenanceCost60k: 42000,
      partsPrices: {'前保桿': 5500, '頭燈總成': 32000, '照後鏡': 7500},
      reliabilityScore: 88,
    ),
  ];

  static const String _customVehiclesKey = 'custom_vehicles';

  VehicleProvider() {
    _remoteVehicles = [..._fallbackVehicles];
    _loadCustomVehicles();
    fetchVehicles();
  }

  Future<void> _loadCustomVehicles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customJson = prefs.getString(_customVehiclesKey);
      if (customJson != null) {
        final List<dynamic> data = json.decode(customJson);
        _customVehicles = data.map((j) => Vehicle.fromJson(j)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error loading custom vehicles: $e');
    }
  }

  Future<void> _saveCustomVehicles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customJson = json.encode(_customVehicles.map((v) => v.toJson()).toList());
      await prefs.setString(_customVehiclesKey, customJson);
    } catch (e) {
      print('Error saving custom vehicles: $e');
    }
  }

  Future<void> fetchVehicles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // 1. Load from local assets first
      await _loadFromAssets();

      // 2. Attempt to fetch from remote and merge
      final response = await http.get(Uri.parse(_dataUrl)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> remoteData = json.decode(response.body);
        final List<Vehicle> remoteList = remoteData.map((json) => Vehicle.fromJson(json)).toList();
        
        // Merge strategy: Use a Map to de-duplicate by ID, prioritizing local/current data
        final Map<String, Vehicle> mergedMap = {};
        
        // Add remote vehicles first
        for (var v in remoteList) {
          mergedMap[v.id] = v;
        }
        
        // Add/Overwrite with local vehicles (treating local changes as priority)
        for (var v in _remoteVehicles) {
          mergedMap[v.id] = v;
        }

        _remoteVehicles = mergedMap.values.toList();
        _lastFetchTime = DateTime.now();
        _error = null;
        print('Vehicle data merged with remote source.');
      } 
    } catch (e) {
      print('Remote fetch failed or timed out: $e. Using local data.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromAssets() async {
    try {
      final String jsonString = await rootBundle.loadString('vehicles.json');
      final List<dynamic> data = json.decode(jsonString);
      _remoteVehicles = data.map((json) => Vehicle.fromJson(json)).toList();
      _lastFetchTime = DateTime.now();
      print('Vehicle data loaded from local assets.');
    } catch (e) {
      print('Error loading from assets: $e');
      // If asset loading also fails, we still have the _fallbackVehicles in _remoteVehicles from constructor
    }
  }

  void addVehicle(Vehicle vehicle) {
    // If it's a custom vehicle (not from remote), add to custom list
    _customVehicles.add(vehicle);
    _saveCustomVehicles();
    notifyListeners();
  }

  void updateVehicle(Vehicle vehicle) {
    final customIndex = _customVehicles.indexWhere((v) => v.id == vehicle.id);
    if (customIndex >= 0) {
      _customVehicles[customIndex] = vehicle;
      _saveCustomVehicles();
      notifyListeners();
      return;
    }

    final remoteIndex = _remoteVehicles.indexWhere((v) => v.id == vehicle.id);
    if (remoteIndex >= 0) {
      // If we update a remote vehicle, it becomes a "customized" version?
      // For now, let's just update it in the remote list (in-memory) 
      // or move it to custom if we want it to persist.
      // Usually, users editing a built-in vehicle want to save their changes.
      _remoteVehicles.removeAt(remoteIndex);
      _customVehicles.add(vehicle);
      _saveCustomVehicles();
      notifyListeners();
    }
  }

  Vehicle? findById(String id) {
    try {
      return vehicles.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }
}
