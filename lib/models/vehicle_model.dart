class Vehicle {
  final String id;
  final String brand;
  final String model;
  final int price; // NTD
  final int displacement; // cc
  final double horsepower; // hp
  final double torque; // kgm
  final double avgFuelConsumption; // km/L
  final String transmission;
  final String frontSuspension;
  final String rearSuspension;
  final String engineType; // e.g., Turbo, NA, Hybrid
  
  // New Fields for Ownership Cost
  final int maintenanceCost60k; // Total cost for 0-60,000 km
  final Map<String, int> partsPrices; // e.g., {'bumper': 4500, 'headlight': 6000}
  final int reliabilityScore; // 1-100

  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.price,
    required this.displacement,
    required this.horsepower,
    required this.torque,
    required this.avgFuelConsumption,
    required this.transmission,
    required this.frontSuspension,
    required this.rearSuspension,
    required this.engineType,
    this.maintenanceCost60k = 0,
    this.partsPrices = const {},
    this.reliabilityScore = 0,
  });

  // Factory constructor to create a Vehicle from JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      price: json['price'] as int,
      displacement: json['displacement'] as int,
      horsepower: (json['horsepower'] as num).toDouble(),
      torque: (json['torque'] as num).toDouble(),
      avgFuelConsumption: (json['avgFuelConsumption'] as num).toDouble(),
      transmission: json['transmission'] as String,
      frontSuspension: json['frontSuspension'] as String,
      rearSuspension: json['rearSuspension'] as String,
      engineType: json['engineType'] as String,
      maintenanceCost60k: json['maintenanceCost60k'] as int? ?? 0,
      partsPrices: (json['partsPrices'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ?? const {},
      reliabilityScore: json['reliabilityScore'] as int? ?? 0,
    );
  }

  // Method to convert Vehicle to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'price': price,
      'displacement': displacement,
      'horsepower': horsepower,
      'torque': torque,
      'avgFuelConsumption': avgFuelConsumption,
      'transmission': transmission,
      'frontSuspension': frontSuspension,
      'rearSuspension': rearSuspension,
      'engineType': engineType,
      'maintenanceCost60k': maintenanceCost60k,
      'partsPrices': partsPrices,
      'reliabilityScore': reliabilityScore,
    };
  }

  // Taiwan Tax Calculation Logic (Gasoline)
  // License Tax
  int get licenseTax {
    if (displacement <= 500) return 1620;
    if (displacement <= 600) return 2160;
    if (displacement <= 1200) return 4320;
    if (displacement <= 1800) return 7120;
    if (displacement <= 2400) return 11230;
    if (displacement <= 3000) return 15210;
    if (displacement <= 3600) return 28220;
    if (displacement <= 4200) return 46170;
    if (displacement <= 4800) return 46170; 
    if (displacement <= 5400) return 46170;
    if (displacement <= 6000) return 69690;
    if (displacement <= 6600) return 69690;
    return 117000; // > 6601
  }

  // Fuel Tax (Gasoline)
  int get fuelTax {
    if (displacement <= 500) return 2160; 
    if (displacement <= 600) return 2880;
    if (displacement <= 1200) return 4320;
    if (displacement <= 1800) return 4800;
    if (displacement <= 2400) return 6180;
    if (displacement <= 3000) return 7200;
    if (displacement <= 3600) return 8640;
    if (displacement <= 4200) return 9840;
    if (displacement <= 4800) return 11220;
    if (displacement <= 5400) return 12180;
    if (displacement <= 6000) return 13080;
    if (displacement <= 6600) return 13980;
    return 14640; // > 6601
  }

  int get totalTax => licenseTax + fuelTax;

  String get fullName => '$brand $model';
}
