enum UsageType {
  commute, // 市區通勤
  longDistance, // 長途行駛
  family, // 家庭載運
  performance, // 性能操控
}

enum PowertrainType {
  gasoline, // 燃油
  hybrid, // 油電
  electric, // 純電
}

class NeedsModel {
  UsageType? selectedUsage;
  PowertrainType? preferredPowertrain;

  NeedsModel({this.selectedUsage, this.preferredPowertrain});

  // 根據用途推薦動力類型的邏輯
  List<PowertrainType> get recommendedPowertrains {
    switch (selectedUsage) {
      case UsageType.commute:
        return [PowertrainType.electric, PowertrainType.hybrid];
      case UsageType.longDistance:
        return [PowertrainType.hybrid, PowertrainType.gasoline];
      case UsageType.family:
        return [PowertrainType.hybrid, PowertrainType.gasoline, PowertrainType.electric];
      case UsageType.performance:
        return [PowertrainType.gasoline, PowertrainType.electric];
      default:
        return PowertrainType.values;
    }
  }

  String getUsageLabel(UsageType type) {
    switch (type) {
      case UsageType.commute:
        return '市區通勤 (走走停停)';
      case UsageType.longDistance:
        return '長途行駛 (高速巡航)';
      case UsageType.family:
        return '家庭載運 (空間舒適)';
      case UsageType.performance:
        return '熱血操控 (性能取向)';
    }
  }
  
  String getPowertrainLabel(PowertrainType type) {
     switch (type) {
      case PowertrainType.gasoline:
        return '燃油 (Gasoline)';
      case PowertrainType.hybrid:
        return '油電 (Hybrid)';
      case PowertrainType.electric:
        return '純電 (EV)';
    }
  }
}
