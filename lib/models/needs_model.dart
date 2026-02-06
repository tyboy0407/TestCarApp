enum UsageType {
  commute, // 市區通勤
  longDistance, // 長途行駛
  family, // 家庭載運
  performance, // 性能操控
  outdoor, // 戶外休閒
}

enum PowertrainType {
  gasoline, // 燃油
  hybrid, // 油電 (Full Hybrid)
  mildHybrid, // 輕油電
  electric, // 純電 (For Kicks e-POWER logic)
}

class _CarProfile {
  final String name;
  final String axis; // 'A' or 'B'
  final PowertrainType type;
  
  // Scores (1-5)
  final double scoreBudget; // High score = Cheaper
  final double scoreSpace;
  final double scoreFuel;
  final double scorePower;
  final double scoreSafety;
  final double scoreComfort;
  final double scoreResale;
  final double scoreTech; // New!

  const _CarProfile({
    required this.name,
    required this.axis,
    required this.type,
    required this.scoreBudget,
    required this.scoreSpace,
    required this.scoreFuel,
    required this.scorePower,
    required this.scoreSafety,
    required this.scoreComfort,
    required this.scoreResale,
    required this.scoreTech,
  });
}

class NeedsModel {
  UsageType? selectedUsage;
  PowertrainType? preferredPowertrain;

  // Criteria (Score 1-5, set by user sliders)
  double importanceBudget = 3.0; 
  double importanceSpace = 3.0; 
  double importanceFuel = 3.0; 
  double importancePower = 3.0; 
  double importanceSafety = 3.0; 
  double importanceComfort = 3.0; 
  double importanceResale = 3.0; 
  double importanceTech = 3.0; // New: 科技與輔助駕駛

  NeedsModel({this.selectedUsage, this.preferredPowertrain});

  // Internal Database of Cars
  static const List<_CarProfile> _carDatabase = [
    _CarProfile(name: 'Honda HR-V e:HEV', axis: 'A', type: PowertrainType.hybrid, scoreBudget: 3, scoreSpace: 5, scoreFuel: 4, scorePower: 3, scoreSafety: 4, scoreComfort: 3, scoreResale: 4, scoreTech: 3),
    _CarProfile(name: 'Toyota Corolla Cross Hybrid', axis: 'B', type: PowertrainType.hybrid, scoreBudget: 3, scoreSpace: 4, scoreFuel: 5, scorePower: 3, scoreSafety: 4.5, scoreComfort: 5, scoreResale: 5, scoreTech: 3),
    _CarProfile(name: 'Nissan Kicks e-POWER', axis: 'A', type: PowertrainType.electric, scoreBudget: 3, scoreSpace: 3, scoreFuel: 4, scorePower: 5, scoreSafety: 3, scoreComfort: 3, scoreResale: 3, scoreTech: 4),
    _CarProfile(name: 'Hyundai Kona Hybrid', axis: 'A', type: PowertrainType.hybrid, scoreBudget: 3, scoreSpace: 3, scoreFuel: 4.5, scorePower: 4, scoreSafety: 4, scoreComfort: 4, scoreResale: 2, scoreTech: 5), // High tech
    _CarProfile(name: 'Suzuki S-Cross', axis: 'A', type: PowertrainType.mildHybrid, scoreBudget: 3, scoreSpace: 4, scoreFuel: 3, scorePower: 4, scoreSafety: 3, scoreComfort: 3, scoreResale: 3, scoreTech: 3),
    _CarProfile(name: 'Lexus LBX', axis: 'B', type: PowertrainType.hybrid, scoreBudget: 1, scoreSpace: 2, scoreFuel: 5, scorePower: 3, scoreSafety: 5, scoreComfort: 5, scoreResale: 4, scoreTech: 5),
    _CarProfile(name: 'Toyota Yaris Cross', axis: 'B', type: PowertrainType.gasoline, scoreBudget: 5, scoreSpace: 4, scoreFuel: 3, scorePower: 2, scoreSafety: 3, scoreComfort: 3, scoreResale: 4, scoreTech: 2),
    _CarProfile(name: 'Kia Stonic 1.0T', axis: 'B', type: PowertrainType.mildHybrid, scoreBudget: 5, scoreSpace: 3, scoreFuel: 3.5, scorePower: 3, scoreSafety: 3, scoreComfort: 3, scoreResale: 2, scoreTech: 3),
  ];

  // Dynamic Calculation
  List<String> get recommendedModels {
    // 1. Calculate Score for each car
    var scoredCars = _carDatabase.map((car) {
      double totalScore = 0;
      
      // A. Slider Weights
      totalScore += car.scoreBudget * importanceBudget;
      totalScore += car.scoreSpace * importanceSpace;
      totalScore += car.scoreFuel * importanceFuel;
      totalScore += car.scorePower * importancePower;
      totalScore += car.scoreSafety * importanceSafety;
      totalScore += car.scoreComfort * importanceComfort;
      totalScore += car.scoreResale * importanceResale;
      totalScore += car.scoreTech * importanceTech;

      // B. Usage Bonus (Weight: 10 points - significant)
      if (selectedUsage != null) {
        switch (selectedUsage!) {
          case UsageType.commute:
            if (car.scoreFuel >= 4.0 || car.scoreComfort >= 4.0) totalScore += 10;
            break;
          case UsageType.longDistance:
            if (car.scoreFuel >= 4.0 || car.scoreSafety >= 4.0) totalScore += 10;
            break;
          case UsageType.family:
            if (car.scoreSpace >= 4.0 || car.scoreSafety >= 4.0) totalScore += 10;
            break;
          case UsageType.performance:
            if (car.scorePower >= 4.0) totalScore += 15; // Higher bonus for niche
            break;
          case UsageType.outdoor:
             // Specific models known for outdoor/4WD
            if (car.name.contains('S-Cross') || car.scoreSpace >= 5.0) totalScore += 15;
            break;
        }
      }

      // C. Powertrain Preference (Weight: 15 points - critical filter)
      if (preferredPowertrain != null) {
        if (car.type == preferredPowertrain) {
          totalScore += 15;
        } else if (preferredPowertrain == PowertrainType.electric && car.name.contains('Kicks')) {
           // Special case: User wants EV, Kicks e-POWER is closest
           totalScore += 15;
        } else if (preferredPowertrain == PowertrainType.gasoline && car.type == PowertrainType.mildHybrid) {
           // Mild hybrid is close to gas
           totalScore += 5; 
        } else {
           // Penalty for mismatch
           totalScore -= 10;
        }
      }

      return MapEntry(car, totalScore);
    }).toList();

    // 2. Sort by Score Descending
    scoredCars.sort((a, b) => b.value.compareTo(a.value));

    // 3. Return Top 4 names
    return scoredCars.take(4).map((e) => e.key.name).toList();
  }

  String get recommendedAxis {
    // Determine Axis based on the top recommended car
    List<String> topModels = recommendedModels;
    if (topModels.isEmpty) return "Axis B: 穩定務實與都會通勤"; // Default

    var topCar = _carDatabase.firstWhere((c) => c.name == topModels.first);
    
    if (topCar.axis == 'A') {
      return "Axis A: 駕馭靈活與空間機能";
    } else {
      return "Axis B: 穩定務實與都會通勤";
    }
  }

  String getUsageLabel(UsageType type) {
    switch (type) {
      case UsageType.commute:
        return '市區通勤 (都會代步)';
      case UsageType.longDistance:
        return '長途行駛 (高速巡航)';
      case UsageType.family:
        return '家庭載運 (空間需求)';
      case UsageType.performance:
        return '熱血操控 (駕駛樂趣)';
      case UsageType.outdoor:
        return '戶外休閒 (上山下海)';
    }
  }
  
  String getPowertrainLabel(PowertrainType type) {
     switch (type) {
      case PowertrainType.gasoline:
        return '純燃油 (Gasoline)';
      case PowertrainType.hybrid:
        return '油電混合 (Hybrid)';
      case PowertrainType.mildHybrid:
        return '輕油電 (Mild Hybrid)';
      case PowertrainType.electric:
        return '純電動 (EV / e-POWER)';
    }
  }
}
