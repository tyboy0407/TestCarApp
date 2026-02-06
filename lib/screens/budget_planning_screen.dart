import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../providers/evaluation_provider.dart';
import '../providers/vehicle_provider.dart';
import '../models/vehicle_model.dart';

class BudgetPlanningScreen extends StatelessWidget {
  const BudgetPlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black87,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: '貸款試算'),
                Tab(text: '存錢計畫'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                LoanCalculatorTab(),
                SavingGoalTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoanCalculatorTab extends StatelessWidget {
  const LoanCalculatorTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EvaluationProvider>(context);
    final f = provider.financial;
    final currencyFormat = NumberFormat("#,###", "en_US");

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, '💰 購車與貸款試算'),
          _buildInputCard([
            _buildTextField('車價 (萬元)', f.vehiclePrice.toString(), (v) => provider.setVehiclePrice(double.tryParse(v) ?? 0)),
            _buildTextField('頭期款 (萬元)', f.downPayment.toString(), (v) => provider.setDownPayment(double.tryParse(v) ?? 0)),
            _buildTextField('貸款期數 (月)', f.loanTermMonths.toString(), (v) => provider.setLoanTerm(int.tryParse(v) ?? 0)),
            _buildTextField('年利率 (%)', f.interestRate.toString(), (v) => provider.setInterestRate(double.tryParse(v) ?? 0)),
          ]),
          
          const SizedBox(height: 16),
          _buildResultCard('每月貸款負擔', 'NT\$ ${currencyFormat.format(f.monthlyPayment.round())}', Colors.orange),

          const Divider(height: 40),
          
          _buildSectionTitle(context, '⛽ 持有成本估算 (月度)'),
          _buildInputCard([
            _buildTextField('月行駛里程 (km)', f.monthlyMileage.toString(), (v) => provider.setMonthlyMileage(double.tryParse(v) ?? 0)),
            _buildTextField('能耗 (km/L 或 km/kWh)', f.fuelEfficiency.toString(), (v) => provider.setFuelEfficiency(double.tryParse(v) ?? 0)),
            _buildTextField('能源單價 (元)', f.energyPrice.toString(), (v) => provider.setEnergyPrice(double.tryParse(v) ?? 0)),
            
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('預估每月能源支出:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  Text(
                    'NT\$ ${currencyFormat.format(f.monthlyEnergyCost.round())}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent)
                  ),
                ],
              ),
            ),
          ]),

          const SizedBox(height: 16),
          _buildResultCard('每月平均總支出', 'NT\$ ${currencyFormat.format(f.monthlyTotalCashOutflow.round())}', Colors.blue),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: Text(
              '(包含貸款 \$${currencyFormat.format(f.monthlyPayment.round())} + 持有成本 \$${currencyFormat.format(f.monthlyHoldingCost.round())})',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInputCard(List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(labelText: label),
        keyboardType: TextInputType.number,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildResultCard(String title, String value, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class SavingGoalTab extends StatefulWidget {
  const SavingGoalTab({super.key});

  @override
  State<SavingGoalTab> createState() => _SavingGoalTabState();
}

class _SavingGoalTabState extends State<SavingGoalTab> {
  Vehicle? _selectedVehicle;
  final TextEditingController _priceController = TextEditingController();
  double _monthlySavings = 0;
  
  // Loan params
  bool _isLoan = false; // Toggle between Cash (false) and Loan (true)
  double _downPayment = 200000; // Default down payment (NT$)
  int _loanTermMonths = 60;
  double _interestRate = 3.5;

  final _currencyFormat = NumberFormat("#,###", "en_US");

  @override
  void initState() {
    super.initState();
    // Initialize price controller listener to update state if needed, though we parse on demand usually
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final vehicles = vehicleProvider.vehicles;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, '🎯 存錢買車計畫'),
          const SizedBox(height: 8),
          const Text('設定目標車價與付款方式，計算需要多久才能達成目標。', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. 選擇車型與確認價格', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Autocomplete<Vehicle>(
                    displayStringForOption: (Vehicle option) => option.fullName,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<Vehicle>.empty();
                      }
                      return vehicles.where((Vehicle option) {
                        return option.fullName.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (Vehicle selection) {
                      setState(() {
                        _selectedVehicle = selection;
                        _priceController.text = selection.price.toString();
                        // Default down payment 20%
                        _downPayment = selection.price * 0.2; 
                      });
                    },
                    fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                       return TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          hintText: '搜尋車款 (例如: Altis, Focus...)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.directions_car),
                          labelText: '選擇車型 (選填)',
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: '車輛目標成交價 (NT\$)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.price_change),
                      helperText: '可自行修改實際成交價格',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        // update down payment default if user changes price manually and hasn't set custom down payment? 
                        // Keep it simple, just refresh UI
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          
          // Payment Method Switch
          Card(
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text('2. 付款方式', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                   const SizedBox(height: 12),
                   SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment<bool>(value: false, label: Text('全額現金'), icon: Icon(Icons.money)),
                      ButtonSegment<bool>(value: true, label: Text('貸款購車'), icon: Icon(Icons.credit_score)),
                    ],
                    selected: <bool>{_isLoan},
                    onSelectionChanged: (Set<bool> newSelection) {
                      setState(() {
                        _isLoan = newSelection.first;
                      });
                    },
                  ),
                  
                  if (_isLoan) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text('貸款條件設定', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _downPayment.toStringAsFixed(0),
                      decoration: const InputDecoration(
                        labelText: '頭期款金額 (NT\$)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_balance_wallet),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => setState(() => _downPayment = double.tryParse(v) ?? 0),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: _loanTermMonths.toString(),
                            decoration: const InputDecoration(
                              labelText: '期數 (月)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => setState(() => _loanTermMonths = int.tryParse(v) ?? 0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: _interestRate.toString(),
                            decoration: const InputDecoration(
                              labelText: '年利率 (%)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => setState(() => _interestRate = double.tryParse(v) ?? 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                 ],
               ),
             ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('3. 您的存錢能力', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: '預計每月存入金額 (NT\$)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.savings_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _monthlySavings = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          if (_priceController.text.isNotEmpty && _monthlySavings > 0)
            _buildResult(),
            
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildResult() {
    double price = double.tryParse(_priceController.text) ?? 0;
    if (price <= 0 || _monthlySavings <= 0) return const SizedBox.shrink();

    // Calculate Targets
    double targetAmount = price;
    String targetLabel = '全額車價';
    
    // Loan specific calculations
    double? totalLoanCost;
    double? monthlyLoanPayment;
    double? totalInterest;
    
    if (_isLoan) {
      targetAmount = _downPayment;
      targetLabel = '頭期款';
      
      double loanAmount = price - _downPayment;
      if (loanAmount > 0 && _loanTermMonths > 0) {
        double monthlyRate = (_interestRate / 100) / 12;
        double factor = pow(1 + monthlyRate, _loanTermMonths).toDouble();
        if (_interestRate > 0) {
           monthlyLoanPayment = (loanAmount * ((factor * monthlyRate) / (factor - 1)));
        } else {
           monthlyLoanPayment = loanAmount / _loanTermMonths;
        }
        totalLoanCost = _downPayment + (monthlyLoanPayment * _loanTermMonths);
        totalInterest = totalLoanCost - price;
      }
    }

    // Time to reach primary target (Cash or Down Payment)
    int monthsNeeded = (targetAmount / _monthlySavings).ceil();
    String timeString = _formatDuration(monthsNeeded);

    // Time to save 'Total Loan Cost' (if loan)
    String? totalCostTimeString;
    if (_isLoan && totalLoanCost != null) {
      int totalMonthsNeeded = (totalLoanCost / _monthlySavings).ceil();
      totalCostTimeString = _formatDuration(totalMonthsNeeded);
    }

    String resultTitle = (_selectedVehicle != null) 
        ? '存到 ${_selectedVehicle!.model} $targetLabel所需時間' 
        : '存到$targetLabel所需時間';

    return Column(
      children: [
        // Main Result: Time to Buy (Cash or Downpayment)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade400, Colors.teal.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                resultTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                timeString,
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '目標金額: NT\$ ${_currencyFormat.format(targetAmount.round())}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        
        // Loan Details (Total Cost Perspective)
        if (_isLoan && totalLoanCost != null) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.deepOrange),
                    SizedBox(width: 8),
                    Text('貸款總支出觀點', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('雖然存到頭期款即可買車，但若包含利息，您實際付出的總金額為 NT\$ ${_currencyFormat.format(totalLoanCost.round())} (含利息 \$${_currencyFormat.format(totalInterest?.round() ?? 0)})。'),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('存完總金額所需時間:', style: TextStyle(color: Colors.brown)),
                    Text(
                      totalCostTimeString ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _formatDuration(int totalMonths) {
    if (totalMonths <= 0) return '立即達成';
    final years = totalMonths ~/ 12;
    final months = totalMonths % 12;
    String s = '';
    if (years > 0) s += '$years 年 ';
    if (months > 0) s += '$months 個月';
    if (s.isEmpty) s = '不到 1 個月';
    return s;
  }
  
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
