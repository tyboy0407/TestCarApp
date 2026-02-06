import 'package:flutter/material.dart';
import '../models/financial_model.dart';
import '../models/needs_model.dart';

class EvaluationProvider with ChangeNotifier {
  // 核心數據模型
  final NeedsModel _needs = NeedsModel();
  final FinancialModel _financial = FinancialModel();

  // Getter
  NeedsModel get needs => _needs;
  FinancialModel get financial => _financial;

  // --- 需求相關操作 ---
  void setUsage(UsageType usage) {
    _needs.selectedUsage = usage;
    notifyListeners();
  }

  void setPreferredPowertrain(PowertrainType type) {
    _needs.preferredPowertrain = type;
    notifyListeners();
  }

  void setImportanceBudget(double val) { _needs.importanceBudget = val; notifyListeners(); }
  void setImportanceSpace(double val) { _needs.importanceSpace = val; notifyListeners(); }
  void setImportanceFuel(double val) { _needs.importanceFuel = val; notifyListeners(); }
  void setImportancePower(double val) { _needs.importancePower = val; notifyListeners(); }
  void setImportanceSafety(double val) { _needs.importanceSafety = val; notifyListeners(); }
  void setImportanceComfort(double val) { _needs.importanceComfort = val; notifyListeners(); }
  void setImportanceResale(double val) { _needs.importanceResale = val; notifyListeners(); }
  void setImportanceTech(double val) { _needs.importanceTech = val; notifyListeners(); } // New

  // --- 財務相關操作 ---
  
  // 更新車價
  void setVehiclePrice(double price) {
    _financial.vehiclePrice = price;
    notifyListeners();
  }

  // 更新頭期款
  void setDownPayment(double payment) {
    _financial.downPayment = payment;
    notifyListeners();
  }

  // 更新貸款期數
  void setLoanTerm(int months) {
    _financial.loanTermMonths = months;
    notifyListeners();
  }

  // 更新利率
  void setInterestRate(double rate) {
    _financial.interestRate = rate;
    notifyListeners();
  }
  
  // 更新月里程
  void setMonthlyMileage(double mileage) {
    _financial.monthlyMileage = mileage;
    notifyListeners();
  }

  // 更新能耗 (油耗/電耗)
  void setFuelEfficiency(double efficiency) {
    _financial.fuelEfficiency = efficiency;
    notifyListeners();
  }
  
  // 更新能源單價
  void setEnergyPrice(double price) {
    _financial.energyPrice = price;
    notifyListeners();
  }

  // 更新其他持有成本 (一次性更新多個較小的項目)
  void updateHoldingCosts({
    double? tax,
    double? maintenance,
    double? insurance,
    double? otherCosts,
  }) {
    if (tax != null) _financial.tax = tax;
    if (maintenance != null) _financial.maintenance = maintenance;
    if (insurance != null) _financial.insurance = insurance;
    if (otherCosts != null) _financial.otherCosts = otherCosts;
    notifyListeners();
  }
}