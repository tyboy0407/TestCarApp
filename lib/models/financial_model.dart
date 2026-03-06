import 'dart:math';

class FinancialModel {
  // 購車預算參數
  double vehiclePrice; // 車價 (萬)
  double downPayment; // 頭期款 (萬)
  int loanTermMonths; // 貸款期數 (月)
  double interestRate; // 年利率 (%)

  // 現有財務狀況 (月度)
  double monthlyIncome; // 現有收入 (新增)
  double monthlyLivingExpenses; // 生活支出 (新增)

  // 持有成本參數 (年化)
  double monthlyMileage; // 月行駛里程 (km) - Changed from Annual
  double fuelEfficiency; // 油耗 (km/L) 或 電耗 (km/kWh)
  double energyPrice; // 油價 (元/L) 或 電價 (元/kWh)
  int displacement; // CC 數 (新增)
  double maintenance; // 保養維修 (元/年)
  double insurance; // 保險 (元/年)
  double otherCosts; // 停車費等其他雜支 (元/年)

  FinancialModel({
    this.vehiclePrice = 100.0,
    this.downPayment = 20.0,
    this.loanTermMonths = 60,
    this.interestRate = 2.5,
    this.monthlyIncome = 50000, // 預設 5 萬
    this.monthlyLivingExpenses = 30000, // 預設 3 萬
    this.monthlyMileage = 1250, // Default approx 15000 km / year
    this.fuelEfficiency = 15.0,
    this.energyPrice = 30.0,
    this.displacement = 1800, // 預設 1800cc
    this.maintenance = 10000,
    this.insurance = 20000,
    this.otherCosts = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'vehiclePrice': vehiclePrice,
      'downPayment': downPayment,
      'loanTermMonths': loanTermMonths,
      'interestRate': interestRate,
      'monthlyIncome': monthlyIncome,
      'monthlyLivingExpenses': monthlyLivingExpenses,
      'monthlyMileage': monthlyMileage,
      'fuelEfficiency': fuelEfficiency,
      'energyPrice': energyPrice,
      'displacement': displacement,
      'maintenance': maintenance,
      'insurance': insurance,
      'otherCosts': otherCosts,
    };
  }

  factory FinancialModel.fromJson(Map<String, dynamic> json) {
    return FinancialModel(
      vehiclePrice: (json['vehiclePrice'] as num?)?.toDouble() ?? 100.0,
      downPayment: (json['downPayment'] as num?)?.toDouble() ?? 20.0,
      loanTermMonths: json['loanTermMonths'] as int? ?? 60,
      interestRate: (json['interestRate'] as num?)?.toDouble() ?? 2.5,
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 50000.0,
      monthlyLivingExpenses: (json['monthlyLivingExpenses'] as num?)?.toDouble() ?? 30000.0,
      monthlyMileage: (json['monthlyMileage'] as num?)?.toDouble() ?? 1250,
      fuelEfficiency: (json['fuelEfficiency'] as num?)?.toDouble() ?? 15.0,
      energyPrice: (json['energyPrice'] as num?)?.toDouble() ?? 30.0,
      displacement: json['displacement'] as int? ?? 1800,
      maintenance: (json['maintenance'] as num?)?.toDouble() ?? 10000,
      insurance: (json['insurance'] as num?)?.toDouble() ?? 20000,
      otherCosts: (json['otherCosts'] as num?)?.toDouble() ?? 0,
    );
  }

  // 還款佔比 (每月貸款 / 每月收入)
  double get paymentToIncomeRatio {
    if (monthlyIncome <= 0) return 0;
    return monthlyPayment / monthlyIncome;
  }

  // 是否超過警示線 (20%)
  bool get isRatioWarning => paymentToIncomeRatio > 0.20;

  // --- 台灣牌燃稅計算邏輯 ---
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
    return 117000;
  }

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
    return 14640;
  }

  double get tax => (licenseTax + fuelTax).toDouble();

  // 貸款金額 (萬)
  double get loanAmount => vehiclePrice - downPayment;

  // 月付金計算 (本息平均攤還法)
  // 公式: 每月應付本息金額之平均攤還率 ＝{[(1＋月利率)^月數]×月利率}÷{[(1＋月利率)^月數]－1}
  double get monthlyPayment {
    if (loanTermMonths <= 0) return 0;
    if (loanAmount <= 0) return 0;
    if (interestRate <= 0) return (loanAmount * 10000) / loanTermMonths;

    double monthlyRate = interestRate / 100 / 12;
    double factor = pow(1 + monthlyRate, loanTermMonths).toDouble();
    
    // 計算結果為元
    return (loanAmount * 10000) * ((factor * monthlyRate) / (factor - 1));
  }

  // 每月能源費用 (New)
  double get monthlyEnergyCost {
    if (fuelEfficiency <= 0) return 0;
    return (monthlyMileage / fuelEfficiency) * energyPrice;
  }

  // 年度能源費用
  double get annualEnergyCost => monthlyEnergyCost * 12;

  // 總持有成本 (TCO) - 核心公式調整
  // 邏輯: 【車價 + 牌燃稅 + 保險 + 預估油資/電費 + 定期保養】
  // 註: 這裡以「年度」為單位來估算維護成本，車價則為總額
  double get totalCostOfOwnership {
    return (vehiclePrice * 10000) + tax + insurance + annualEnergyCost + maintenance;
  }
  
  // 每月平均持有成本 (不含車價，僅含運作開銷)
  double get monthlyHoldingCost {
    double fixedMonthlyCost = (tax + maintenance + insurance + otherCosts) / 12;
    return monthlyEnergyCost + fixedMonthlyCost;
  }

  // 每月總支出 (貸款月付金 + 平均持有成本)
  double get monthlyTotalCashOutflow => monthlyPayment + monthlyHoldingCost;
}
