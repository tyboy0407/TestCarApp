import 'dart:math';

class FinancialModel {
  // 購車預算參數
  double vehiclePrice; // 車價 (萬)
  double downPayment; // 頭期款 (萬)
  int loanTermMonths; // 貸款期數 (月)
  double interestRate; // 年利率 (%)

  // 持有成本參數 (年化)
  double annualMileage; // 年行駛里程 (km)
  double fuelEfficiency; // 油耗 (km/L) 或 電耗 (km/kWh)
  double energyPrice; // 油價 (元/L) 或 電價 (元/kWh)
  double tax; // 稅金 (牌照+燃料)
  double maintenance; // 保養維修 (元/年)
  double insurance; // 保險 (元/年)
  double otherCosts; // 停車費等其他雜支 (元/年)

  FinancialModel({
    this.vehiclePrice = 100.0,
    this.downPayment = 20.0,
    this.loanTermMonths = 60,
    this.interestRate = 2.5,
    this.annualMileage = 15000,
    this.fuelEfficiency = 15.0,
    this.energyPrice = 30.0,
    this.tax = 11920,
    this.maintenance = 10000,
    this.insurance = 20000,
    this.otherCosts = 0,
  });

  // 貸款金額 (萬)
  double get loanAmount => vehiclePrice - downPayment;

  // 月付金計算 (本息平均攤還法)
  // 公式: 每月應付本息金額之平均攤還率 ＝{[(1＋月利率)^月數]×月利率}÷{[(1＋月利率)^月數]－1}
  double get monthlyPayment {
    if (loanAmount <= 0) return 0;
    if (interestRate <= 0) return (loanAmount * 10000) / loanTermMonths;

    double monthlyRate = interestRate / 100 / 12;
    double factor = pow(1 + monthlyRate, loanTermMonths).toDouble();
    
    // 計算結果為元
    return (loanAmount * 10000) * ((factor * monthlyRate) / (factor - 1));
  }

  // 年度能源費用
  double get annualEnergyCost {
    if (fuelEfficiency <= 0) return 0;
    return (annualMileage / fuelEfficiency) * energyPrice;
  }

  // 總持有成本 (TCO) - 年化
  double get annualTotalCostOfOwnership {
    // 若貸款還在期間內，將年化貸款支出計入 (這是一種簡化的現金流視角)
    // 但通常 TCO 是指 折舊 + 費用。
    // 這裡我們採用「現金流支出」視角：能源 + 稅金 + 保養 + 保險 + 雜支
    // (不包含折舊，因為那是非現金支出，也不包含貸款本金，那是資產購置)
    
    return annualEnergyCost + tax + maintenance + insurance + otherCosts;
  }
  
  // 每月平均持有成本 (不含貸款)
  double get monthlyHoldingCost => annualTotalCostOfOwnership / 12;

  // 每月總支出 (貸款月付金 + 平均持有成本)
  double get monthlyTotalCashOutflow => monthlyPayment + monthlyHoldingCost;
}
