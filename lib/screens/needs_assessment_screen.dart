import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/needs_model.dart';
import '../providers/evaluation_provider.dart';

class NeedsAssessmentScreen extends StatelessWidget {
  const NeedsAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EvaluationProvider>(context);
    final needs = provider.needs;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 主要用途
          _buildCard(
            context,
            title: '1. 您主要的用車場景？',
            icon: Icons.directions_car,
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: UsageType.values.map((type) {
                final isSelected = needs.selectedUsage == type;
                return ChoiceChip(
                  label: Text(needs.getUsageLabel(type)),
                  selected: isSelected,
                  selectedColor: Colors.black,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) provider.setUsage(type);
                  },
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 16),

          // 2. 購車考量權重
          _buildCard(
            context,
            title: '2. 各項指標的重要性 (1-5分)',
            icon: Icons.tune,
            child: Column(
              children: [
                _buildSliderRow(context, '預算敏感度', needs.importanceBudget, (v) => provider.setImportanceBudget(v), Icons.attach_money),
                _buildSliderRow(context, '空間機能性', needs.importanceSpace, (v) => provider.setImportanceSpace(v), Icons.aspect_ratio),
                _buildSliderRow(context, '油耗經濟性', needs.importanceFuel, (v) => provider.setImportanceFuel(v), Icons.local_gas_station),
                _buildSliderRow(context, '動力操控感', needs.importancePower, (v) => provider.setImportancePower(v), Icons.speed),
                _buildSliderRow(context, '乘坐舒適度', needs.importanceComfort, (v) => provider.setImportanceComfort(v), Icons.airline_seat_recline_normal),
                _buildSliderRow(context, '二手保值性', needs.importanceResale, (v) => provider.setImportanceResale(v), Icons.currency_exchange),
                _buildSliderRow(context, '科技與輔助', needs.importanceTech, (v) => provider.setImportanceTech(v), Icons.smart_toy), // New
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. 偏好動力 (Optional)
          _buildCard(
            context,
            title: '3. 特殊動力偏好 (關鍵過濾)',
            icon: Icons.electric_bolt,
            child: DropdownButtonFormField<PowertrainType>(
              value: needs.preferredPowertrain,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text("無特別偏好")),
                ...PowertrainType.values.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(needs.getPowertrainLabel(type)),
                )),
              ],
              onChanged: (val) => provider.setPreferredPowertrain(val!), // Assuming nullable handling in provider
            ),
          ),

          const SizedBox(height: 24),

          // 4. 分析結果
          if (needs.selectedUsage != null)
            _buildResultCard(context, needs),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black87),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow(BuildContext context, String label, double value, Function(double) onChanged, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: 1.0,
              max: 5.0,
              divisions: 4,
              activeColor: Colors.black,
              label: value.toStringAsFixed(0),
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(value.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, NeedsModel needs) {
    final axis = needs.recommendedAxis;
    final models = needs.recommendedModels;
    final isAxisA = axis.contains("Axis A");
    final color = isAxisA ? Colors.indigo : Colors.amber.shade900;
    final bgColor = isAxisA ? Colors.indigo.shade50 : Colors.amber.shade50;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isAxisA ? Icons.directions_run : Icons.balance, color: color, size: 28),
              const SizedBox(width: 8),
              Text('分析結果：購車人格', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Text(axis, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 16),
          const Text('為您量身推薦的車款：', style: TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: models.map((model) => Chip(
              label: Text(model, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            )).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            isAxisA 
              ? '您重視駕馭樂趣與靈活的空間運用，適合設計新穎、機能強大的跨界休旅。' 
              : '您重視穩定性、經濟性與舒適度，適合口碑良好、持有成本低且保值的務實車款。',
            style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
