import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vehicle_model.dart';

class VehicleProvider with ChangeNotifier {
  List<Vehicle> _builtinVehicles = [];
  List<Vehicle> _customVehicles = [];
  bool _isLoading = false;
  String? _error;
  DateTime? _lastFetchTime;

  List<Vehicle> get vehicles => [..._builtinVehicles, ..._customVehicles];
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastFetchTime => _lastFetchTime;

  // Fallback data (Used if asset loading fails)
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
      category: '轎車',
      imageUrls: [
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v1/front.jpg',
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v1/side.jpg',
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v1/interior.jpg'
      ],
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
      category: '轎車',
      imageUrls: [
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v2/front.jpg',
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v2/side.jpg'
      ],
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
      category: '休旅車',
      imageUrls: [
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v3/front.jpg'
      ],
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
      category: '轎車',
      imageUrls: [
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v1/front.jpg'
      ],
    ),
     const Vehicle(
      id: 'v5',
      brand: 'Toyota',
      model: 'Corolla Cross 1.8 Hybrid 旗艦',
      price: 985000,
      displacement: 1798,
      horsepower: 122.0,
      torque: 14.5,
      avgFuelConsumption: 21.9,
      transmission: 'E-CVT 電子控制無段變速',
      frontSuspension: '麥花臣',
      rearSuspension: '扭力樑',
      engineType: '油電混合',
      category: '休旅車',
      maintenanceCost60k: 28000,
      partsPrices: {
        '前保桿': 5500,
        '頭燈總成': 9000,
        '照後鏡': 3000
      },
      reliabilityScore: 91,
      imageUrls: [
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v5/front.jpg'
      ],
    ),
    const Vehicle(
      id: 'v6',
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
      category: '休旅車',
      maintenanceCost60k: 42000,
      partsPrices: {
        '前保桿': 5500,
        '頭燈總成': 32000,
        '照後鏡': 7500
      },
      reliabilityScore: 88,
      imageUrls: [
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v6/front.jpg',
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v6/leftside.jpg',
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v6/rightside.jpg',
        'https://raw.githubusercontent.com/tyboy0407/TestCarApp/main/assets/images/vehicles/v6/back.jpg'
      ],
    ),
  ];

  static const String _customVehiclesKey = 'custom_vehicles';

  VehicleProvider() {
    _builtinVehicles = [..._fallbackVehicles];
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
      // Load built-in data from local assets
      await _loadFromAssets();
      print('Vehicle data initialized from local assets.');
    } catch (e) {
      print('Local asset load failed: $e. Using fallback data.');
      _builtinVehicles = [..._fallbackVehicles];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFromAssets() async {
    try {
      final String jsonString = await rootBundle.loadString('vehicles.json');
      final List<dynamic> data = json.decode(jsonString);
      _builtinVehicles = data.map((json) => Vehicle.fromJson(json)).toList();
      _lastFetchTime = DateTime.now();
    } catch (e) {
      print('Error loading from assets: $e');
      rethrow;
    }
  }

  void addVehicle(Vehicle vehicle) {
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

    final builtinIndex = _builtinVehicles.indexWhere((v) => v.id == vehicle.id);
    if (builtinIndex >= 0) {
      // Moving modified built-in vehicle to custom list to persist changes locally
      _builtinVehicles.removeAt(builtinIndex);
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
