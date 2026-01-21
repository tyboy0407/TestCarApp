import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/vehicle_model.dart';

class VehicleProvider with ChangeNotifier {
  // CONFIG: Replace this URL with your hosted JSON file URL
  static const String _dataUrl = 'https://raw.githubusercontent.com/your-repo/vehicle-data/main/vehicles.json'; 

  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String? _error;

  List<Vehicle> get vehicles => [..._vehicles];
  bool get isLoading => _isLoading;
  String? get error => _error;

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
      maintenanceCost60k: 26000, // Hybrid might be slightly higher due to checks, but brakes wear less. Similar range.
      partsPrices: {'前保桿': 4500, '頭燈總成': 8000, '照後鏡': 2500}, // Hybrid headlight might be pricier
      reliabilityScore: 94,
    ),
  ];

  VehicleProvider() {
    _vehicles = [..._fallbackVehicles];
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    _isLoading = true;
    try {
      final response = await http.get(Uri.parse(_dataUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _vehicles = data.map((json) => Vehicle.fromJson(json)).toList();
        _error = null;
        print('Vehicle data updated from remote source.');
      } else {
        print('Failed to load remote data, using fallback. Status: ${response.statusCode}');
        _error = 'Failed to load data';
      }
    } catch (e) {
      print('Network error fetching vehicle data: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addVehicle(Vehicle vehicle) {
    _vehicles.add(vehicle);
    notifyListeners();
  }

  void updateVehicle(Vehicle vehicle) {
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index >= 0) {
      _vehicles[index] = vehicle;
      notifyListeners();
    }
  }

  Vehicle? findById(String id) {
    try {
      return _vehicles.firstWhere((v) => v.id == id);
    } catch (e) {
      return null;
    }
  }
}
