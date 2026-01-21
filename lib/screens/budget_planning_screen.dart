import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/evaluation_provider.dart';

class BudgetPlanningScreen extends StatelessWidget {
  const BudgetPlanningScreen({super.key});

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
          
          _buildSectionTitle(context, '⛽ 持有成本估算 (年度)'),
          _buildInputCard([
            _buildTextField('年行駛里程 (km)', f.annualMileage.toString(), (v) => provider.setAnnualMileage(double.tryParse(v) ?? 0)),
            _buildTextField('能耗 (km/L 或 km/kWh)', f.fuelEfficiency.toString(), (v) => provider.setFuelEfficiency(double.tryParse(v) ?? 0)),
            _buildTextField('能源單價 (元)', f.energyPrice.toString(), (v) => provider.setEnergyPrice(double.tryParse(v) ?? 0)),
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
