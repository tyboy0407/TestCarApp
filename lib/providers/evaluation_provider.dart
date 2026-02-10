import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/financial_model.dart';
import '../models/needs_model.dart';

class EvaluationProvider with ChangeNotifier {
  // 核心數據模型
  NeedsModel _needs = NeedsModel();
  FinancialModel _financial = FinancialModel();

  // Getter
  NeedsModel get needs => _needs;
  FinancialModel get financial => _financial;

  EvaluationProvider() {
    _loadFromPrefs();
  }

  static const String _needsKey = 'evaluation_needs';
  static const String _financialKey = 'evaluation_financial';

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final needsJson = prefs.getString(_needsKey);
      if (needsJson != null) {
        _needs = NeedsModel.fromJson(json.decode(needsJson));
      }
      
      final financialJson = prefs.getString(_financialKey);
      if (financialJson != null) {
        _financial = FinancialModel.fromJson(json.decode(financialJson));
      }
      
      notifyListeners();
    } catch (e) {
      print('Error loading evaluation data: $e');
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_needsKey, json.encode(_needs.toJson()));
      await prefs.setString(_financialKey, json.encode(_financial.toJson()));
    } catch (e) {
      print('Error saving evaluation data: $e');
    }
  }

  // --- 需求相關操作 ---
  void setUsage(UsageType usage) {
    _needs.selectedUsage = usage;
    _saveToPrefs();
    notifyListeners();
  }

  void setPreferredPowertrain(PowertrainType type) {
    _needs.preferredPowertrain = type;
    _saveToPrefs();
    notifyListeners();
  }

  void setImportanceBudget(double val) { _needs.importanceBudget = val; _saveToPrefs(); notifyListeners(); }
  void setImportanceSpace(double val) { _needs.importanceSpace = val; _saveToPrefs(); notifyListeners(); }
  void setImportanceFuel(double val) { _needs.importanceFuel = val; _saveToPrefs(); notifyListeners(); }
  void setImportancePower(double val) { _needs.importancePower = val; _saveToPrefs(); notifyListeners(); }
  void setImportanceSafety(double val) { _needs.importanceSafety = val; _saveToPrefs(); notifyListeners(); }
  void setImportanceComfort(double val) { _needs.importanceComfort = val; _saveToPrefs(); notifyListeners(); }
  void setImportanceResale(double val) { _needs.importanceResale = val; _saveToPrefs(); notifyListeners(); }
  void setImportanceTech(double val) { _needs.importanceTech = val; _saveToPrefs(); notifyListeners(); } // New

  // --- 財務相關操作 ---
  
  // 更新車價
  void setVehiclePrice(double price) {
    _financial.vehiclePrice = price;
    _saveToPrefs();
    notifyListeners();
  }

  // 更新頭期款
  void setDownPayment(double payment) {
    _financial.downPayment = payment;
    _saveToPrefs();
    notifyListeners();
  }

  // 更新貸款期數
  void setLoanTerm(int months) {
    _financial.loanTermMonths = months;
    _saveToPrefs();
    notifyListeners();
  }

  // 更新利率
  void setInterestRate(double rate) {
    _financial.interestRate = rate;
    _saveToPrefs();
    notifyListeners();
  }
  
  // 更新月里程
  void setMonthlyMileage(double mileage) {
    _financial.monthlyMileage = mileage;
    _saveToPrefs();
    notifyListeners();
  }

  // 更新能耗 (油耗/電耗)
  void setFuelEfficiency(double efficiency) {
    _financial.fuelEfficiency = efficiency;
    _saveToPrefs();
    notifyListeners();
  }
  
  // 更新能源單價
  void setEnergyPrice(double price) {
    _financial.energyPrice = price;
    _saveToPrefs();
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
    _saveToPrefs();
    notifyListeners();
  }
}