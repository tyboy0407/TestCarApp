import '../models/vehicle_model.dart';

enum UsageType {
  commute, // 市區通勤
  longDistance, // 長途行駛
  family, // 家庭載運
  performance, // 性能操控
  outdoor, // 戶外休閒
}

class NeedsModel {
  UsageType? selectedUsage;

  // Criteria (Score 1-5, set by user sliders)
  double importanceBudget = 3.0; 
  double importanceSpace = 3.0; 
  double importanceFuel = 3.0; 
  double importancePower = 3.0; 
  double importanceSafety = 3.0; 
  double importanceComfort = 3.0; 
  double importanceResale = 3.0; 
  double importanceTech = 3.0; // New: 科技與輔助駕駛

  NeedsModel({this.selectedUsage});

  Map<String, dynamic> toJson() {
    return {
      'selectedUsage': selectedUsage?.index,
      'importanceBudget': importanceBudget,
      'importanceSpace': importanceSpace,
      'importanceFuel': importanceFuel,
      'importancePower': importancePower,
      'importanceSafety': importanceSafety,
      'importanceComfort': importanceComfort,
      'importanceResale': importanceResale,
      'importanceTech': importanceTech,
    };
  }

  factory NeedsModel.fromJson(Map<String, dynamic> json) {
    final model = NeedsModel(
      selectedUsage: json['selectedUsage'] != null ? UsageType.values[json['selectedUsage']] : null,
    );
    model.importanceBudget = (json['importanceBudget'] as num?)?.toDouble() ?? 3.0;
    model.importanceSpace = (json['importanceSpace'] as num?)?.toDouble() ?? 3.0;
    model.importanceFuel = (json['importanceFuel'] as num?)?.toDouble() ?? 3.0;
    model.importancePower = (json['importancePower'] as num?)?.toDouble() ?? 3.0;
    model.importanceSafety = (json['importanceSafety'] as num?)?.toDouble() ?? 3.0;
    model.importanceComfort = (json['importanceComfort'] as num?)?.toDouble() ?? 3.0;
    model.importanceResale = (json['importanceResale'] as num?)?.toDouble() ?? 3.0;
    model.importanceTech = (json['importanceTech'] as num?)?.toDouble() ?? 3.0;
    return model;
  }

  // Dynamic Calculation using vehicles from JSON
  List<Map<String, dynamic>> calculateRankedResults(List<Vehicle> allVehicles) {
    if (allVehicles.isEmpty) return [];

    // 1. Map Vehicle to Scored Profiles
    var scoredCars = allVehicles.map((v) {
      double totalScore = 0;
      
      // Calculate individual scores (normalized 1-5)
      double scoreBudget = (1600000 - v.price).clamp(0, 1000000) / 250000 + 1; 
      double scoreSpace = (v.category.contains('休旅') || v.category.contains('SUV')) ? 5.0 : 3.0;
      double scoreFuel = (v.avgFuelConsumption - 10).clamp(0, 15) / 3.75 + 1;
      double scorePower = (v.horsepower - 100).clamp(0, 100) / 25 + 1;
      double scoreSafety = (v.reliabilityScore / 20).clamp(1, 5);
      double scoreComfort = (v.price > 1200000) ? 5.0 : (v.price > 900000 ? 4.0 : 3.0);
      double scoreResale = (v.brand == 'Toyota' || v.brand == 'Lexus') ? 5.0 : (v.brand == 'Honda' ? 4.0 : 3.0);
      double scoreTech = v.engineType.contains('Hybrid') ? 4.5 : (v.engineType.contains('純電') ? 5.0 : 3.0);

      // A. Weighted Score
      totalScore += scoreBudget * importanceBudget;
      totalScore += scoreSpace * importanceSpace;
      totalScore += scoreFuel * importanceFuel;
      totalScore += scorePower * importancePower;
      totalScore += scoreSafety * importanceSafety;
      totalScore += scoreComfort * importanceComfort;
      totalScore += scoreResale * importanceResale;
      totalScore += scoreTech * importanceTech;

      // B. Usage Bonus
      if (selectedUsage != null) {
        switch (selectedUsage!) {
          case UsageType.commute:
            if (scoreFuel >= 4.0 || scoreComfort >= 4.0) totalScore += 10;
            break;
          case UsageType.longDistance:
            if (scoreFuel >= 4.0 || scoreSafety >= 4.0) totalScore += 10;
            break;
          case UsageType.family:
            if (scoreSpace >= 4.0 || scoreSafety >= 4.0) totalScore += 10;
            break;
          case UsageType.performance:
            if (scorePower >= 4.0) totalScore += 15;
            break;
          case UsageType.outdoor:
            if (v.category.contains('休旅') || scoreSpace >= 5.0) totalScore += 15;
            break;
        }
      }

      return {'name': '${v.brand} ${v.model}', 'score': totalScore, 'isAxisA': (scorePower + scoreSpace > 7)};
    }).toList();

    scoredCars.sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));
    return scoredCars.take(3).toList();
  }

  String getRecommendedAxis(List<Map<String, dynamic>> rankedResults) {
    if (rankedResults.isEmpty) return "Axis B: 穩定務實與都會通勤";
    return rankedResults.first['isAxisA'] == true 
      ? "Axis A: 駕馭靈活與空間機能" 
      : "Axis B: 穩定務實與都會通勤";
  }

  String getUsageLabel(UsageType type) {
    switch (type) {
      case UsageType.commute: return '市區通勤 (都會代步)';
      case UsageType.longDistance: return '長途行駛 (高速巡航)';
      case UsageType.family: return '家庭載運 (空間需求)';
      case UsageType.performance: return '熱血操控 (駕駛樂趣)';
      case UsageType.outdoor: return '戶外休閒 (上山下海)';
    }
  }
}
